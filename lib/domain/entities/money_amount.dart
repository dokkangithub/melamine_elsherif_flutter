import 'package:equatable/equatable.dart';

/// Represents a money amount entity in the domain layer
class MoneyAmount extends Equatable {
  /// The unique identifier for this money amount
  final String id;
  
  /// The currency code (e.g., USD, EUR)
  final String currencyCode;
  
  /// The amount value
  final num amount;
  
  /// The compare-at amount value (original price before discount)
  final num? compareAtAmount;

  /// Creates a [MoneyAmount] instance
  const MoneyAmount({
    required this.id,
    required this.currencyCode,
    required this.amount,
    this.compareAtAmount,
  });

  /// Checks if this money amount has a discount
  bool get hasDiscount => compareAtAmount != null && compareAtAmount! > amount;

  /// Gets the discount amount
  num get discountAmount {
    if (!hasDiscount) return 0;
    return compareAtAmount! - amount;
  }

  /// Gets the discount percentage
  double get discountPercentage {
    if (!hasDiscount || compareAtAmount == 0) return 0;
    return (discountAmount / compareAtAmount!) * 100;
  }

  /// Formats the amount with currency symbol
  String format({bool includeSymbol = true}) {
    final symbol = _getCurrencySymbol(currencyCode);
    final formattedAmount = _formatNumber(amount);
    
    if (includeSymbol) {
      return '$symbol$formattedAmount';
    }
    return formattedAmount;
  }

  /// Formats the compare-at amount with currency symbol
  String formatCompareAt({bool includeSymbol = true}) {
    if (compareAtAmount == null) return '';
    
    final symbol = _getCurrencySymbol(currencyCode);
    final formattedAmount = _formatNumber(compareAtAmount!);
    
    if (includeSymbol) {
      return '$symbol$formattedAmount';
    }
    return formattedAmount;
  }

  /// Helper method to format numbers
  String _formatNumber(num number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2);
  }

  /// Helper method to get currency symbol
  String _getCurrencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CNY':
        return '¥';
      case 'KRW':
        return '₩';
      case 'INR':
        return '₹';
      case 'RUB':
        return '₽';
      case 'EGP':
        return 'E£';
      default:
        return code;
    }
  }
  
  @override
  List<Object?> get props => [
    id,
    currencyCode,
    amount,
    compareAtAmount,
  ];
} 