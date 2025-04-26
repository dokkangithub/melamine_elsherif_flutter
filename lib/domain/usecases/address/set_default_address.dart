import 'package:dartz/dartz.dart';

import '../../entities/address.dart';
import '../../entities/failures.dart';
import '../../repositories/address_repository.dart';

class SetDefaultAddress {
  final AddressRepository repository;

  SetDefaultAddress(this.repository);

  Future<Either<Failure, Address>> call(String id) async {
    return await repository.setDefaultAddress(id);
  }
} 