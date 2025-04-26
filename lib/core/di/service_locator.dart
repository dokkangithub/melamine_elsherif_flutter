import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';
import 'package:melamine_elsherif/data/repositories/product_repository_impl.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/product_view_model.dart';
import 'package:melamine_elsherif/data/datasources/remote/product_api.dart';
import 'package:melamine_elsherif/data/datasources/local/product_local_datasource.dart';
import 'package:melamine_elsherif/data/api/api_client.dart' as data_api;
import 'package:melamine_elsherif/data/models/product_model.dart';
import 'package:melamine_elsherif/data/models/product_category_model.dart';
import 'package:melamine_elsherif/data/models/product_collection_model.dart';
import 'package:melamine_elsherif/data/models/product_tag_model.dart';
import 'package:melamine_elsherif/data/datasources/local/app_preferences.dart';
import 'package:melamine_elsherif/presentation/viewmodels/auth_viewmodel.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';
import 'package:melamine_elsherif/data/repositories/auth_repository_impl.dart';
import 'package:melamine_elsherif/domain/usecases/auth/login.dart';
import 'package:melamine_elsherif/domain/usecases/auth/register.dart';
import 'package:melamine_elsherif/domain/usecases/auth/logout.dart';
import 'package:melamine_elsherif/domain/usecases/auth/get_current_user.dart';
import 'package:melamine_elsherif/domain/usecases/auth/request_password_reset.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:melamine_elsherif/domain/entities/login_response.dart';
import 'package:melamine_elsherif/domain/repositories/wishlist_repository.dart';
import 'package:melamine_elsherif/data/repositories/wishlist_repository_impl.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/get_wishlist.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/add_to_wishlist.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/remove_from_wishlist.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/wishlist_view_model.dart';

// Service locator instance
final sl = GetIt.instance;

// Initialize all dependencies
Future<void> init() async {
  // External services
  final talker = Talker(
    settings: TalkerSettings(
      useConsoleLogs: true,
    ),
  );
  sl.registerLazySingleton(() => talker);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // App Preferences
  sl.registerLazySingleton(() => AppPreferences(sl<SharedPreferences>()));
  
  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );
  
  // API Client
  final apiClient = data_api.ApiClient(
    dio: sl<Dio>(),
    talker: sl<Talker>(),
    secureStorage: sl<FlutterSecureStorage>(),
  );
  sl.registerLazySingleton<data_api.ApiClient>(() => apiClient);
  
  // Data sources
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => WebCompatibleProductLocalDataSource(sl<SharedPreferences>()),
  );
  
  // Register ProductApi with the correct ApiClient type
  sl.registerLazySingleton<ProductApi>(
    () => ProductApi(sl<data_api.ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      sl<ProductApi>(),
      sl<ProductLocalDataSource>(),
      sl<NetworkInfo>(),
    ),
  );
  
  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl<NetworkInfo>(),
      apiClient: sl<data_api.ApiClient>(),
      talker: sl<Talker>(),
    ),
  );
  
  // Wishlist Repository
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  
  // Auth Use Cases
  sl.registerLazySingleton(() => Login(sl<AuthRepository>()));
  sl.registerLazySingleton(() => Register(sl<AuthRepository>()));
  sl.registerLazySingleton(() => Logout(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RequestPasswordReset(sl<AuthRepository>()));
  
  // Wishlist Use Cases
  sl.registerLazySingleton(() => GetWishlist(sl<WishlistRepository>()));
  sl.registerLazySingleton(() => AddToWishlist(sl<WishlistRepository>()));
  sl.registerLazySingleton(() => RemoveFromWishlist(sl<WishlistRepository>()));

  // ViewModels
  sl.registerFactory(
    () => ProductViewModel(
      productRepository: sl<ProductRepository>(),
    ),
  );
  
  // Register AuthViewModel
  sl.registerFactory(() => AuthViewModel(
    login: sl(),
    register: sl(),
    logout: sl(),
    getCurrentUser: sl(),
    requestPasswordResetUseCase: sl(),
  ));
  
  // Wishlist ViewModel
  sl.registerFactory(() => WishlistViewModel(
    getWishlist: sl<GetWishlist>(),
    addToWishlist: sl<AddToWishlist>(),
    removeFromWishlist: sl<RemoveFromWishlist>(),
  ));
}

// Web-compatible implementation of ProductLocalDataSource using SharedPreferences instead of ObjectBox
class WebCompatibleProductLocalDataSource implements ProductLocalDataSource {
  final SharedPreferences _prefs;
  
  WebCompatibleProductLocalDataSource(this._prefs);
  
  // Cache key constants
  static const String _productsKey = 'cached_products';
  static const String _categoriesKey = 'cached_categories';
  static const String _collectionsKey = 'cached_collections';
  static const String _tagsKey = 'cached_tags';
  
  @override
  Future<void> cacheCategories(List<ProductCategoryModel> categories) async {
    // In a real implementation, we would serialize to JSON and store
    // For now, we'll just keep track of the count for simplicity
    await _prefs.setInt('${_categoriesKey}_count', categories.length);
  }
  
  @override
  Future<void> cacheCategory(ProductCategoryModel category) async {
    // Simplified implementation
  }
  
  @override
  Future<void> cacheCollection(ProductCollectionModel collection) async {
    // Simplified implementation
  }
  
  @override
  Future<void> cacheCollections(List<ProductCollectionModel> collections) async {
    await _prefs.setInt('${_collectionsKey}_count', collections.length);
  }
  
  @override
  Future<void> cacheProduct(ProductModel product) async {
    // Simplified implementation
  }
  
  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    await _prefs.setInt('${_productsKey}_count', products.length);
  }
  
  @override
  Future<void> cacheTags(List<ProductTagModel> tags) async {
    await _prefs.setInt('${_tagsKey}_count', tags.length);
  }
  
  @override
  Future<ProductCategoryModel?> getCategoryById(String id) async => null;
  
  @override
  Future<List<ProductCategoryModel>> getCategories() async => [];
  
  @override
  Future<ProductCollectionModel?> getCollectionById(String id) async => null;
  
  @override
  Future<List<ProductCollectionModel>> getCollections() async => [];
  
  @override
  Future<ProductModel?> getProductById(String id) async => null;
  
  @override
  Future<ProductModel?> getProductByHandle(String handle) async => null;
  
  @override
  Future<List<ProductModel>> getProducts() async => [];
  
  @override
  Future<List<ProductTagModel>> getTags() async => [];
} 