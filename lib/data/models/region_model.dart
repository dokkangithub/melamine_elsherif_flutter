import 'package:melamine_elsherif/domain/entities/region.dart';

/// Model class for region data from the API
class RegionModel extends Region {
  /// Creates a [RegionModel] instance
  const RegionModel({
    required String id,
    required String name,
    required String currencyCode,
    double? taxRate,
    String? taxCode,
    List<String>? paymentProviderIds,
    List<String>? fulfillmentProviderIds,
    List<dynamic>? countries,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) : super(
          id: id,
          name: name,
          currencyCode: currencyCode,
          taxRate: taxRate,
          taxCode: taxCode,
          paymentProviderIds: paymentProviderIds,
          fulfillmentProviderIds: fulfillmentProviderIds,
          countries: countries,
          metadata: metadata,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
        );

  /// Creates a [RegionModel] instance from JSON data
  factory RegionModel.fromJson(Map<String, dynamic> json) {
    List<String>? paymentProviderIds;
    List<String>? fulfillmentProviderIds;
    
    if (json['payment_providers'] != null) {
      paymentProviderIds = [];
      for (var provider in json['payment_providers']) {
        if (provider['id'] != null) {
          paymentProviderIds.add(provider['id']);
        }
      }
    }
    
    if (json['fulfillment_providers'] != null) {
      fulfillmentProviderIds = [];
      for (var provider in json['fulfillment_providers']) {
        if (provider['id'] != null) {
          fulfillmentProviderIds.add(provider['id']);
        }
      }
    }
    
    return RegionModel(
      id: json['id'],
      name: json['name'],
      currencyCode: json['currency_code'],
      taxRate: json['tax_rate'] != null ? double.parse(json['tax_rate'].toString()) : null,
      taxCode: json['tax_code'],
      paymentProviderIds: paymentProviderIds,
      fulfillmentProviderIds: fulfillmentProviderIds,
      countries: json['countries'],
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      deletedAt:
          json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'currency_code': currencyCode,
      'tax_rate': taxRate,
      'tax_code': taxCode,
      'payment_provider_ids': paymentProviderIds,
      'fulfillment_provider_ids': fulfillmentProviderIds,
      'countries': countries,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
} 