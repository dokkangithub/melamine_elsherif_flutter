import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/currency.dart';

/// Repository interface for currency operations
abstract class CurrencyRepository {
  /// Gets all available currencies
  Future<Either<Failure, List<Currency>>> getCurrencies();

  /// Gets a currency by code
  Future<Either<Failure, Currency>> getCurrencyByCode(String code);
} 