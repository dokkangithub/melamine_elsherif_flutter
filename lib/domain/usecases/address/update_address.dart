import 'package:dartz/dartz.dart';

import '../../entities/address.dart';
import '../../entities/failures.dart';
import '../../repositories/address_repository.dart';

class UpdateAddress {
  final AddressRepository repository;

  UpdateAddress(this.repository);

  Future<Either<Failure, Address>> call(Address address) async {
    return await repository.updateAddress(address);
  }
}