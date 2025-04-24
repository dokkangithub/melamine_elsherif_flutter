import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/data/datasources/remote/store_api.dart';
import 'package:melamine_elsherif/data/models/currency_model.dart';
import 'package:melamine_elsherif/domain/entities/currency.dart';
import 'package:melamine_elsherif/domain/repositories/currency_repository.dart';

/// Implementation of [CurrencyRepository] that integrates remote data sources
class CurrencyRepositoryImpl implements CurrencyRepository {
  final StoreApi _storeApi;
  final NetworkInfo _networkInfo;

  /// Creates a [CurrencyRepositoryImpl] instance
  CurrencyRepositoryImpl(this._storeApi, this._networkInfo);

  @override
  Future<Either<Failure, List<Currency>>> getCurrencies() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getCurrencies();
        
        final List<CurrencyModel> currencies = [];
        if (response['currencies'] != null) {
          for (final currency in response['currencies']) {
            currencies.add(CurrencyModel.fromJson(currency));
          }
        }
        
        return Right(currencies);
      } catch (e) {
        if (e is ApiException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is NetworkException) {
          return Left(NetworkFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Currency>> getCurrencyByCode(String code) async {
    if (await _networkInfo.isConnected) {
      try {
        final currenciesResult = await getCurrencies();
        
        return currenciesResult.fold(
          (failure) => Left(failure),
          (currencies) {
            final currency = currencies.firstWhere(
              (c) => c.code.toLowerCase() == code.toLowerCase(),
              orElse: () => throw ServerException(message: 'Currency not found'),
            );
            return Right(currency);
          },
        );
      } catch (e) {
        if (e is ApiException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is NetworkException) {
          return Left(NetworkFailure(message: e.message));
        }
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
} 