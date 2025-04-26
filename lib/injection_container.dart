import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/datasources/address_remote_data_source.dart';
import 'data/repositories/address_repository_impl.dart';
import 'domain/repositories/address_repository.dart';
import 'domain/usecases/address/add_address.dart';
import 'domain/usecases/address/delete_address.dart';
import 'domain/usecases/address/get_address_by_id.dart';
import 'domain/usecases/address/get_addresses.dart';
import 'domain/usecases/address/set_default_address.dart';
import 'domain/usecases/address/update_address.dart';
import 'presentation/blocs/address/address_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory<AddressBloc>(
    () => AddressBloc(
      getAddresses: sl(),
      getAddressById: sl(),
      addAddress: sl(),
      updateAddress: sl(),
      deleteAddress: sl(),
      setDefaultAddress: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAddresses(sl()));
  sl.registerLazySingleton(() => GetAddressById(sl()));
  sl.registerLazySingleton(() => AddAddress(sl()));
  sl.registerLazySingleton(() => UpdateAddress(sl()));
  sl.registerLazySingleton(() => DeleteAddress(sl()));
  sl.registerLazySingleton(() => SetDefaultAddress(sl()));

  // Repositories
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
} 