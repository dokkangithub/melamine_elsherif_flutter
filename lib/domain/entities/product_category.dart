/// Represents a product category entity in the domain layer
class ProductCategory {
  final String id;
  final String name;
  final String? handle;
  final String? description;
  final String? parentCategoryId;
  final ProductCategory? parent;
  final List<ProductCategory>? children;
  final bool isActive;
  final int? rank;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates a [ProductCategory] instance
  ProductCategory({
    required this.id,
    required this.name,
    this.handle,
    this.description,
    this.parentCategoryId,
    this.parent,
    this.children,
    required this.isActive,
    this.rank,
    this.createdAt,
    this.updatedAt,
  });

  /// Gets the full category path (parent/child/grandchild)
  String get fullPath {
    final List<String> pathParts = [];
    
    // Add parent categories
    ProductCategory? currentParent = parent;
    while (currentParent != null) {
      pathParts.insert(0, currentParent.name);
      currentParent = currentParent.parent;
    }
    
    // Add this category
    pathParts.add(name);
    
    return pathParts.join(' / ');
  }

  /// Checks if this category has any children
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Checks if this category is a root category (no parent)
  bool get isRoot => parentCategoryId == null;
} 