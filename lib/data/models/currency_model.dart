import 'package:melamine_elsherif/domain/entities/currency.dart';

/// Model class for currency data from the API
class CurrencyModel extends Currency {
  /// Creates a [CurrencyModel] instance
  const CurrencyModel({
    required String code,
    required String symbol,
    required String symbolNative,
    required String name,
    bool includeTaxes = false,
  }) : super(
          code: code,
          symbol: symbol,
          symbolNative: symbolNative,
          name: name,
          includeTaxes: includeTaxes,
        );

  /// Creates a [CurrencyModel] instance from JSON data
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'],
      symbol: json['symbol'],
      symbolNative: json['symbol_native'],
      name: json['name'],
      includeTaxes: json['includes_tax'] ?? false,
    );
  }

  /// Converts this model to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'symbol': symbol,
      'symbol_native': symbolNative,
      'name': name,
      'includes_tax': includeTaxes,
    };
  }
} 