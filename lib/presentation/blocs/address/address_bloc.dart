import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/failures.dart';
import '../../../domain/usecases/address/add_address.dart';
import '../../../domain/usecases/address/delete_address.dart';
import '../../../domain/usecases/address/get_address_by_id.dart';
import '../../../domain/usecases/address/get_addresses.dart';
import '../../../domain/usecases/address/set_default_address.dart';
import '../../../domain/usecases/address/update_address.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddresses getAddresses;
  final GetAddressById getAddressById;
  final AddAddress addAddress;
  final UpdateAddress updateAddress;
  final DeleteAddress deleteAddress;
  final SetDefaultAddress setDefaultAddress;

  AddressBloc({
    required this.getAddresses,
    required this.getAddressById,
    required this.addAddress,
    required this.updateAddress,
    required this.deleteAddress,
    required this.setDefaultAddress,
  }) : super(const AddressInitial()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<GetAddressByIdEvent>(_onGetAddressById);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
  }

  Future<void> _onGetAddresses(
    GetAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressLoading());
    final result = await getAddresses();
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (addresses) => emit(AddressesLoaded(addresses: addresses)),
    );
  }

  Future<void> _onGetAddressById(
    GetAddressByIdEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressLoading());
    final result = await getAddressById(event.id);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressLoaded(address: address)),
    );
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressLoading());
    final result = await addAddress(event.address);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressAdded(address: address)),
    );
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressLoading());
    final result = await updateAddress(event.address);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressUpdated(address: address)),
    );
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressLoading());
    final result = await deleteAddress(event.id);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (success) => emit(AddressDeleted(id: event.id)),
    );
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(const AddressLoading());
    final result = await setDefaultAddress(event.id);
    result.fold(
      (failure) => emit(AddressError(message: failure.message)),
      (address) => emit(AddressDefaultSet(address: address)),
    );
  }
}