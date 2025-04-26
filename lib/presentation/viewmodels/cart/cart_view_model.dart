import 'package:flutter/foundation.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/add_line_item.dart';
import 'package:melamine_elsherif/domain/usecases/cart/get_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/remove_line_item.dart';
import 'package:melamine_elsherif/domain/usecases/cart/update_cart.dart';

class CartViewModel extends ChangeNotifier {
  final GetCart _getCart;
  final AddLineItem _addToCart;
  final RemoveLineItem _removeFromCart;
  final UpdateCart _updateCart;
  
  Cart? _cart;
  bool _isLoading = false;
  String? _error;
  
  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  CartViewModel({
    required GetCart getCart,
    required AddLineItem addLineItem,
    required RemoveLineItem removeLineItem,
    required UpdateCart updateCart,
  }) : _getCart = getCart,
       _addToCart = addLineItem,
       _removeFromCart = removeLineItem,
       _updateCart = updateCart;
  
  /// Loads the cart from the repository
  Future<void> loadCart() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await _getCart();
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (cart) {
        _cart = cart;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Adds an item to the cart
  Future<void> addItem(String variantId, {int quantity = 1}) async {
    _isLoading = true;
    notifyListeners();
    
    if (_cart == null) {
      await loadCart();
      if (_cart == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
    }
    
    final result = await _addToCart(AddLineItemParams(
      cartId: _cart!.id!,
      variantId: variantId,
      quantity: quantity,
    ));
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (cart) {
        _cart = cart;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Removes an item from the cart
  Future<void> removeItem(String lineItemId) async {
    _isLoading = true;
    notifyListeners();
    
    if (_cart == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    final result = await _removeFromCart(RemoveLineItemParams(
      cartId: _cart!.id!,
      lineItemId: lineItemId,
    ));
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (cart) {
        _cart = cart;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Increases the quantity of an item in the cart
  Future<void> increaseQuantity(String lineItemId) async {
    if (_cart == null) return;
    
    final item = _cart!.items.firstWhere(
      (item) => item.id == lineItemId,
      orElse: () => throw Exception('Item not found in cart'),
    );
    
    await _updateItemQuantity(lineItemId, item.quantity! + 1);
  }
  
  /// Decreases the quantity of an item in the cart
  Future<void> decreaseQuantity(String lineItemId) async {
    if (_cart == null) return;
    
    final item = _cart!.items.firstWhere(
      (item) => item.id == lineItemId,
      orElse: () => throw Exception('Item not found in cart'),
    );
    
    if (item.quantity! <= 1) {
      await removeItem(lineItemId);
    } else {
      await _updateItemQuantity(lineItemId, item.quantity! - 1);
    }
  }
  
  /// Updates the quantity of an item in the cart
  Future<void> _updateItemQuantity(String lineItemId, int quantity) async {
    _isLoading = true;
    notifyListeners();
    
    if (_cart == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    final result = await _updateCart(UpdateCartParams(
      cartId: _cart!.id!,
      lineItemId: lineItemId,
      quantity: quantity,
    ));
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (cart) {
        _cart = cart;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Applies a discount to the cart
  Future<void> applyDiscount(String code) async {
    _isLoading = true;
    notifyListeners();
    
    if (_cart == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    
    // This would usually call a specific use case for applying discounts
    // For now, we'll just update the cart
    final result = await _updateCart(UpdateCartParams(
      cartId: _cart!.id!,
      discountCode: code,
    ));
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (cart) {
        _cart = cart;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Clears any error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 