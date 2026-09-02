import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

enum MenuStatus { initial, loading, success, error }

class MenuState extends Equatable {
  final MenuStatus status;
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final String selectedCategoryId;
  final String searchQuery;
  final String? errorMessage;

  const MenuState({
    this.status = MenuStatus.initial,
    this.categories = const [],
    this.products = const [],
    this.selectedCategoryId = 'all',
    this.searchQuery = '',
    this.errorMessage,
  });

  List<ProductModel> get featuredProducts => products.where((p) => p.isFeatured).toList();

  MenuState copyWith({
    MenuStatus? status,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    String? selectedCategoryId,
    String? searchQuery,
    String? errorMessage,
  }) {
    return MenuState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        products,
        selectedCategoryId,
        searchQuery,
        errorMessage,
      ];
}
