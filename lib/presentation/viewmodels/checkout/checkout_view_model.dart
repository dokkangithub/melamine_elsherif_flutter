import 'package:flutter/foundation.dart';
import 'package:melamine_elsherif/domain/entities/address.dart';
import 'package:melamine_elsherif/domain/entities/cart.dart';
import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/domain/usecases/address/add_address.dart';
import 'package:melamine_elsherif/domain/usecases/address/get_addresses.dart';
import 'package:melamine_elsherif/domain/usecases/cart/get_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/add_shipping_method.dart';
import 'package:melamine_elsherif/domain/usecases/cart/complete_cart.dart';
import 'package:melamine_elsherif/domain/usecases/shipping/get_shipping_options.dart';

class CheckoutViewModel extends ChangeNotifier {
  final GetAddresses _getAddresses;
  final AddAddress _addAddress;
  final GetCart _getCart;
  final GetShippingOptions _getShippingOptions;
  final AddShippingMethod _addShippingMethod;
  final CompleteCart _completeCart;
  
  List<Address> _addresses = [];
  String? _selectedAddressId;
  List<ShippingOption> _shippingOptions = [];
  String? _selectedShippingMethodId;
  Cart? _cart;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Address> get addresses => _addresses;
  String? get selectedAddressId => _selectedAddressId;
  List<ShippingOption> get shippingOptions => _shippingOptions;
  String? get selectedShippingMethodId => _selectedShippingMethodId;
  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Constructor
  CheckoutViewModel({
    required GetAddresses getAddresses,
    required AddAddress addAddress,
    required GetCart getCart,
    required GetShippingOptions getShippingOptions,
    required AddShippingMethod addShippingMethod,
    required CompleteCart completeCart,
  }) : _getAddresses = getAddresses,
       _addAddress = addAddress,
       _getCart = getCart,
       _getShippingOptions = getShippingOptions,
       _addShippingMethod = addShippingMethod,
       _completeCart = completeCart;
  
  /// Retrieve saved addresses
  Future<void> getAddresses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await _getAddresses();
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (addresses) {
        _addresses = addresses;
        
        // Auto-select default address if available
        final defaultAddress = _addresses.firstWhere(
          (address) => address.isDefault == true,
          orElse: () => _addresses.isNotEmpty ? _addresses.first : Address(
            id: '', 
            customerId: '',
            firstName: '',
            lastName: '',
            address1: '',
            city: '',
            country: '',
            phone: '',
          ),
        );
        
        if (defaultAddress.id != null) {
          _selectedAddressId = defaultAddress.id;
        }
        
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Add a new address
  Future<void> addAddress(Address address) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _addAddress(address);
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (success) {
        // Refresh addresses
        getAddresses();
      },
    );
    
    notifyListeners();
  }
  
  /// Select an address
  void selectAddress(String addressId) {
    _selectedAddressId = addressId;
    notifyListeners();
  }
  
  /// Get shipping options
  Future<void> getShippingOptions() async {
    if (_cart?.id == null) {
      await loadCart();
    }
    
    if (_cart?.id == null) {
      _error = 'No active cart';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    final result = await _getShippingOptions(GetShippingOptionsParams(
      cartId: _cart!.id!,
    ));
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (options) {
        _shippingOptions = options;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Select a shipping method
  Future<void> selectShippingMethod(String methodId) async {
    if (_cart?.id == null) {
      _error = 'No active cart';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    final result = await _addShippingMethod(AddShippingMethodParams(
      cartId: _cart!.id!,
      optionId: methodId,
    ));
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (cart) {
        _cart = cart;
        _selectedShippingMethodId = methodId;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Load cart
  Future<void> loadCart() async {
    _isLoading = true;
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
  
  /// Complete checkout
  Future<bool> completeCheckout() async {
    if (_cart?.id == null) {
      _error = 'No active cart';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    notifyListeners();
    
    final result = await _completeCart(CompleteCartParams(
      cartId: _cart!.id!,
    ));
    
    bool success = false;
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (cart) {
        _cart = cart;
        _isLoading = false;
        success = true;
      },
    );
    
    notifyListeners();
    return success;
  }
  
  /// Clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 