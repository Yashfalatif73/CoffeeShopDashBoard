class ProductModel {
  final String? productId;
  final String name;
  final String price;
  final String category;
  final int quantity;
  final String image;
  final String? subCategory;
  final String? availableIn;
  final String? size;
  final String createdAt;

  ProductModel({
    this.productId,
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
    required this.image,
    this.subCategory,
    this.availableIn,
    this.size,
    required this.createdAt,
  });

  /// Convert from JSON (Firestore document)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] as String?,
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '0',
      category: json['category'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      image: json['image'] as String? ?? 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      subCategory: json['subCategory'] as String?,
      availableIn: json['availableIn'] as String?,
      size: json['size'] as String?,
      createdAt: json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  /// Convert to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'price': price,
      'category': category,
      'quantity': quantity,
      'image': image,
      'createdAt': createdAt,
    };

    // Add productId if it exists
    if (productId != null) {
      data['productId'] = productId;
    }

    // Add coffee-specific fields if they exist
    if (subCategory != null) {
      data['subCategory'] = subCategory;
    }
    if (availableIn != null) {
      data['availableIn'] = availableIn;
    }
    if (size != null) {
      data['size'] = size;
    }

    return data;
  }

  /// Create a copy with updated fields
  ProductModel copyWith({
    String? productId,
    String? name,
    String? price,
    String? category,
    int? quantity,
    String? image,
    String? subCategory,
    String? availableIn,
    String? size,
    String? createdAt,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      subCategory: subCategory ?? this.subCategory,
      availableIn: availableIn ?? this.availableIn,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get formatted category text for display
  String getCategoryDisplayText() {
    if (category == "Coffee" && subCategory != null && subCategory!.isNotEmpty) {
      return "$subCategory ${availableIn != null && availableIn!.isNotEmpty ? '($availableIn)' : ''}";
    }
    return category;
  }

  /// Get size display text
  String getSizeDisplayText() {
    return size ?? '-';
  }

  @override
  String toString() {
    return 'ProductModel(productId: $productId, name: $name, price: $price, category: $category, quantity: $quantity)';
  }
}

