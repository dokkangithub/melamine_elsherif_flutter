import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';
import '../models/address_model.dart';

abstract class AddressRemoteDataSource {
  /// Get all addresses for the current user from the API
  /// Throws [ServerException] if the request fails
  Future<List<AddressModel>> getAddresses();

  /// Get a specific address by id from the API
  /// Throws [ServerException] if the request fails
  Future<AddressModel> getAddressById(String id);

  /// Add a new address using the API
  /// Throws [ServerException] if the request fails
  Future<AddressModel> addAddress(AddressModel address);

  /// Update an existing address using the API
  /// Throws [ServerException] if the request fails
  Future<AddressModel> updateAddress(AddressModel address);

  /// Delete an address using the API
  /// Throws [ServerException] if the request fails
  Future<bool> deleteAddress(String id);

  /// Set an address as default using the API
  /// Throws [ServerException] if the request fails
  Future<AddressModel> setDefaultAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final http.Client client;

  AddressRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/addresses'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> addressesJson = json.decode(response.body);
        return addressesJson
            .map((json) => AddressModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
            message: 'Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AddressModel> getAddressById(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/addresses/$id'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers here
        },
      );

      if (response.statusCode == 200) {
        return AddressModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
            message: 'Failed to load address: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/addresses'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers here
        },
        body: json.encode(address.toJson()),
      );

      if (response.statusCode == 201) {
        return AddressModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
            message: 'Failed to add address: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConstants.baseUrl}/addresses/${address.id}'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers here
        },
        body: json.encode(address.toJson()),
      );

      if (response.statusCode == 200) {
        return AddressModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
            message: 'Failed to update address: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteAddress(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConstants.baseUrl}/addresses/$id'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers here
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        throw ServerException(
            message: 'Failed to delete address: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<AddressModel> setDefaultAddress(String id) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConstants.baseUrl}/addresses/$id/default'),
        headers: {
          'Content-Type': 'application/json',
          // Add authentication headers here
        },
      );

      if (response.statusCode == 200) {
        return AddressModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException(
            message: 'Failed to set default address: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
} 