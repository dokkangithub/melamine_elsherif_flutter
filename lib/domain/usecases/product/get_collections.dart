import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/product_collection.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';

/// Gets a list of product collections
class GetCollections implements UseCase<List<ProductCollection>, NoParams> {
  final ProductRepository repository;

  /// Creates a [GetCollections] instance
  GetCollections(this.repository);

  @override
  Future<Either<Failure, List<ProductCollection>>> call(NoParams params) async {
    return await repository.getCollections();
  }
} 