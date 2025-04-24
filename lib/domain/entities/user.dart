/// Represents a user entity in the domain layer
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final bool isActive;
  final bool isVerified;
  final String? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Creates a [User] instance
  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.isActive,
    required this.isVerified,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  /// Gets the full name (first name + last name)
  String get fullName => '$firstName $lastName';

  /// Gets the initials from the first and last name
  String get initials {
    if (firstName.isEmpty && lastName.isEmpty) return '';
    
    if (firstName.isEmpty) {
      return lastName[0].toUpperCase();
    }
    
    if (lastName.isEmpty) {
      return firstName[0].toUpperCase();
    }
    
    return '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
  }

  /// Makes a copy of this user with the given fields replaced
  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    bool? isActive,
    bool? isVerified,
    String? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 