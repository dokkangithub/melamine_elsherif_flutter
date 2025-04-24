/// Represents a product tag entity in the domain layer
class ProductTag {
  final String id;
  final String value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates a [ProductTag] instance
  ProductTag({
    required this.id,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });
} 