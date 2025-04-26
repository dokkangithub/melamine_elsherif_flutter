import 'package:dartz/dartz.dart';

import '../../domain/entities/address.dart';
import '../../domain/entities/failures.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final addresses = await remoteDataSource.getAddresses();
      return Right(addresses);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> getAddressById(String id) async {
    try {
      final address = await remoteDataSource.getAddressById(id);
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    try {
      final AddressModel addressModel = AddressModel.fromAddress(address);
      final newAddress = await remoteDataSource.addAddress(addressModel);
      return Right(newAddress);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(Address address) async {
    try {
      final AddressModel addressModel = AddressModel.fromAddress(address);
      final updatedAddress = await remoteDataSource.updateAddress(addressModel);
      return Right(updatedAddress);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAddress(String id) async {
    try {
      final result = await remoteDataSource.deleteAddress(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Address>> setDefaultAddress(String id) async {
    try {
      final address = await remoteDataSource.setDefaultAddress(id);
      return Right(address);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
} 