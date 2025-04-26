import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/repositories/wishlist_repository.dart';

class GetWishlist implements UseCase<List<Product>, NoParams> {
  final WishlistRepository repository;
  
  GetWishlist(this.repository);
  
  @override
  Future<Either<Failure, List<Product>>> call([NoParams? params]) async {
    return await repository.getWishlist();
  }
} 