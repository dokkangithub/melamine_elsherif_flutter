import 'package:melamine_elsherif/domain/entities/price.dart';

/// Model class for price data from the API
class PriceModel extends Price {
  /// Creates a [PriceModel] instance
  const PriceModel({
    required double amount,
    required String currencyCode,
    double? compareAtAmount,
  }) : super(
          amount: amount,
          currencyCode: currencyCode,
          compareAtAmount: compareAtAmount,
        );

  /// Creates a [PriceModel] instance from JSON data
  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      amount: json['amount'] is int
          ? (json['amount'] as int).toDouble()
          : json['amount'],
      currencyCode: json['currency_code'],
      compareAtAmount: json['compare_at_amount'] != null
          ? (json['compare_at_amount'] is int
              ? (json['compare_at_amount'] as int).toDouble()
              : json['compare_at_amount'])
          : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency_code': currencyCode,
      'compare_at_amount': compareAtAmount,
    };
  }
} 