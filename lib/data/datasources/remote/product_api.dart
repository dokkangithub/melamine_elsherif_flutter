import 'package:melamine_elsherif/core/network/api_client.dart';
import 'package:melamine_elsherif/core/network/api_constants.dart';
import 'package:melamine_elsherif/core/error/exceptions.dart';

/// Remote data source for product-related API calls
class ProductApi {
  final ApiClient _apiClient;

  ProductApi(this._apiClient);

  /// Get a list of products from the API
  /// [limit] - Maximum number of products to return
  /// [offset] - Number of products to skip for pagination
  /// [categoryId] - Optional category ID to filter products
  /// [collectionId] - Optional collection ID to filter products
  /// [tagId] - Optional tag ID to filter products
  /// [search] - Optional search term to filter products
  Future<Map<String, dynamic>> getProducts({
    int limit = 10,
    int offset = 0,
    String? categoryId,
    String? collectionId,
    String? tagId,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }

      if (collectionId != null) {
        queryParams['collection_id'] = collectionId;
      }

      if (tagId != null) {
        queryParams['tag_id'] = tagId;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['q'] = search;
      }

      final response = await _apiClient.get(
        ApiConstants.products,
        queryParameters: queryParams,
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get products');
    }
  }

  /// Get a product by ID from the API
  /// [id] - The product ID
  Future<Map<String, dynamic>> getProductById(String id) async {
    try {
      final response = await _apiClient.get('${ApiConstants.products}/$id');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get product details');
    }
  }

  /// Get a product by handle from the API
  /// [handle] - The product handle (slug)
  Future<Map<String, dynamic>> getProductByHandle(String handle) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.products,
        queryParameters: {'handle': handle},
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get product by handle');
    }
  }

  /// Get a list of product categories from the API
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiConstants.productCategories);
      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get product categories');
    }
  }

  /// Get a product category by ID from the API
  /// [id] - The category ID
  Future<Map<String, dynamic>> getCategoryById(String id) async {
    try {
      final response = await _apiClient.get('${ApiConstants.productCategories}/$id');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get category details');
    }
  }

  /// Get a list of product collections from the API
  Future<Map<String, dynamic>> getCollections() async {
    try {
      final response = await _apiClient.get(ApiConstants.collections);
      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get product collections');
    }
  }

  /// Get a product collection by ID from the API
  /// [id] - The collection ID
  Future<Map<String, dynamic>> getCollectionById(String id) async {
    try {
      final response = await _apiClient.get('${ApiConstants.collections}/$id');
      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get collection details');
    }
  }

  /// Get a list of product tags from the API
  Future<Map<String, dynamic>> getTags() async {
    try {
      final response = await _apiClient.get(ApiConstants.productTags);
      return response as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(message: 'Failed to get product tags');
    }
  }
} 