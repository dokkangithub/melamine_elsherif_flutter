import 'package:dartz/dartz.dart';
import 'package:melamine_elsherif/core/error/failures.dart';
import 'package:melamine_elsherif/data/datasources/local/product_local_datasource.dart';
import 'package:melamine_elsherif/data/datasources/remote/product_api.dart';
import 'package:melamine_elsherif/data/models/product_model.dart';
import 'package:melamine_elsherif/data/models/product_category_model.dart';
import 'package:melamine_elsherif/data/models/product_collection_model.dart';
import 'package:melamine_elsherif/data/models/product_tag_model.dart';
import 'package:melamine_elsherif/domain/entities/product.dart';
import 'package:melamine_elsherif/domain/entities/product_category.dart';
import 'package:melamine_elsherif/domain/entities/product_collection.dart';
import 'package:melamine_elsherif/domain/entities/product_tag.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';

/// Implementation of [ProductRepository] that integrates remote and local data sources
class ProductRepositoryImpl implements ProductRepository {
  final ProductApi _productApi;
  final ProductLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  /// Creates a [ProductRepositoryImpl] instance
  ProductRepositoryImpl(
    this._productApi,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int? offset,
    int? limit,
    String? search,
    List<String>? categoryIds,
    List<String>? collectionIds,
    List<String>? tagIds,
    String? sortBy,
    bool? sortDesc,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getProducts(
          limit: limit ?? 10,
          offset: offset ?? 0,
          categoryId: categoryIds?.isNotEmpty == true ? categoryIds!.first : null,
          collectionId: collectionIds?.isNotEmpty == true ? collectionIds!.first : null,
          tagId: tagIds?.isNotEmpty == true ? tagIds!.first : null,
          search: search,
        );
        
        final List<ProductModel> products = [];
        if (response['products'] != null) {
          for (final product in response['products']) {
            products.add(ProductModel.fromJson(product));
          }
        }
        
        // Cache the products
        _localDataSource.cacheProducts(products);
        
        return Right(products);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localProducts = await _localDataSource.getProducts();
          return Right(localProducts);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localProducts = await _localDataSource.getProducts();
        return Right(localProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get products from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getProductById(id);
        if (response['product'] != null) {
          final product = ProductModel.fromJson(response['product']);
          
          // Cache the product
          _localDataSource.cacheProduct(product);
          
          return Right(product);
        }
        return Left(ServerFailure(message: 'Product not found'));
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localProduct = await _localDataSource.getProductById(id);
          if (localProduct != null) {
            return Right(localProduct);
          }
          return Left(CacheFailure(message: 'Product not found in cache'));
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localProduct = await _localDataSource.getProductById(id);
        if (localProduct != null) {
          return Right(localProduct);
        }
        return Left(CacheFailure(message: 'Product not found in cache'));
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get product from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductByHandle(String handle) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getProductByHandle(handle);
        if (response['products'] != null && (response['products'] as List).isNotEmpty) {
          final product = ProductModel.fromJson(response['products'][0]);
          
          // Cache the product
          _localDataSource.cacheProduct(product);
          
          return Right(product);
        }
        return Left(ServerFailure(message: 'Product not found'));
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localProduct = await _localDataSource.getProductByHandle(handle);
          if (localProduct != null) {
            return Right(localProduct);
          }
          return Left(CacheFailure(message: 'Product not found in cache'));
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localProduct = await _localDataSource.getProductByHandle(handle);
        if (localProduct != null) {
          return Right(localProduct);
        }
        return Left(CacheFailure(message: 'Product not found in cache'));
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get product from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductCategory>>> getCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getCategories();
        
        final List<ProductCategoryModel> categories = [];
        if (response['product_categories'] != null) {
          for (final category in response['product_categories']) {
            categories.add(ProductCategoryModel.fromJson(category));
          }
        }
        
        // Cache the categories
        _localDataSource.cacheCategories(categories);
        
        return Right(categories);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localCategories = await _localDataSource.getCategories();
          return Right(localCategories);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localCategories = await _localDataSource.getCategories();
        return Right(localCategories);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get categories from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, ProductCategory>> getCategoryById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getCategoryById(id);
        if (response['product_category'] != null) {
          final category = ProductCategoryModel.fromJson(response['product_category']);
          
          // Cache the category
          _localDataSource.cacheCategory(category);
          
          return Right(category);
        }
        return Left(ServerFailure(message: 'Category not found'));
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localCategory = await _localDataSource.getCategoryById(id);
          if (localCategory != null) {
            return Right(localCategory);
          }
          return Left(CacheFailure(message: 'Category not found in cache'));
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localCategory = await _localDataSource.getCategoryById(id);
        if (localCategory != null) {
          return Right(localCategory);
        }
        return Left(CacheFailure(message: 'Category not found in cache'));
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get category from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductCollection>>> getCollections() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getCollections();
        
        final List<ProductCollectionModel> collections = [];
        if (response['collections'] != null) {
          for (final collection in response['collections']) {
            collections.add(ProductCollectionModel.fromJson(collection));
          }
        }
        
        // Cache the collections
        _localDataSource.cacheCollections(collections);
        
        return Right(collections);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localCollections = await _localDataSource.getCollections();
          return Right(localCollections);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localCollections = await _localDataSource.getCollections();
        return Right(localCollections);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get collections from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, ProductCollection>> getCollectionById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getCollectionById(id);
        if (response['collection'] != null) {
          final collection = ProductCollectionModel.fromJson(response['collection']);
          
          // Cache the collection
          _localDataSource.cacheCollection(collection);
          
          return Right(collection);
        }
        return Left(ServerFailure(message: 'Collection not found'));
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localCollection = await _localDataSource.getCollectionById(id);
          if (localCollection != null) {
            return Right(localCollection);
          }
          return Left(CacheFailure(message: 'Collection not found in cache'));
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localCollection = await _localDataSource.getCollectionById(id);
        if (localCollection != null) {
          return Right(localCollection);
        }
        return Left(CacheFailure(message: 'Collection not found in cache'));
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get collection from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductTag>>> getTags() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getTags();
        
        final List<ProductTagModel> tags = [];
        if (response['product_tags'] != null) {
          for (final tag in response['product_tags']) {
            tags.add(ProductTagModel.fromJson(tag));
          }
        }
        
        // Cache the tags
        _localDataSource.cacheTags(tags);
        
        return Right(tags);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localTags = await _localDataSource.getTags();
          return Right(localTags);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localTags = await _localDataSource.getTags();
        return Right(localTags);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get tags from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getRelatedProducts(String productId) async {
    try {
      // Get the product details first
      final productResult = await getProductById(productId);
      
      return productResult.fold(
        (failure) => Left(failure),
        (product) async {
          try {
            // Get related products based on category or collection
            String? categoryId;
            String? collectionId;
            
            if (product.categories != null && product.categories!.isNotEmpty) {
              categoryId = product.categories!.first.id;
            }
            
            if (product.collection != null) {
              collectionId = product.collection!.id;
            }
            
            // Get products by category or collection
            final relatedProductsResult = await getProducts(
              limit: 5,
              categoryIds: categoryId != null ? [categoryId] : null,
              collectionIds: collectionId != null ? [collectionId] : null,
            );
            
            return relatedProductsResult.fold(
              (failure) => Left(failure),
              (products) {
                // Filter out the current product from the list
                final filteredProducts = products.where((p) => p.id != productId).toList();
                return Right(filteredProducts);
              },
            );
          } catch (e) {
            return Left(ServerFailure(message: 'Failed to get related products'));
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get related products'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getFeaturedProducts() async {
    try {
      // Implementation would depend on how featured products are identified
      // For now, we'll just get the first few products as a placeholder
      return getProducts(limit: 8);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get featured products'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getBestsellers() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getBestsellers();
        
        final List<ProductModel> products = [];
        if (response['products'] != null) {
          for (final product in response['products']) {
            products.add(ProductModel.fromJson(product));
          }
        }
        
        // Cache the products
        _localDataSource.cacheProducts(products);
        
        return Right(products);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localProducts = await _localDataSource.getProducts();
          return Right(localProducts);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localProducts = await _localDataSource.getProducts();
        return Right(localProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get bestsellers from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getTodaysBestDeals() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getTodaysBestDeals();
        
        final List<ProductModel> products = [];
        if (response['products'] != null) {
          for (final product in response['products']) {
            products.add(ProductModel.fromJson(product));
          }
        }
        
        // Cache the products
        _localDataSource.cacheProducts(products);
        
        return Right(products);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localProducts = await _localDataSource.getProducts();
          return Right(localProducts);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localProducts = await _localDataSource.getProducts();
        return Right(localProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get today\'s best deals from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getNewArrivals() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _productApi.getNewArrivals();
        
        final List<ProductModel> products = [];
        if (response['products'] != null) {
          for (final product in response['products']) {
            products.add(ProductModel.fromJson(product));
          }
        }
        
        // Cache the products
        _localDataSource.cacheProducts(products);
        
        return Right(products);
      } catch (e) {
        // If there is a network error, try to get from local cache
        try {
          final localProducts = await _localDataSource.getProducts();
          return Right(localProducts);
        } catch (cacheError) {
          if (e is ApiException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is ServerException) {
            return Left(ServerFailure(message: e.message));
          } else if (e is NetworkException) {
            return Left(NetworkFailure(message: e.message));
          }
          return Left(ServerFailure(message: e.toString()));
        }
      }
    } else {
      // If offline, try to get from local cache
      try {
        final localProducts = await _localDataSource.getProducts();
        return Right(localProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get new arrivals from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getPopularProducts() async {
    try {
      // Implementation would depend on how popularity is determined
      // For now, we'll just get a few products as a placeholder
      return getProducts(limit: 8);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get popular products'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId) async {
    try {
      return getProducts(categoryIds: [categoryId]);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get products by category'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCollection(String collectionId) async {
    if (await _networkInfo.isConnected) {
      try {
        return await getProducts(collectionIds: [collectionId]);
      } catch (e) {
        if (e is ApiException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is NetworkException) {
          return Left(NetworkFailure(message: e.message));
        }
        return Left(ServerFailure(message: 'Failed to get products by collection'));
      }
    } else {
      try {
        // Filter products by collection ID from local cache
        final localProducts = await _localDataSource.getProducts();
        final filteredProducts = localProducts.where((product) => 
          product.collection?.id == collectionId
        ).toList();
        return Right(filteredProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get products from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByTag(String tagId) async {
    if (await _networkInfo.isConnected) {
      try {
        return await getProducts(tagIds: [tagId]);
      } catch (e) {
        if (e is ApiException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is NetworkException) {
          return Left(NetworkFailure(message: e.message));
        }
        return Left(ServerFailure(message: 'Failed to get products by tag'));
      }
    } else {
      try {
        // Filter products by tag ID from local cache
        final localProducts = await _localDataSource.getProducts();
        final filteredProducts = localProducts.where((product) => 
          product.tags?.any((tag) => tag.id == tagId) ?? false
        ).toList();
        return Right(filteredProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get products from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    if (await _networkInfo.isConnected) {
      try {
        return await getProducts(search: query);
      } catch (e) {
        if (e is ApiException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: e.message));
        } else if (e is NetworkException) {
          return Left(NetworkFailure(message: e.message));
        }
        return Left(ServerFailure(message: 'Failed to search products'));
      }
    } else {
      try {
        // Search products locally by title or description
        final localProducts = await _localDataSource.getProducts();
        final filteredProducts = localProducts.where((product) => 
          (product.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (product.description?.toLowerCase().contains(query.toLowerCase()) ?? false)
        ).toList();
        return Right(filteredProducts);
      } catch (e) {
        return Left(CacheFailure(message: 'Unable to get products from cache'));
      }
    }
  }
} 