import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/core/error/failures.dart';

/// Repository interface for handling shipping-related operations
abstract class ShippingRepository {
  /// Retrieves all shipping options for a specific region
  /// 
  /// [regionId] The ID of the region to get shipping options for
  /// [isReturn] Optional filter for return shipping options
  Future<Either<Failure, List<ShippingOption>>> getShippingOptions({
    required String regionId,
    bool? isReturn,
  });

  /// Gets a shipping option by its ID
  Future<Either<Failure, ShippingOption>> getShippingOptionById(String id);

  /// Gets available shipping options for a cart
  /// 
  /// [cartId] The ID of the cart to get shipping options for
  Future<Either<Failure, List<ShippingOption>>> getShippingOptionsForCart(String cartId);
} 