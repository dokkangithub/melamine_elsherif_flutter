import 'dart:convert';

import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/data/models/product_model.dart';
import 'package:melamine_elsherif/data/models/product_category_model.dart';
import 'package:melamine_elsherif/data/models/product_collection_model.dart';
import 'package:melamine_elsherif/data/models/product_tag_model.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interface for local data source
abstract class ProductLocalDataSource {
  /// Get all products from cache
  Future<List<ProductModel>> getProducts();

  /// Get product by id from cache
  Future<ProductModel?> getProductById(String id);

  /// Get product by handle from cache
  Future<ProductModel?> getProductByHandle(String handle);

  /// Get all categories from cache
  Future<List<ProductCategoryModel>> getCategories();

  /// Get category by id from cache
  Future<ProductCategoryModel?> getCategoryById(String id);

  /// Get all collections from cache
  Future<List<ProductCollectionModel>> getCollections();

  /// Get collection by id from cache
  Future<ProductCollectionModel?> getCollectionById(String id);

  /// Get all tags from cache
  Future<List<ProductTagModel>> getTags();

  /// Cache products
  Future<void> cacheProducts(List<ProductModel> products);

  /// Cache a single product
  Future<void> cacheProduct(ProductModel product);

  /// Cache categories
  Future<void> cacheCategories(List<ProductCategoryModel> categories);

  /// Cache a single category
  Future<void> cacheCategory(ProductCategoryModel category);

  /// Cache collections
  Future<void> cacheCollections(List<ProductCollectionModel> collections);

  /// Cache a single collection
  Future<void> cacheCollection(ProductCollectionModel collection);

  /// Cache tags
  Future<void> cacheTags(List<ProductTagModel> tags);
}

/// Implementation of [ProductLocalDataSource]
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Store _store;
  final SharedPreferences _prefs;

  /// Keys for SharedPreferences
  static const String productsKey = 'CACHED_PRODUCTS';
  static const String categoriesKey = 'CACHED_CATEGORIES';
  static const String collectionsKey = 'CACHED_COLLECTIONS';
  static const String tagsKey = 'CACHED_TAGS';

  /// Creates a [ProductLocalDataSourceImpl] instance
  ProductLocalDataSourceImpl(this._store, this._prefs);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final box = _store.box<ProductModel>();
      return box.getAll();
    } catch (e) {
      throw CacheException(message: 'Failed to get products from cache: $e');
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final products = await getProducts();
      return products.firstWhere((product) => product.id == id);
    } on CacheException {
      throw CacheException(message: 'No cached product found with id: $id');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProductModel?> getProductByHandle(String handle) async {
    try {
      final products = await getProducts();
      return products.firstWhere((product) => product.handle == handle);
    } on CacheException {
      throw CacheException(message: 'No cached product found with handle: $handle');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductCategoryModel>> getCategories() async {
    try {
      final box = _store.box<ProductCategoryModel>();
      return box.getAll();
    } catch (e) {
      throw CacheException(message: 'Failed to get categories from cache: $e');
    }
  }

  @override
  Future<ProductCategoryModel?> getCategoryById(String id) async {
    try {
      final categories = await getCategories();
      return categories.firstWhere((category) => category.id == id);
    } on CacheException {
      throw CacheException(message: 'No cached category found with id: $id');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductCollectionModel>> getCollections() async {
    try {
      final box = _store.box<ProductCollectionModel>();
      return box.getAll();
    } catch (e) {
      throw CacheException(message: 'Failed to get collections from cache: $e');
    }
  }

  @override
  Future<ProductCollectionModel?> getCollectionById(String id) async {
    try {
      final collections = await getCollections();
      return collections.firstWhere((collection) => collection.id == id);
    } on CacheException {
      throw CacheException(message: 'No cached collection found with id: $id');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductTagModel>> getTags() async {
    try {
      final box = _store.box<ProductTagModel>();
      return box.getAll();
    } catch (e) {
      throw CacheException(message: 'Failed to get tags from cache: $e');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final box = _store.box<ProductModel>();
      box.putMany(products);
    } catch (e) {
      throw CacheException(message: 'Failed to cache products: $e');
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      final box = _store.box<ProductModel>();
      box.put(product);
    } catch (e) {
      throw CacheException(message: 'Failed to cache product: $e');
    }
  }

  @override
  Future<void> cacheCategories(List<ProductCategoryModel> categories) async {
    try {
      final box = _store.box<ProductCategoryModel>();
      box.putMany(categories);
    } catch (e) {
      throw CacheException(message: 'Failed to cache categories: $e');
    }
  }

  @override
  Future<void> cacheCategory(ProductCategoryModel category) async {
    try {
      final box = _store.box<ProductCategoryModel>();
      box.put(category);
    } catch (e) {
      throw CacheException(message: 'Failed to cache category: $e');
    }
  }

  @override
  Future<void> cacheCollections(List<ProductCollectionModel> collections) async {
    try {
      final box = _store.box<ProductCollectionModel>();
      box.putMany(collections);
    } catch (e) {
      throw CacheException(message: 'Failed to cache collections: $e');
    }
  }

  @override
  Future<void> cacheCollection(ProductCollectionModel collection) async {
    try {
      final box = _store.box<ProductCollectionModel>();
      box.put(collection);
    } catch (e) {
      throw CacheException(message: 'Failed to cache collection: $e');
    }
  }

  @override
  Future<void> cacheTags(List<ProductTagModel> tags) async {
    try {
      final box = _store.box<ProductTagModel>();
      box.putMany(tags);
    } catch (e) {
      throw CacheException(message: 'Failed to cache tags: $e');
    }
  }

  /// Clears the product cache
  Future<void> clearCache() async {
    try {
      _store.box<ProductModel>().removeAll();
      _store.box<ProductCategoryModel>().removeAll();
      _store.box<ProductCollectionModel>().removeAll();
      _store.box<ProductTagModel>().removeAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }
} 