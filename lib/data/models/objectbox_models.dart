import 'package:objectbox/objectbox.dart';

@Entity()
class ProductBoxModel {
  @Id()
  int id = 0;
  
  String productId;
  String title;
  String? handle;
  String? description;
  String? thumbnail;
  bool isGiftCard;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isInWishlist;

  ProductBoxModel({
    required this.productId,
    required this.title,
    this.handle,
    this.description,
    this.thumbnail,
    required this.isGiftCard,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isInWishlist = false,
  });
}

@Entity()
class ProductCategoryBoxModel {
  @Id()
  int id = 0;
  
  String categoryId;
  String name;
  String? handle;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductCategoryBoxModel({
    required this.categoryId,
    required this.name,
    this.handle,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
}

@Entity()
class ProductCollectionBoxModel {
  @Id()
  int id = 0;
  
  String collectionId;
  String title;
  String? handle;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductCollectionBoxModel({
    required this.collectionId,
    required this.title,
    this.handle,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
}

@Entity()
class ProductTagBoxModel {
  @Id()
  int id = 0;
  
  String tagId;
  String value;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductTagBoxModel({
    required this.tagId,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });
} 