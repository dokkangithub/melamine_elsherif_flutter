/// Represents a product collection entity in the domain layer
class ProductCollection {
  final String id;
  final String title;
  final String? handle;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates a [ProductCollection] instance
  ProductCollection({
    required this.id,
    required this.title,
    this.handle,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
} 