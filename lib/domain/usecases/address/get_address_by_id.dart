import 'package:dartz/dartz.dart';

import '../../entities/address.dart';
import '../../entities/failures.dart';
import '../../repositories/address_repository.dart';

class GetAddressById {
  final AddressRepository repository;

  GetAddressById(this.repository);

  Future<Either<Failure, Address>> call(String id) async {
    return await repository.getAddressById(id);
  }
} 