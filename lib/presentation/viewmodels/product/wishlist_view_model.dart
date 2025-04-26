import 'package:flutter/foundation.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/add_to_wishlist.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/get_wishlist.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/remove_from_wishlist.dart';

class WishlistViewModel extends ChangeNotifier {
  final GetWishlist _getWishlist;
  final AddToWishlist _addToWishlist;
  final RemoveFromWishlist _removeFromWishlist;
  
  List<Product> _wishlistItems = [];
  bool _isLoading = false;
  String? _error;
  
  List<Product> get wishlistItems => _wishlistItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  WishlistViewModel({
    required GetWishlist getWishlist,
    required AddToWishlist addToWishlist,
    required RemoveFromWishlist removeFromWishlist,
  }) : _getWishlist = getWishlist,
       _addToWishlist = addToWishlist,
       _removeFromWishlist = removeFromWishlist;
  
  /// Gets the user's wishlist
  Future<void> getWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await _getWishlist();
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (products) {
        _wishlistItems = products;
        _isLoading = false;
      },
    );
    
    notifyListeners();
  }
  
  /// Adds a product to the wishlist
  Future<void> addToWishlist(String productId) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _addToWishlist(productId);
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
      },
      (success) {
        // Refresh wishlist to get updated data
        getWishlist();
      },
    );
    
    notifyListeners();
  }
  
  /// Removes a product from the wishlist
  Future<void> removeFromWishlist(String productId) async {
    _isLoading = true;
    notifyListeners();
    
    final result = await _removeFromWishlist(productId);
    
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (success) {
        // Remove locally without having to refetch from API
        _wishlistItems.removeWhere((product) => product.id == productId);
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  /// Checks if a product is in the wishlist
  bool isInWishlist(String productId) {
    return _wishlistItems.any((product) => product.id == productId);
  }
  
  /// Toggles a product in the wishlist
  Future<void> toggleWishlist(String productId) async {
    if (isInWishlist(productId)) {
      await removeFromWishlist(productId);
    } else {
      await addToWishlist(productId);
    }
  }
} 