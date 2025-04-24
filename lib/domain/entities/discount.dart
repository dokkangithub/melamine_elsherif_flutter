import 'package:equatable/equatable.dart';

/// Represents a discount entity in the domain layer
class Discount extends Equatable {
  /// The unique identifier for this discount
  final String id;
  
  /// The discount code
  final String code;
  
  /// Whether this is a fixed amount discount (true) or percentage (false)
  final bool isFixed;
  
  /// The discount amount (fixed amount or percentage)
  final double amount;
  
  /// The region ID this discount applies to
  final String? regionId;
  
  /// The minimum purchase amount required
  final double? minAmount;
  
  /// The maximum discount amount
  final double? maxAmount;
  
  /// When this discount becomes valid
  final DateTime? startsAt;
  
  /// When this discount expires
  final DateTime? endsAt;
  
  /// The maximum number of times this discount can be used
  final int? usageLimit;
  
  /// How many times this discount has been used
  final int? usageCount;
  
  /// Whether this discount is disabled
  final bool isDisabled;
  
  /// When this discount was created
  final DateTime? createdAt;
  
  /// When this discount was last updated
  final DateTime? updatedAt;

  /// Creates a [Discount] instance
  const Discount({
    required this.id,
    required this.code,
    required this.isFixed,
    required this.amount,
    this.regionId,
    this.minAmount,
    this.maxAmount,
    this.startsAt,
    this.endsAt,
    this.usageLimit,
    this.usageCount,
    required this.isDisabled,
    this.createdAt,
    this.updatedAt,
  });

  /// Checks if the discount is still valid based on dates
  bool get isValid {
    final now = DateTime.now();
    
    if (isDisabled) return false;
    
    if (startsAt != null && now.isBefore(startsAt!)) {
      return false;
    }
    
    if (endsAt != null && now.isAfter(endsAt!)) {
      return false;
    }
    
    if (usageLimit != null && usageCount != null && usageCount! >= usageLimit!) {
      return false;
    }
    
    return true;
  }

  /// Gets the formatted discount value
  String getFormattedValue({String currencySymbol = '\$'}) {
    if (isFixed) {
      if (amount == amount.toInt()) {
        return '$currencySymbol${amount.toInt()}';
      }
      return '$currencySymbol${amount.toStringAsFixed(2)}';
    } else {
      return '${amount.toInt()}%';
    }
  }

  /// Gets the description of the discount
  String get description {
    if (isFixed) {
      return '$code - Fixed amount discount';
    } else {
      return '$code - ${amount.toInt()}% discount';
    }
  }
  
  @override
  List<Object?> get props => [
    id,
    code,
    isFixed,
    amount,
    regionId,
    minAmount,
    maxAmount,
    startsAt,
    endsAt,
    usageLimit,
    usageCount,
    isDisabled,
    createdAt,
    updatedAt,
  ];
} 