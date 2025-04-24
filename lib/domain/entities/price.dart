import 'package:equatable/equatable.dart';

/// Represents a price entity in the domain layer
class Price extends Equatable {
  /// The numerical value of the price
  final double amount;
  
  /// The currency code for this price (e.g., USD, EUR)
  final String currencyCode;
  
  /// The previous/original price for comparison (used for sales/discounts)
  final double? compareAtAmount;

  /// Creates a [Price] instance
  const Price({
    required this.amount,
    required this.currencyCode,
    this.compareAtAmount,
  });

  @override
  List<Object?> get props => [amount, currencyCode, compareAtAmount];
} 