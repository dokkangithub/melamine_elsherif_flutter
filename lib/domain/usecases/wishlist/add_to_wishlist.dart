import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/domain/repositories/wishlist_repository.dart';

class AddToWishlist implements UseCase<bool, String> {
  final WishlistRepository repository;
  
  AddToWishlist(this.repository);
  
  @override
  Future<Either<Failure, bool>> call(String productId) async {
    return await repository.addToWishlist(productId);
  }
} 