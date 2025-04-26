import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/address.dart';
import '../../blocs/address/address_bloc.dart';
import '../../blocs/address/address_event.dart';
import '../../blocs/address/address_state.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/custom_text_field.dart';

class AddressFormScreen extends StatefulWidget {
  final Address? address;

  const AddressFormScreen({Key? key, this.address}) : super(key: key);

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _firstNameController.text = widget.address!.firstName;
      _lastNameController.text = widget.address!.lastName;
      _phoneController.text = widget.address!.phone;
      _address1Controller.text = widget.address!.address1;
      _address2Controller.text = widget.address!.address2 ?? '';
      _cityController.text = widget.address!.city;
      _provinceController.text = widget.address!.province ?? '';
      _postalCodeController.text = widget.address!.postalCode ?? '';
      _countryController.text = widget.address!.country;
      _isDefault = widget.address!.isDefault;
    } else {
      _countryController.text = 'Egypt'; // Default country
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.address != null
            ? 'Edit Address'
            : 'Add New Address',
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AddressAdded || state is AddressUpdated) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.address != null
                      ? 'Address updated successfully'
                      : 'Address added successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _lastNameController,
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixIcon: const Icon(Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _address1Controller,
                    labelText: 'Address Line 1',
                    hintText: 'Enter your street address',
                    prefixIcon: const Icon(Icons.home),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your street address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _address2Controller,
                    labelText: 'Address Line 2 (Optional)',
                    hintText: 'Apartment, suite, unit, etc.',
                    prefixIcon: const Icon(Icons.home),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _cityController,
                    labelText: 'City',
                    hintText: 'Enter your city',
                    prefixIcon: const Icon(Icons.location_city),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _provinceController,
                    labelText: 'State/Province (Optional)',
                    hintText: 'Enter your state or province',
                    prefixIcon: const Icon(Icons.map),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _postalCodeController,
                    labelText: 'Postal/ZIP Code (Optional)',
                    hintText: 'Enter your postal or ZIP code',
                    prefixIcon: const Icon(Icons.markunread_mailbox),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _countryController,
                    labelText: 'Country',
                    hintText: 'Enter your country',
                    prefixIcon: const Icon(Icons.public),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your country';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Set as default address'),
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _saveAddress();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      widget.address != null ? 'Update Address' : 'Save Address',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveAddress() {
    // Generate a unique ID for new addresses
    final id = widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    // Use the customer ID from the existing address or a placeholder
    final customerId = widget.address?.customerId ?? 'current_customer_id';
    
    final address = Address(
      id: id,
      customerId: customerId,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phone: _phoneController.text,
      address1: _address1Controller.text,
      address2: _address2Controller.text.isEmpty ? null : _address2Controller.text,
      city: _cityController.text,
      province: _provinceController.text.isEmpty ? null : _provinceController.text,
      postalCode: _postalCodeController.text.isEmpty ? null : _postalCodeController.text,
      country: _countryController.text,
      isDefault: _isDefault,
    );

    if (widget.address != null) {
      context.read<AddressBloc>().add(UpdateAddressEvent(address: address));
    } else {
      context.read<AddressBloc>().add(AddAddressEvent(address: address));
    }
  }
} 