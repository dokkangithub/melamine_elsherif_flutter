import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/data/datasources/remote/store_api.dart';
import 'package:melamine_elsherif/data/models/shipping_option_model.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/domain/repositories/shipping_repository.dart';

/// Implementation of [ShippingRepository] that integrates remote data sources
class ShippingRepositoryImpl implements ShippingRepository {
  final StoreApi _storeApi;
  final NetworkInfo _networkInfo;

  /// Creates a [ShippingRepositoryImpl] instance
  ShippingRepositoryImpl(this._storeApi, this._networkInfo);

  @override
  Future<Either<Failure, List<ShippingOption>>> getShippingOptions({
    required String regionId,
    bool? isReturn,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getShippingOptions(
          regionId: regionId,
          isReturn: isReturn,
        );
        
        final List<ShippingOptionModel> shippingOptions = [];
        if (response['shipping_options'] != null) {
          for (final option in response['shipping_options']) {
            shippingOptions.add(ShippingOptionModel.fromJson(option));
          }
        }
        
        return Right(shippingOptions);
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
  Future<Either<Failure, ShippingOption>> getShippingOptionById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getShippingOptionById(id);
        
        if (response['shipping_option'] != null) {
          final shippingOption = ShippingOptionModel.fromJson(response['shipping_option']);
          return Right(shippingOption);
        }
        
        return const Left(NotFoundFailure(message: 'Shipping option not found'));
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
  Future<Either<Failure, List<ShippingOption>>> getShippingOptionsForCart(String cartId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getShippingOptionsForCart(cartId);
        
        final List<ShippingOptionModel> shippingOptions = [];
        if (response['shipping_options'] != null) {
          for (final option in response['shipping_options']) {
            shippingOptions.add(ShippingOptionModel.fromJson(option));
          }
        }
        
        return Right(shippingOptions);
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