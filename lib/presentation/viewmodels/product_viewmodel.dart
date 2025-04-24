import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/entities/product_variant.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';
import 'package:melamine_elsherif/domain/repositories/wishlist_repository.dart';
import 'package:melamine_elsherif/presentation/viewmodels/base_viewmodel.dart';

/// ViewModel for managing product details
class ProductViewModel extends BaseViewModel {
  final ProductRepository _productRepository;
  final WishlistRepository _wishlistRepository;
  
  /// Current product
  Product? _product;
  
  /// Selected variant
  ProductVariant? _selectedVariant;
  
  /// Current quantity
  int _quantity = 1;
  
  /// Loading state
  bool _isLoading = false;
  
  /// Error message
  String? _errorMessage;
  
  /// Wishlist loading state
  bool _isWishlistLoading = false;

  /// Constructor
  ProductViewModel(this._productRepository, this._wishlistRepository);

  /// Getter for product
  Product? get product => _product;
  
  /// Getter for selected variant
  ProductVariant? get selectedVariant => _selectedVariant;
  
  /// Getter for quantity
  int get quantity => _quantity;
  
  /// Getter for loading state
  bool get isLoading => _isLoading;
  
  /// Getter for error message
  String? get errorMessage => _errorMessage;
  
  /// Getter for wishlist loading state
  bool get isWishlistLoading => _isWishlistLoading;
  
  /// Getter for checking if product is in wishlist
  bool get isInWishlist => _product != null && _product!.isInWishlist;

  /// Loads product details by ID
  Future<void> loadProductById(String id) async {
    await runBusyFuture(
      () => _productRepository.getProductById(id),
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (product) {
            _product = product;
            if (product.variants.isNotEmpty) {
              _selectedVariant = product.variants.first;
            }
          },
        );
      },
    );
  }

  /// Loads product details by handle
  Future<void> loadProductByHandle(String handle) async {
    await runBusyFuture(
      () => _productRepository.getProductByHandle(handle),
      onSuccess: (result) {
        result.fold(
          (failure) => setError(failure.message),
          (product) {
            _product = product;
            if (product.variants.isNotEmpty) {
              _selectedVariant = product.variants.first;
            }
          },
        );
      },
    );
  }

  /// Sets the selected variant
  void selectVariant(ProductVariant variant) {
    _selectedVariant = variant;
    notifyListeners();
  }

  /// Updates the quantity
  void updateQuantity(int quantity) {
    if (quantity > 0) {
      _quantity = quantity;
      notifyListeners();
    }
  }

  /// Increments the quantity
  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  /// Decrements the quantity
  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  /// Toggles the product in wishlist
  Future<void> toggleWishlist() async {
    if (_product == null) return;
    
    _isWishlistLoading = true;
    notifyListeners();
    
    try {
      Either<Failure, bool> result;
      
      if (isInWishlist) {
        result = await _wishlistRepository.removeFromWishlist(_product!.id);
      } else {
        result = await _wishlistRepository.addToWishlist(_product!.id);
      }
      
      result.fold(
        (failure) => setError(failure.message),
        (_) async {
          // Refresh product to update wishlist status
          await loadProductById(_product!.id);
        },
      );
    } catch (e) {
      setError(e.toString());
    } finally {
      _isWishlistLoading = false;
      notifyListeners();
    }
  }

  /// Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Helper method to set error message
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
} 