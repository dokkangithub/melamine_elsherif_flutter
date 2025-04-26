import 'package:flutter/material.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';
import 'package:melamine_elsherif/domain/entities/product_category.dart';
import 'package:melamine_elsherif/domain/entities/product_collection.dart';
import 'package:melamine_elsherif/core/error/failures.dart';

/// ViewModel for product-related operations
class ProductViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductViewModel({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  // Products state
  List<Product> _products = [];
  List<Product> get products => _products;

  // Featured products state
  List<Product> _featuredProducts = [];
  List<Product> get featuredProducts => _featuredProducts;

  // New arrivals state
  List<Product> _newArrivals = [];
  List<Product> get newArrivals => _newArrivals;

  // Product details state
  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;

  // Related products state
  List<Product> _relatedProducts = [];
  List<Product> get relatedProducts => _relatedProducts;

  // Categories state
  List<ProductCategory> _categories = [];
  List<ProductCategory> get categories => _categories;

  // Collections state
  List<ProductCollection> _collections = [];
  List<ProductCollection> get collections => _collections;

  // Loading states
  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;

  bool _isLoadingFeatured = false;
  bool get isLoadingFeatured => _isLoadingFeatured;

  bool _isLoadingNewArrivals = false;
  bool get isLoadingNewArrivals => _isLoadingNewArrivals;

  bool _isLoadingProductDetails = false;
  bool get isLoadingProductDetails => _isLoadingProductDetails;

  bool _isLoadingRelated = false;
  bool get isLoadingRelated => _isLoadingRelated;

  bool _isLoadingCategories = false;
  bool get isLoadingCategories => _isLoadingCategories;

  bool _isLoadingCollections = false;
  bool get isLoadingCollections => _isLoadingCollections;

  // Error states
  String? _productsError;
  String? get productsError => _productsError;

  String? _featuredError;
  String? get featuredError => _featuredError;

  String? _newArrivalsError;
  String? get newArrivalsError => _newArrivalsError;

  String? _productDetailsError;
  String? get productDetailsError => _productDetailsError;

  String? _relatedError;
  String? get relatedError => _relatedError;

  String? _categoriesError;
  String? get categoriesError => _categoriesError;

  String? _collectionsError;
  String? get collectionsError => _collectionsError;

  /// Fetches products with optional filters
  Future<void> getProducts({
    int? offset,
    int? limit,
    String? search,
    List<String>? categoryIds,
    List<String>? collectionIds,
    List<String>? tagIds,
    String? sortBy,
    bool? sortDesc,
  }) async {
    _isLoadingProducts = true;
    _productsError = null;
    notifyListeners();

    final result = await _productRepository.getProducts(
      offset: offset,
      limit: limit,
      search: search,
      categoryIds: categoryIds,
      collectionIds: collectionIds,
      tagIds: tagIds,
      sortBy: sortBy,
      sortDesc: sortDesc,
    );

    result.fold(
      (failure) {
        _productsError = _getErrorMessage(failure);
        _isLoadingProducts = false;
      },
      (products) {
        _products = products;
        _isLoadingProducts = false;
      },
    );

    notifyListeners();
  }

  /// Fetches featured products
  Future<void> getFeaturedProducts() async {
    _isLoadingFeatured = true;
    _featuredError = null;
    notifyListeners();

    final result = await _productRepository.getFeaturedProducts();

    result.fold(
      (failure) {
        _featuredError = _getErrorMessage(failure);
        _isLoadingFeatured = false;
      },
      (products) {
        _featuredProducts = products;
        _isLoadingFeatured = false;
      },
    );

    notifyListeners();
  }

  /// Fetches new arrival products
  Future<void> getNewArrivals() async {
    _isLoadingNewArrivals = true;
    _newArrivalsError = null;
    notifyListeners();

    final result = await _productRepository.getNewArrivals();

    result.fold(
      (failure) {
        _newArrivalsError = _getErrorMessage(failure);
        _isLoadingNewArrivals = false;
      },
      (products) {
        _newArrivals = products;
        _isLoadingNewArrivals = false;
      },
    );

    notifyListeners();
  }

  /// Fetches product details by ID
  Future<void> getProductById(String id) async {
    _isLoadingProductDetails = true;
    _productDetailsError = null;
    notifyListeners();

    final result = await _productRepository.getProductById(id);

    result.fold(
      (failure) {
        _productDetailsError = _getErrorMessage(failure);
        _isLoadingProductDetails = false;
      },
      (product) {
        _selectedProduct = product;
        _isLoadingProductDetails = false;
        // Fetch related products
        getRelatedProducts(id);
      },
    );

    notifyListeners();
  }

  /// Fetches related products for a product
  Future<void> getRelatedProducts(String productId) async {
    _isLoadingRelated = true;
    _relatedError = null;
    notifyListeners();

    final result = await _productRepository.getRelatedProducts(productId);

    result.fold(
      (failure) {
        _relatedError = _getErrorMessage(failure);
        _isLoadingRelated = false;
      },
      (products) {
        _relatedProducts = products;
        _isLoadingRelated = false;
      },
    );

    notifyListeners();
  }

  /// Fetches all product categories
  Future<void> getCategories() async {
    _isLoadingCategories = true;
    _categoriesError = null;
    notifyListeners();

    final result = await _productRepository.getCategories();

    result.fold(
      (failure) {
        _categoriesError = _getErrorMessage(failure);
        _isLoadingCategories = false;
      },
      (categories) {
        _categories = categories;
        _isLoadingCategories = false;
      },
    );

    notifyListeners();
  }

  /// Fetches all product collections
  Future<void> getCollections() async {
    _isLoadingCollections = true;
    _collectionsError = null;
    notifyListeners();

    final result = await _productRepository.getCollections();

    result.fold(
      (failure) {
        _collectionsError = _getErrorMessage(failure);
        _isLoadingCollections = false;
      },
      (collections) {
        _collections = collections;
        _isLoadingCollections = false;
      },
    );

    notifyListeners();
  }

  /// Fetches products by category ID
  Future<void> getProductsByCategory(String categoryId) async {
    return getProducts(categoryIds: [categoryId]);
  }

  /// Fetches products by collection ID
  Future<void> getProductsByCollection(String collectionId) async {
    return getProducts(collectionIds: [collectionId]);
  }

  /// Searches for products
  Future<void> searchProducts(String query) async {
    return getProducts(search: query);
  }

  /// Helper method to get user-friendly error messages
  String _getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Server error occurred';
    } else if (failure is NetworkFailure) {
      return failure.message ?? 'Network error occurred';
    } else if (failure is CacheFailure) {
      return failure.message ?? 'Cache error occurred';
    }
    return 'An unexpected error occurred';
  }

  /// Clears selected product and related products
  void clearProductDetails() {
    _selectedProduct = null;
    _relatedProducts = [];
    _productDetailsError = null;
    _relatedError = null;
    notifyListeners();
  }
} 