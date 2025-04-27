import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/data/api/api_client.dart' as data_api;
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/data/datasources/remote/product_api.dart';
import 'package:melamine_elsherif/data/datasources/local/product_local_datasource.dart';
import 'package:melamine_elsherif/data/datasources/remote/store_api.dart';
import 'package:melamine_elsherif/data/datasources/remote/cart_api.dart';
import 'package:melamine_elsherif/data/repositories/product_repository_impl.dart';
import 'package:melamine_elsherif/data/repositories/auth_repository_impl.dart';
import 'package:melamine_elsherif/data/repositories/cart_repository_impl.dart';
import 'package:melamine_elsherif/data/repositories/wishlist_repository_impl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:melamine_elsherif/objectbox.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:melamine_elsherif/domain/repositories/product_repository.dart';
import 'package:melamine_elsherif/domain/repositories/auth_repository.dart';
import 'package:melamine_elsherif/domain/repositories/cart_repository.dart';
import 'package:melamine_elsherif/domain/repositories/wishlist_repository.dart';
import 'package:melamine_elsherif/domain/usecases/cart/add_line_item.dart';
import 'package:melamine_elsherif/domain/usecases/cart/add_shipping_method.dart';
import 'package:melamine_elsherif/domain/usecases/cart/complete_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/create_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/create_payment_sessions.dart';
import 'package:melamine_elsherif/domain/usecases/cart/get_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/get_shipping_options.dart';
import 'package:melamine_elsherif/domain/usecases/cart/remove_line_item.dart';
import 'package:melamine_elsherif/domain/usecases/cart/set_payment_session.dart';
import 'package:melamine_elsherif/domain/usecases/cart/update_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/update_line_item.dart';
import 'package:melamine_elsherif/domain/usecases/cart/add_to_cart.dart';
import 'package:melamine_elsherif/domain/usecases/cart/remove_from_cart.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_categories.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_collections.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_product_by_handle.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_product_by_id.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_products.dart';
import 'package:melamine_elsherif/domain/usecases/product/search_products.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/add_to_wishlist.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/get_wishlist.dart';
import 'package:melamine_elsherif/domain/usecases/wishlist/remove_from_wishlist.dart';
import 'package:melamine_elsherif/presentation/viewmodels/home_viewmodel.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/product_view_model.dart';
import 'package:melamine_elsherif/presentation/viewmodels/cart/cart_view_model.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product/wishlist_view_model.dart';
import 'package:melamine_elsherif/domain/usecases/auth/login.dart';
import 'package:melamine_elsherif/domain/usecases/auth/register.dart';
import 'package:melamine_elsherif/domain/usecases/auth/logout.dart';
import 'package:melamine_elsherif/domain/usecases/auth/get_current_user.dart';
import 'package:melamine_elsherif/domain/usecases/auth/request_password_reset.dart';
import 'package:melamine_elsherif/domain/usecases/auth/update_profile.dart';
import 'package:melamine_elsherif/presentation/viewmodels/auth_viewmodel.dart';
import 'package:melamine_elsherif/data/datasources/local/app_preferences.dart';

/// The service locator instance
final GetIt serviceLocator = GetIt.instance;

/// Initializes the service locator with all dependencies
Future<void> initServiceLocator() async {
  // Core services
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );
  
  // Register Talker for logging
  final talker = Talker(
    settings: TalkerSettings(
      useConsoleLogs: true,
    ),
  );
  serviceLocator.registerLazySingleton<Talker>(() => talker);

  // Register FlutterSecureStorage
  serviceLocator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  
  // Register Dio instances
  serviceLocator.registerLazySingleton(() => Dio());
  
  // Register the data ApiClient for auth
  serviceLocator.registerLazySingleton(() => data_api.ApiClient(
    dio: serviceLocator<Dio>(),
    talker: serviceLocator<Talker>(),
    secureStorage: serviceLocator<FlutterSecureStorage>(),
  ));

  // External dependencies
  final store = await openStore();
  serviceLocator.registerSingleton<Store>(store);
  
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register AppPreferences
  serviceLocator.registerLazySingleton(() => AppPreferences(serviceLocator<SharedPreferences>()));

  // Data sources
  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      serviceLocator<Store>(),
      serviceLocator<SharedPreferences>(),
    ),
  );
  
  // Register API clients
  serviceLocator.registerLazySingleton<ProductApi>(
    () => ProductApi(serviceLocator<Dio>()),
  );
  
  serviceLocator.registerLazySingleton<StoreApi>(
    () => StoreApi(
      serviceLocator<Dio>(),
      'http://192.168.1.38:9000', // Using the same base URL as in ApiClient
    ),
  );

  serviceLocator.registerLazySingleton<CartApi>(
    () => CartApi(serviceLocator<Dio>()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      serviceLocator<ProductApi>(),
      serviceLocator<ProductLocalDataSource>(),
      serviceLocator<NetworkInfo>(),
    ),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: serviceLocator<NetworkInfo>(),
      apiClient: serviceLocator<data_api.ApiClient>(),
      talker: serviceLocator<Talker>(),
    ),
  );

  serviceLocator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      cartApi: serviceLocator<CartApi>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );

  serviceLocator.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );
  
  // Auth Use Cases
  serviceLocator.registerLazySingleton(() => Login(serviceLocator<AuthRepository>()));
  serviceLocator.registerLazySingleton(() => Register(serviceLocator<AuthRepository>()));
  serviceLocator.registerLazySingleton(() => Logout(serviceLocator<AuthRepository>()));
  serviceLocator.registerLazySingleton(() => GetCurrentUser(serviceLocator<AuthRepository>()));
  serviceLocator.registerLazySingleton(() => RequestPasswordReset(serviceLocator<AuthRepository>()));
  serviceLocator.registerLazySingleton(() => UpdateProfile(serviceLocator<AuthRepository>()));
  
  // Product Use Cases
  serviceLocator.registerLazySingleton(() => GetProducts(serviceLocator<ProductRepository>()));
  serviceLocator.registerLazySingleton(() => GetProductById(serviceLocator<ProductRepository>()));
  serviceLocator.registerLazySingleton(() => GetProductByHandle(serviceLocator<ProductRepository>()));
  serviceLocator.registerLazySingleton(() => SearchProducts(serviceLocator<ProductRepository>()));
  serviceLocator.registerLazySingleton(() => GetCategories(serviceLocator<ProductRepository>()));
  serviceLocator.registerLazySingleton(() => GetCollections(serviceLocator<ProductRepository>()));
  
  // Cart Use Cases
  serviceLocator.registerLazySingleton(() => CreateCart(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => GetCart(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => UpdateCart(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => AddToCart(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => RemoveFromCart(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => AddLineItem(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => UpdateLineItem(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => RemoveLineItem(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => GetShippingOptions(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => AddShippingMethod(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => CreatePaymentSessions(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => SetPaymentSession(serviceLocator<CartRepository>()));
  serviceLocator.registerLazySingleton(() => CompleteCart(serviceLocator<CartRepository>()));

  // Wishlist Use Cases
  serviceLocator.registerLazySingleton(() => GetWishlist(serviceLocator<WishlistRepository>()));
  serviceLocator.registerLazySingleton(() => AddToWishlist(serviceLocator<WishlistRepository>()));
  serviceLocator.registerLazySingleton(() => RemoveFromWishlist(serviceLocator<WishlistRepository>()));

  // ViewModels
  serviceLocator.registerFactory<HomeViewModel>(
    () => HomeViewModel(serviceLocator<ProductRepository>()),
  );

  serviceLocator.registerFactory<ProductViewModel>(
    () => ProductViewModel(
      productRepository: serviceLocator<ProductRepository>(),
    ),
  );

  serviceLocator.registerFactory<CartViewModel>(
    () => CartViewModel(
      getCart: serviceLocator<GetCart>(),
      addLineItem: serviceLocator<AddLineItem>(),
      removeLineItem: serviceLocator<RemoveLineItem>(),
      updateCart: serviceLocator<UpdateCart>(),
    ),
  );

  serviceLocator.registerFactory<WishlistViewModel>(
    () => WishlistViewModel(
      getWishlist: serviceLocator<GetWishlist>(),
      addToWishlist: serviceLocator<AddToWishlist>(),
      removeFromWishlist: serviceLocator<RemoveFromWishlist>(),
    ),
  );

  serviceLocator.registerFactory(() => AuthViewModel(
    login: serviceLocator<Login>(),
    register: serviceLocator<Register>(),
    logout: serviceLocator<Logout>(),
    getCurrentUser: serviceLocator<GetCurrentUser>(),
    requestPasswordResetUseCase: serviceLocator<RequestPasswordReset>(),
    updateProfileUseCase: serviceLocator<UpdateProfile>(),
  ));
} 