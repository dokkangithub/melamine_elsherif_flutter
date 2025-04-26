import 'package:dartz/dartz.dart';

import '../../entities/failures.dart';
import '../../repositories/address_repository.dart';

class DeleteAddress {
  final AddressRepository repository;

  DeleteAddress(this.repository);

  Future<Either<Failure, bool>> call(String id) async {
    return await repository.deleteAddress(id);
  }
} 