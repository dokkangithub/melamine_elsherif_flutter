import 'dart:convert';

import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/data/models/product_model.dart';
import 'package:melamine_elsherif/data/models/product_category_model.dart';
import 'package:melamine_elsherif/data/models/product_collection_model.dart';
import 'package:melamine_elsherif/data/models/product_tag_model.dart';
import 'package:melamine_elsherif/data/models/objectbox_models.dart';
import 'package:melamine_elsherif/objectbox.g.dart';
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
      final box = _store.box<ProductBoxModel>();
      final boxModels = box.getAll();
      return boxModels.map((boxModel) => ProductModel(
        id: boxModel.productId,
        title: boxModel.title,
        handle: boxModel.handle,
        description: boxModel.description,
        thumbnail: boxModel.thumbnail,
        isGiftCard: boxModel.isGiftCard,
        status: boxModel.status,
        variants: [], // TODO: Handle variants
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
        isInWishlist: boxModel.isInWishlist,
      )).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get products from cache: $e');
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final box = _store.box<ProductBoxModel>();
      final query = box.query(ProductBoxModel_.productId.equals(id)).build();
      final boxModel = query.findFirst();
      query.close();
      
      if (boxModel == null) return null;
      
      return ProductModel(
        id: boxModel.productId,
        title: boxModel.title,
        handle: boxModel.handle,
        description: boxModel.description,
        thumbnail: boxModel.thumbnail,
        isGiftCard: boxModel.isGiftCard,
        status: boxModel.status,
        variants: [], // TODO: Handle variants
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
        isInWishlist: boxModel.isInWishlist,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ProductModel?> getProductByHandle(String handle) async {
    try {
      final box = _store.box<ProductBoxModel>();
      final query = box.query(ProductBoxModel_.handle.equals(handle)).build();
      final boxModel = query.findFirst();
      query.close();
      
      if (boxModel == null) return null;
      
      return ProductModel(
        id: boxModel.productId,
        title: boxModel.title,
        handle: boxModel.handle,
        description: boxModel.description,
        thumbnail: boxModel.thumbnail,
        isGiftCard: boxModel.isGiftCard,
        status: boxModel.status,
        variants: [], // TODO: Handle variants
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
        isInWishlist: boxModel.isInWishlist,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductCategoryModel>> getCategories() async {
    try {
      final box = _store.box<ProductCategoryBoxModel>();
      final boxModels = box.getAll();
      return boxModels.map((boxModel) => ProductCategoryModel(
        id: boxModel.categoryId,
        name: boxModel.name,
        handle: boxModel.handle,
        description: boxModel.description,
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
        isActive: true, // Default to true since we don't store this in the box model
      )).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get categories from cache: $e');
    }
  }

  @override
  Future<ProductCategoryModel?> getCategoryById(String id) async {
    try {
      final box = _store.box<ProductCategoryBoxModel>();
      final query = box.query(ProductCategoryBoxModel_.categoryId.equals(id)).build();
      final boxModel = query.findFirst();
      query.close();
      
      if (boxModel == null) return null;
      
      return ProductCategoryModel(
        id: boxModel.categoryId,
        name: boxModel.name,
        handle: boxModel.handle,
        description: boxModel.description,
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
        isActive: true, // Default to true since we don't store this in the box model
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductCollectionModel>> getCollections() async {
    try {
      final box = _store.box<ProductCollectionBoxModel>();
      final boxModels = box.getAll();
      return boxModels.map((boxModel) => ProductCollectionModel(
        id: boxModel.collectionId,
        title: boxModel.title,
        handle: boxModel.handle,
        description: boxModel.description,
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
      )).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get collections from cache: $e');
    }
  }

  @override
  Future<ProductCollectionModel?> getCollectionById(String id) async {
    try {
      final box = _store.box<ProductCollectionBoxModel>();
      final query = box.query(ProductCollectionBoxModel_.collectionId.equals(id)).build();
      final boxModel = query.findFirst();
      query.close();
      
      if (boxModel == null) return null;
      
      return ProductCollectionModel(
        id: boxModel.collectionId,
        title: boxModel.title,
        handle: boxModel.handle,
        description: boxModel.description,
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ProductTagModel>> getTags() async {
    try {
      final box = _store.box<ProductTagBoxModel>();
      final boxModels = box.getAll();
      return boxModels.map((boxModel) => ProductTagModel(
        id: boxModel.tagId,
        value: boxModel.value,
        createdAt: boxModel.createdAt,
        updatedAt: boxModel.updatedAt,
      )).toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get tags from cache: $e');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final box = _store.box<ProductBoxModel>();
      final boxModels = products.map((product) => ProductBoxModel(
        productId: product.id,
        title: product.title,
        handle: product.handle,
        description: product.description,
        thumbnail: product.thumbnail,
        isGiftCard: product.isGiftCard,
        status: product.status,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
        isInWishlist: product.isInWishlist,
      )).toList();
      box.putMany(boxModels);
    } catch (e) {
      throw CacheException(message: 'Failed to cache products: $e');
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      final box = _store.box<ProductBoxModel>();
      final boxModel = ProductBoxModel(
        productId: product.id,
        title: product.title,
        handle: product.handle,
        description: product.description,
        thumbnail: product.thumbnail,
        isGiftCard: product.isGiftCard,
        status: product.status,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
        isInWishlist: product.isInWishlist,
      );
      box.put(boxModel);
    } catch (e) {
      throw CacheException(message: 'Failed to cache product: $e');
    }
  }

  @override
  Future<void> cacheCategories(List<ProductCategoryModel> categories) async {
    try {
      final box = _store.box<ProductCategoryBoxModel>();
      final boxModels = categories.map((category) => ProductCategoryBoxModel(
        categoryId: category.id,
        name: category.name,
        handle: category.handle,
        description: category.description,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      )).toList();
      box.putMany(boxModels);
    } catch (e) {
      throw CacheException(message: 'Failed to cache categories: $e');
    }
  }

  @override
  Future<void> cacheCategory(ProductCategoryModel category) async {
    try {
      final box = _store.box<ProductCategoryBoxModel>();
      final boxModel = ProductCategoryBoxModel(
        categoryId: category.id,
        name: category.name,
        handle: category.handle,
        description: category.description,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
      );
      box.put(boxModel);
    } catch (e) {
      throw CacheException(message: 'Failed to cache category: $e');
    }
  }

  @override
  Future<void> cacheCollections(List<ProductCollectionModel> collections) async {
    try {
      final box = _store.box<ProductCollectionBoxModel>();
      final boxModels = collections.map((collection) => ProductCollectionBoxModel(
        collectionId: collection.id,
        title: collection.title,
        handle: collection.handle,
        description: collection.description,
        createdAt: collection.createdAt,
        updatedAt: collection.updatedAt,
      )).toList();
      box.putMany(boxModels);
    } catch (e) {
      throw CacheException(message: 'Failed to cache collections: $e');
    }
  }

  @override
  Future<void> cacheCollection(ProductCollectionModel collection) async {
    try {
      final box = _store.box<ProductCollectionBoxModel>();
      final boxModel = ProductCollectionBoxModel(
        collectionId: collection.id,
        title: collection.title,
        handle: collection.handle,
        description: collection.description,
        createdAt: collection.createdAt,
        updatedAt: collection.updatedAt,
      );
      box.put(boxModel);
    } catch (e) {
      throw CacheException(message: 'Failed to cache collection: $e');
    }
  }

  @override
  Future<void> cacheTags(List<ProductTagModel> tags) async {
    try {
      final box = _store.box<ProductTagBoxModel>();
      final boxModels = tags.map((tag) => ProductTagBoxModel(
        tagId: tag.id,
        value: tag.value,
        createdAt: tag.createdAt,
        updatedAt: tag.updatedAt,
      )).toList();
      box.putMany(boxModels);
    } catch (e) {
      throw CacheException(message: 'Failed to cache tags: $e');
    }
  }

  /// Clears the product cache
  Future<void> clearCache() async {
    try {
      _store.box<ProductBoxModel>().removeAll();
      _store.box<ProductCategoryBoxModel>().removeAll();
      _store.box<ProductCollectionBoxModel>().removeAll();
      _store.box<ProductTagBoxModel>().removeAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache: $e');
    }
  }
} 