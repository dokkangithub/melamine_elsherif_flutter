import 'package:melamine_elsherif/domain/entities/discount.dart';

/// Model class for discount data from the API
class DiscountModel extends Discount {
  /// Creates a [DiscountModel] instance
  const DiscountModel({
    required String id,
    required String code,
    required bool isFixed,
    required double amount,
    String? regionId,
    double? minAmount,
    double? maxAmount,
    DateTime? startsAt,
    DateTime? endsAt,
    int? usageLimit,
    int? usageCount,
    required bool isDisabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          code: code,
          isFixed: isFixed,
          amount: amount,
          regionId: regionId,
          minAmount: minAmount,
          maxAmount: maxAmount,
          startsAt: startsAt,
          endsAt: endsAt,
          usageLimit: usageLimit,
          usageCount: usageCount,
          isDisabled: isDisabled,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Creates a [DiscountModel] instance from JSON data
  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      code: json['code'],
      isFixed: json['is_fixed'] ?? json['type'] == 'fixed',
      amount: json['amount'] is int
          ? (json['amount'] as int).toDouble()
          : (json['amount'] is String
              ? double.parse(json['amount'])
              : json['amount']),
      regionId: json['region_id'],
      minAmount: json['min_amount'] != null
          ? (json['min_amount'] is int
              ? (json['min_amount'] as int).toDouble()
              : (json['min_amount'] is String
                  ? double.parse(json['min_amount'])
                  : json['min_amount']))
          : null,
      maxAmount: json['max_amount'] != null
          ? (json['max_amount'] is int
              ? (json['max_amount'] as int).toDouble()
              : (json['max_amount'] is String
                  ? double.parse(json['max_amount'])
                  : json['max_amount']))
          : null,
      startsAt: json['starts_at'] != null
          ? DateTime.parse(json['starts_at'])
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.parse(json['ends_at'])
          : null,
      usageLimit: json['usage_limit'],
      usageCount: json['usage_count'],
      isDisabled: json['is_disabled'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'is_fixed': isFixed,
      'amount': amount,
      'region_id': regionId,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'usage_limit': usageLimit,
      'usage_count': usageCount,
      'is_disabled': isDisabled,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
} 