import 'package:dartz/dartz.dart';

import '../../entities/address.dart';
import '../../entities/failures.dart';
import '../../repositories/address_repository.dart';

class GetAddresses {
  final AddressRepository repository;

  GetAddresses(this.repository);

  Future<Either<Failure, List<Address>>> call() async {
    return await repository.getAddresses();
  }
} 