import 'package:equatable/equatable.dart';

/// Entity representing a shipping profile in the Medusa commerce system
class ShippingProfile extends Equatable {
  /// Unique identifier for the shipping profile
  final String id;
  
  /// Name of the shipping profile
  final String name;
  
  /// Type of the shipping profile (default, gift_card, custom)
  final String type;
  
  /// When the shipping profile was created
  final DateTime createdAt;
  
  /// When the shipping profile was last updated
  final DateTime updatedAt;
  
  /// When the shipping profile was deleted
  final DateTime? deletedAt;
  
  /// Additional metadata
  final Map<String, dynamic>? metadata;

  /// Constructs a shipping profile entity
  const ShippingProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    createdAt,
    updatedAt,
    deletedAt,
    metadata,
  ];
} 