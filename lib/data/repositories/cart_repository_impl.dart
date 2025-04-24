import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/data/datasources/remote/store_api.dart';
import 'package:melamine_elsherif/data/models/cart_model.dart';
import 'package:melamine_elsherif/data/models/shipping_option_model.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/entities/line_item.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';

/// Implementation of [CartRepository] that integrates remote data sources
class CartRepositoryImpl implements CartRepository {
  final StoreApi _storeApi;
  final NetworkInfo _networkInfo;

  /// Creates a [CartRepositoryImpl] instance
  CartRepositoryImpl(this._storeApi, this._networkInfo);

  @override
  Future<Either<Failure, Cart>> createCart() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.createCart();
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> getCart(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getCart(id);
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> updateCart(String id, {
    String? regionId,
    String? email,
    String? billingAddressId,
    String? shippingAddressId,
    Map<String, dynamic>? metadata,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.updateCart(
          id,
          regionId: regionId,
          email: email,
          billingAddressId: billingAddressId,
          shippingAddressId: shippingAddressId,
          metadata: metadata,
        );
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> addLineItem(
    String cartId, 
    String variantId, 
    int quantity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.addLineItem(
          cartId,
          variantId,
          quantity,
        );
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> updateLineItem(
    String cartId,
    String lineItemId,
    int quantity,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.updateLineItem(
          cartId,
          lineItemId,
          quantity,
        );
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> removeLineItem(
    String cartId,
    String lineItemId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.removeLineItem(cartId, lineItemId);
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> addShippingMethod(
    String cartId,
    String optionId,
    Map<String, dynamic>? data,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.addShippingMethod(cartId, optionId, data);
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> createPaymentSessions(String cartId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.createPaymentSessions(cartId);
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> setPaymentSession(
    String cartId,
    String providerId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.setPaymentSession(cartId, providerId);
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Cart>> updatePaymentSession(
    String cartId,
    String providerId,
    Map<String, dynamic> data,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.updatePaymentSession(cartId, providerId, data);
        final cartModel = CartModel.fromJson(response['cart']);
        return Right(cartModel);
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
  Future<Either<Failure, Map<String, dynamic>>> completeCart(String cartId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.completeCart(cartId);
        return Right(response);
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
  Future<Either<Failure, List<ShippingOption>>> getShippingOptions(String cartId) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _storeApi.getShippingOptionsForCart(cartId);
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