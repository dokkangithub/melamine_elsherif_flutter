import 'package:melamine_elsherif/domain/entities/shipping_option.dart';
import 'package:melamine_elsherif/data/models/price_model.dart';
import 'package:melamine_elsherif/data/models/shipping_profile_model.dart';

/// Model class for shipping option data from the API
class ShippingOptionModel extends ShippingOption {
  /// Creates a [ShippingOptionModel] instance
  const ShippingOptionModel({
    required String id,
    required String name,
    required String regionId,
    ShippingProfileModel? profile,
    required String profileId,
    required String provider,
    required String providerId,
    PriceModel? price,
    PriceModel? priceIncludingTax,
    bool isReturn = false,
    bool requiresShippingData = false,
    Map<String, dynamic>? data,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    Map<String, dynamic>? metadata,
  }) : super(
          id: id,
          name: name,
          regionId: regionId,
          profile: profile,
          profileId: profileId,
          provider: provider,
          providerId: providerId,
          price: price,
          priceIncludingTax: priceIncludingTax,
          isReturn: isReturn,
          requiresShippingData: requiresShippingData,
          data: data,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          metadata: metadata,
        );

  /// Creates a [ShippingOptionModel] instance from JSON data
  factory ShippingOptionModel.fromJson(Map<String, dynamic> json) {
    return ShippingOptionModel(
      id: json['id'],
      name: json['name'],
      regionId: json['region_id'],
      profile: json['profile'] != null
          ? ShippingProfileModel.fromJson(json['profile'])
          : null,
      profileId: json['profile_id'],
      provider: json['provider_id'] ?? '',
      providerId: json['provider_id'] ?? '',
      price: json['amount'] != null
          ? PriceModel.fromJson({
              'amount': json['amount'],
              'currency_code': json['region']?['currency_code'] ?? '',
            })
          : null,
      priceIncludingTax: json['price_incl_tax'] != null
          ? PriceModel.fromJson({
              'amount': json['price_incl_tax'],
              'currency_code': json['region']?['currency_code'] ?? '',
            })
          : null,
      isReturn: json['is_return'] ?? false,
      requiresShippingData: json['data']?.isNotEmpty ?? false,
      data: json['data'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      deletedAt:
          json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      metadata: json['metadata'],
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region_id': regionId,
      'profile_id': profileId,
      'provider_id': providerId,
      'price': price != null ? (price as PriceModel).toJson() : null,
      'price_incl_tax': priceIncludingTax != null
          ? (priceIncludingTax as PriceModel).toJson()
          : null,
      'is_return': isReturn,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }
} 