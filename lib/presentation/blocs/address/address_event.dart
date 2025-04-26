import 'package:equatable/equatable.dart';

import '../../../domain/entities/address.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class GetAddressesEvent extends AddressEvent {
  const GetAddressesEvent();
}

class GetAddressByIdEvent extends AddressEvent {
  final String id;

  const GetAddressByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddAddressEvent extends AddressEvent {
  final Address address;

  const AddAddressEvent({required this.address});

  @override
  List<Object?> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final Address address;

  const UpdateAddressEvent({required this.address});

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String id;

  const DeleteAddressEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SetDefaultAddressEvent extends AddressEvent {
  final String id;

  const SetDefaultAddressEvent({required this.id});

  @override
  List<Object?> get props => [id];
} 