import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/data/datasources/remote/cart_api.dart';
import 'package:melamine_elsherif/data/models/cart_model.dart';
import 'package:melamine_elsherif/data/models/shipping_option_model.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Implementation of [CartRepository] that integrates remote data sources
class CartRepositoryImpl implements CartRepository {
  final CartApi _cartApi;
  final NetworkInfo _networkInfo;

  /// Creates a [CartRepositoryImpl] instance
  CartRepositoryImpl({
    required CartApi cartApi,
    required NetworkInfo networkInfo,
  })  : _cartApi = cartApi,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, Cart>> getCart({String? cartId}) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.getCart(cartId: cartId);
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> createCart() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.createCart();
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addItem({
    String? cartId,
    required String variantId,
    int quantity = 1,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.addItem(
        cartId: cartId,
        variantId: variantId,
        quantity: quantity,
      );
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeItem({
    required String cartId,
    required String lineItemId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.removeItem(
        cartId: cartId,
        lineItemId: lineItemId,
      );
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateCart({
    required String cartId,
    String? lineItemId,
    int? quantity,
    String? discountCode,
    String? regionId,
    String? email,
    String? billingAddressId, 
    String? shippingAddressId,
    Map<String, dynamic>? metadata,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.updateCart(
        cartId: cartId,
        lineItemId: lineItemId,
        quantity: quantity,
        discountCode: discountCode,
        regionId: regionId,
        email: email,
        billingAddressId: billingAddressId,
        shippingAddressId: shippingAddressId,
        metadata: metadata,
      );
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> completeCart(String cartId) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.completeCart(cartId);
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addShippingMethod(
    String cartId,
    String optionId,
    Map<String, dynamic>? data,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.addShippingMethod(
        cartId: cartId,
        optionId: optionId,
        data: data,
      );
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> createPaymentSessions(String cartId) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.createPaymentSessions(cartId);
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> setPaymentSession(
    String cartId,
    String providerId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.setPaymentSession(
        cartId: cartId,
        providerId: providerId,
      );
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> updatePaymentSession(
    String cartId,
    String providerId,
    Map<String, dynamic> data,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    
    try {
      final cartData = await _cartApi.updatePaymentSession(
        cartId: cartId,
        providerId: providerId,
        data: data,
      );
      return Right(CartModel.fromJson(cartData));
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShippingOption>>> getShippingOptions(String cartId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _cartApi.getShippingOptionsForCart(cartId);
        final shippingOptions = (response['shipping_options'] as List)
            .map((option) => ShippingOptionModel.fromJson(option))
            .toList();
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