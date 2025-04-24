import 'package:melamine_elsherif/domain/entities/money_amount.dart';

/// Model class for money amount data from the API
class MoneyAmountModel extends MoneyAmount {
  /// Creates a [MoneyAmountModel] instance
  MoneyAmountModel({
    required super.id,
    required super.currencyCode,
    required super.amount,
    super.compareAtAmount,
  });

  /// Creates a [MoneyAmountModel] instance from JSON data
  factory MoneyAmountModel.fromJson(Map<String, dynamic> json) {
    return MoneyAmountModel(
      id: json['id'],
      currencyCode: json['currency_code'],
      amount: json['amount'] is String
          ? double.parse(json['amount'])
          : json['amount'],
      compareAtAmount: json['compare_at_amount'] != null
          ? (json['compare_at_amount'] is String
              ? double.parse(json['compare_at_amount'])
              : json['compare_at_amount'])
          : null,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currency_code': currencyCode,
      'amount': amount,
      'compare_at_amount': compareAtAmount,
    };
  }
} 