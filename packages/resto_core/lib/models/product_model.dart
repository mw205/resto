import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> images;
  final String categoryId;
  final String categoryName;
  final double rating;
  final int reviewsCount;
  final bool isAvailable;
  final int preparationTimeMinutes;
  final int calories;
  final List<String> ingredients;
  final bool isFeatured;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.images = const [],
    required this.categoryId,
    required this.categoryName,
    this.rating = 4.8,
    this.reviewsCount = 120,
    this.isAvailable = true,
    this.preparationTimeMinutes = 25,
    this.calories = 450,
    this.ingredients = const [],
    this.isFeatured = false,
  });

  List<String> get allImages =>
      images.isNotEmpty ? images : (imageUrl.isNotEmpty ? [imageUrl] : []);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imgs = (json['images'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        (json['imageUrl'] != null && (json['imageUrl'] as String).isNotEmpty
            ? [json['imageUrl'] as String]
            : <String>[]);

    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String? ?? (imgs.isNotEmpty ? imgs.first : ''),
      images: imgs,
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: json['reviewsCount'] as int? ?? 120,
      isAvailable: json['isAvailable'] as bool? ?? true,
      preparationTimeMinutes: json['preparationTimeMinutes'] as int? ?? 25,
      calories: json['calories'] as int? ?? 450,
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'isAvailable': isAvailable,
      'preparationTimeMinutes': preparationTimeMinutes,
      'calories': calories,
      'ingredients': ingredients,
      'isFeatured': isFeatured,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? images,
    String? categoryId,
    String? categoryName,
    double? rating,
    int? reviewsCount,
    bool? isAvailable,
    int? preparationTimeMinutes,
    int? calories,
    List<String>? ingredients,
    bool? isFeatured,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTimeMinutes: preparationTimeMinutes ?? this.preparationTimeMinutes,
      calories: calories ?? this.calories,
      ingredients: ingredients ?? this.ingredients,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        images,
        categoryId,
        categoryName,
        rating,
        reviewsCount,
        isAvailable,
        preparationTimeMinutes,
        calories,
        ingredients,
        isFeatured,
      ];
}
