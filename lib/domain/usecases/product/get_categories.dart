import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/product_category.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';

/// Gets a list of product categories
class GetCategories implements UseCase<List<ProductCategory>, NoParams> {
  final ProductRepository repository;

  /// Creates a [GetCategories] instance
  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<ProductCategory>>> call(NoParams params) async {
    return await repository.getCategories();
  }
} 