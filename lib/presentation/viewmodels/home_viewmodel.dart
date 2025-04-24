import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/entities/product_category.dart';
import 'package:melamine_elsherif/domain/entities/product_collection.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';
import 'package:melamine_elsherif/presentation/viewmodels/base_viewmodel.dart';

/// ViewModel for managing the home screen state
class HomeViewModel extends BaseViewModel {
  final ProductRepository _productRepository;
  
  /// Featured products
  List<Product> _featuredProducts = [];
  
  /// New arrivals
  List<Product> _newArrivals = [];
  
  /// Popular products
  List<Product> _popularProducts = [];
  
  /// Categories
  List<ProductCategory> _categories = [];
  
  /// Collections
  List<ProductCollection> _collections = [];
  
  /// Constructor
  HomeViewModel(this._productRepository);

  /// Getter for featured products
  List<Product> get featuredProducts => _featuredProducts;
  
  /// Getter for new arrivals
  List<Product> get newArrivals => _newArrivals;
  
  /// Getter for popular products
  List<Product> get popularProducts => _popularProducts;
  
  /// Getter for categories
  List<ProductCategory> get categories => _categories;
  
  /// Getter for collections
  List<ProductCollection> get collections => _collections;

  /// Initializes the home screen data
  Future<void> initHomeData() async {
    setLoading(true);
    try {
      await Future.wait([
        _loadFeaturedProducts(),
        _loadNewArrivals(),
        _loadPopularProducts(),
        _loadCategories(),
        _loadCollections(),
      ]);
      clearError();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Loads featured products
  Future<void> _loadFeaturedProducts() async {
    try {
      final result = await _productRepository.getFeaturedProducts();
      result.fold(
        (failure) => setError(failure.message),
        (products) {
          _featuredProducts = products;
          notifyListeners();
        },
      );
    } catch (e) {
      // Handle error silently, main error will be handled in initHomeData
    }
  }

  /// Loads new arrivals
  Future<void> _loadNewArrivals() async {
    try {
      final result = await _productRepository.getNewArrivals();
      result.fold(
        (failure) => setError(failure.message),
        (products) {
          _newArrivals = products;
          notifyListeners();
        },
      );
    } catch (e) {
      // Handle error silently, main error will be handled in initHomeData
    }
  }

  /// Loads popular products
  Future<void> _loadPopularProducts() async {
    try {
      final result = await _productRepository.getPopularProducts();
      result.fold(
        (failure) => setError(failure.message),
        (products) {
          _popularProducts = products;
          notifyListeners();
        },
      );
    } catch (e) {
      // Handle error silently, main error will be handled in initHomeData
    }
  }

  /// Loads categories
  Future<void> _loadCategories() async {
    try {
      final result = await _productRepository.getCategories();
      result.fold(
        (failure) => setError(failure.message),
        (categories) {
          _categories = categories;
          notifyListeners();
        },
      );
    } catch (e) {
      // Handle error silently, main error will be handled in initHomeData
    }
  }

  /// Loads collections
  Future<void> _loadCollections() async {
    try {
      final result = await _productRepository.getCollections();
      result.fold(
        (failure) => setError(failure.message),
        (collections) {
          _collections = collections;
          notifyListeners();
        },
      );
    } catch (e) {
      // Handle error silently, main error will be handled in initHomeData
    }
  }
} 