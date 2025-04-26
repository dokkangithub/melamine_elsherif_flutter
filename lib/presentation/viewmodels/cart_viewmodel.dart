import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/entities/line_item.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/domain/usecases/cart/add_line_item.dart';
import 'package:melamine_elsherif/domain/usecases/cart/add_shipping_method.dart';
import 'package:melamine_elsherif/domain/usecases/cart/complete_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/create_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/create_payment_sessions.dart';
import 'package:melamine_elsherif/domain/usecases/cart/get_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/get_shipping_options.dart';
import 'package:melamine_elsherif/domain/usecases/cart/remove_line_item.dart';
import 'package:melamine_elsherif/domain/usecases/cart/set_payment_session.dart';
import 'package:melamine_elsherif/domain/usecases/cart/update_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/update_line_item.dart';
import 'package:melamine_elsherif/core/usecases/usecase.dart';
import 'package:melamine_elsherif/presentation/viewmodels/base_viewmodel.dart';

/// ViewModel for managing the shopping cart state
class CartViewModel extends BaseViewModel {
  final CreateCart _createCart;
  final GetCart _getCart;
  final UpdateCart _updateCart;
  final AddLineItem _addLineItem;
  final UpdateLineItem _updateLineItem;
  final RemoveLineItem _removeLineItem;
  final GetShippingOptions _getShippingOptions;
  final AddShippingMethod _addShippingMethod;
  final CreatePaymentSessions _createPaymentSessions;
  final SetPaymentSession _setPaymentSession;
  final CompleteCart _completeCart;
  
  /// The current cart
  Cart? _cart;
  
  /// Available shipping options
  List<ShippingOption> _shippingOptions = [];
  
  /// Order data after successful checkout
  Map<String, dynamic>? _orderData;

  /// Constructor
  CartViewModel({
    required CreateCart createCart,
    required GetCart getCart,
    required UpdateCart updateCart,
    required AddLineItem addLineItem,
    required UpdateLineItem updateLineItem, 
    required RemoveLineItem removeLineItem,
    required GetShippingOptions getShippingOptions,
    required AddShippingMethod addShippingMethod,
    required CreatePaymentSessions createPaymentSessions,
    required SetPaymentSession setPaymentSession,
    required CompleteCart completeCart,
  }) : _createCart = createCart,
       _getCart = getCart,
       _updateCart = updateCart,
       _addLineItem = addLineItem,
       _updateLineItem = updateLineItem,
       _removeLineItem = removeLineItem,
       _getShippingOptions = getShippingOptions,
       _addShippingMethod = addShippingMethod,
       _createPaymentSessions = createPaymentSessions,
       _setPaymentSession = setPaymentSession,
       _completeCart = completeCart;

  /// Getter for the cart
  Cart? get cart => _cart;
  
  /// Getter for cart items
  List<LineItem> get items => _cart?.items ?? [];
  
  /// Getter for subtotal
  double get subtotal => _cart?.subtotal ?? 0;
  
  /// Getter for tax total
  double get taxTotal => _cart?.taxTotal ?? 0;
  
  /// Getter for shipping total
  double get shippingTotal => _cart?.shippingTotal ?? 0;
  
  /// Getter for discount total
  double get discountTotal => _cart?.discountTotal ?? 0;
  
  /// Getter for gift card total
  double get giftCardTotal => _cart?.giftCardTotal ?? 0;
  
  /// Getter for total
  double get total => _cart?.total ?? 0;
  
  /// Getter for item count
  int get itemCount => _cart?.totalItems ?? 0;
  
  /// Getter for cart id
  String? get cartId => _cart?.id;
  
  /// Getter for shipping options
  List<ShippingOption> get shippingOptions => _shippingOptions;
  
  /// Getter for order data
  Map<String, dynamic>? get orderData => _orderData;
  
  /// Getter to check if cart is empty
  bool get isEmpty => _cart?.isEmpty ?? true;

  /// Creates a new cart
  Future<void> createCart() async {
    await runBusyFuture(
      () async {
        final result = await _createCart( NoParams());
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Retrieves an existing cart
  Future<void> getCart(String id) async {
    await runBusyFuture(
      () async {
        final result = await _getCart(GetCartParams(cartId: id));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Updates cart information
  Future<void> updateCart({
    String? regionId,
    String? email,
    String? billingAddressId,
    String? shippingAddressId,
    Map<String, dynamic>? metadata,
  }) async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _updateCart(UpdateCartParams(
          cartId: _cart!.id,
          discountCode: null, // Not used in this context
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Adds an item to the cart
  Future<void> addItem(String variantId, int quantity) async {
    if (_cart == null) {
      await createCart();
      if (_cart == null) return;
    }
    
    await runBusyFuture(
      () async {
        final result = await _addLineItem(AddLineItemParams(
          cartId: _cart!.id,
          variantId: variantId,
          quantity: quantity,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Updates the quantity of an item in the cart
  Future<void> updateItemQuantity(String lineItemId, int quantity) async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _updateLineItem(UpdateLineItemParams(
          cartId: _cart!.id,
          lineItemId: lineItemId,
          quantity: quantity,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }

  /// Removes an item from the cart
  Future<void> removeItem(String lineItemId) async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _removeLineItem(RemoveLineItemParams(
          cartId: _cart!.id,
          lineItemId: lineItemId,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }
  
  /// Gets shipping options for the cart
  Future<void> getShippingOptions() async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _getShippingOptions(GetShippingOptionsParams(
          cartId: _cart!.id,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (options) {
            _shippingOptions = options;
            notifyListeners();
          },
        );
      },
    );
  }
  
  /// Adds a shipping method to the cart
  Future<void> addShippingMethod(String optionId, {Map<String, dynamic>? data}) async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _addShippingMethod(AddShippingMethodParams(
          cartId: _cart!.id,
          optionId: optionId,
          data: data,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }
  
  /// Creates payment sessions for the cart
  Future<void> createPaymentSessions() async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _createPaymentSessions(CreatePaymentSessionsParams(
          cartId: _cart!.id,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }
  
  /// Sets the payment session for the cart
  Future<void> setPaymentSession(String providerId) async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _setPaymentSession(SetPaymentSessionParams(
          cartId: _cart!.id,
          providerId: providerId,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            _cart = cart;
            notifyListeners();
          },
        );
      },
    );
  }
  
  /// Completes the cart and creates an order
  Future<void> completeCart() async {
    if (_cart == null) return;
    
    await runBusyFuture(
      () async {
        final result = await _completeCart(CompleteCartParams(
          cartId: _cart!.id,
        ));
        return result;
      },
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (cart) {
            // Store order information and clear cart
            _orderData = {'orderId': cart.id}; // Convert Cart to Map as needed
            // After successful checkout, we can clear the cart reference
            _cart = null;
            notifyListeners();
          },
        );
      },
    );
  }
} 