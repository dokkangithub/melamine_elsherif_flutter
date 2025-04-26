import 'package:dartz/dartz.dart';

import '../entities/address.dart';
import '../entities/failures.dart';

abstract class AddressRepository {
  /// Get all addresses for the current user
  Future<Either<Failure, List<Address>>> getAddresses();
  
  /// Get a specific address by id
  Future<Either<Failure, Address>> getAddressById(String id);
  
  /// Add a new address
  Future<Either<Failure, Address>> addAddress(Address address);
  
  /// Update an existing address
  Future<Either<Failure, Address>> updateAddress(Address address);
  
  /// Delete an address
  Future<Either<Failure, bool>> deleteAddress(String id);
  
  /// Set an address as default
  Future<Either<Failure, Address>> setDefaultAddress(String id);
} 