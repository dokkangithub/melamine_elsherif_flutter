import 'package:equatable/equatable.dart';

/// Represents a country entity in the domain layer
class Country extends Equatable {
  final String id;
  final String iso2;
  final String iso3;
  final String numCode;
  final String name;
  final String displayName;
  final String? regionId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates a [Country] instance
  const Country({
    required this.id,
    required this.iso2,
    required this.iso3,
    required this.numCode,
    required this.name,
    required this.displayName,
    this.regionId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        iso2,
        iso3,
        numCode,
        name,
        displayName,
        regionId,
        createdAt,
        updatedAt,
      ];
} 