import 'package:equatable/equatable.dart';

import '../../../domain/entities/address.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {
  const AddressInitial();
}

class AddressLoading extends AddressState {
  const AddressLoading();
}

class AddressesLoaded extends AddressState {
  final List<Address> addresses;

  const AddressesLoaded({required this.addresses});

  @override
  List<Object?> get props => [addresses];
}

class AddressLoaded extends AddressState {
  final Address address;

  const AddressLoaded({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressAdded extends AddressState {
  final Address address;

  const AddressAdded({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressUpdated extends AddressState {
  final Address address;

  const AddressUpdated({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressDeleted extends AddressState {
  final String id;

  const AddressDeleted({required this.id});

  @override
  List<Object?> get props => [id];
}

class AddressDefaultSet extends AddressState {
  final Address address;

  const AddressDefaultSet({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressError extends AddressState {
  final String message;

  const AddressError({required this.message});

  @override
  List<Object?> get props => [message];
} 