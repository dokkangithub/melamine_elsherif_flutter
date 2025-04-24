import 'package:equatable/equatable.dart';

/// Represents a currency entity in the domain layer
class Currency extends Equatable {
  final String code;
  final String symbol;
  final String symbolNative;
  final String name;
  final bool includeTaxes;

  /// Creates a [Currency] instance
  const Currency({
    required this.code,
    required this.symbol,
    required this.symbolNative,
    required this.name,
    this.includeTaxes = false,
  });

  @override
  List<Object?> get props => [
        code,
        symbol,
        symbolNative,
        name,
        includeTaxes,
      ];
} 