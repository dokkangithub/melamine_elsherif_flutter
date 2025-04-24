import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:melamine_elsherif/core/network/api_client.dart';
import 'package:melamine_elsherif/core/network/network_info.dart';
import 'package:melamine_elsherif/core/services/secure_storage_service.dart';
import 'package:melamine_elsherif/data/datasources/remote/product_api.dart';
import 'package:melamine_elsherif/data/datasources/local/product_local_datasource.dart';
import 'package:melamine_elsherif/data/datasources/remote/store_api.dart';
import 'package:melamine_elsherif/data/repositories/product_repository_impl.dart';
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
import 'package:melamine_elsherif/domain/usecases/product/get_categories.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_collections.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_product_by_handle.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_product_by_id.dart';
import 'package:melamine_elsherif/domain/usecases/product/get_products.dart';
import 'package:melamine_elsherif/domain/usecases/product/search_products.dart';
import 'package:melamine_elsherif/presentation/viewmodels/home_viewmodel.dart';
import 'package:melamine_elsherif/presentation/viewmodels/product_viewmodel.dart';
import 'package:melamine_elsherif/presentation/viewmodels/cart_viewmodel.dart';
import 'package:melamine_elsherif/data/repositories/auth_repository_impl.dart';
import 'package:melamine_elsherif/data/repositories/cart_repository_impl.dart';
import 'package:melamine_elsherif/data/repositories/wishlist_repository_impl.dart';
import 'package:melamine_elsherif/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The service locator instance
final GetIt serviceLocator = GetIt.instance;

/// Initializes the service locator with all dependencies
Future<void> initServiceLocator() async {
  // Core services
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiClient(serviceLocator()));

  // External dependencies
  final store = await openStore();
  serviceLocator.registerSingleton<Store>(store);
  
  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data sources
  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(serviceLocator(), serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<ProductApi>(
    () => ProductApi(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<StoreApi>(
    () => StoreApi(serviceLocator(), 'https://api.store.com/'),
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
      networkInfo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      networkInfo: serviceLocator(),
    ),
  );
  
  // Product Use Cases
  serviceLocator.registerLazySingleton<GetProducts>(
    () => GetProducts(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<GetProductById>(
    () => GetProductById(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<GetProductByHandle>(
    () => GetProductByHandle(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<SearchProducts>(
    () => SearchProducts(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<GetCategories>(
    () => GetCategories(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<GetCollections>(
    () => GetCollections(serviceLocator()),
  );
  
  // Cart Use Cases
  serviceLocator.registerLazySingleton<CreateCart>(
    () => CreateCart(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<GetCart>(
    () => GetCart(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<UpdateCart>(
    () => UpdateCart(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<AddLineItem>(
    () => AddLineItem(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<UpdateLineItem>(
    () => UpdateLineItem(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<RemoveLineItem>(
    () => RemoveLineItem(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<GetShippingOptions>(
    () => GetShippingOptions(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<AddShippingMethod>(
    () => AddShippingMethod(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<CreatePaymentSessions>(
    () => CreatePaymentSessions(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<SetPaymentSession>(
    () => SetPaymentSession(serviceLocator()),
  );
  
  serviceLocator.registerLazySingleton<CompleteCart>(
    () => CompleteCart(serviceLocator()),
  );

  // ViewModels
  serviceLocator.registerFactory<HomeViewModel>(
    () => HomeViewModel(serviceLocator()),
  );

  serviceLocator.registerFactory<ProductViewModel>(
    () => ProductViewModel(
      serviceLocator(), 
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<CartViewModel>(
    () => CartViewModel(
      createCart: serviceLocator(),
      getCart: serviceLocator(),
      updateCart: serviceLocator(),
      addLineItem: serviceLocator(),
      updateLineItem: serviceLocator(),
      removeLineItem: serviceLocator(),
      getShippingOptions: serviceLocator(),
      addShippingMethod: serviceLocator(),
      createPaymentSessions: serviceLocator(),
      setPaymentSession: serviceLocator(),
      completeCart: serviceLocator(),
    ),
  );
} 