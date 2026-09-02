import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/menu_repository.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _repository;

  MenuCubit(this._repository) : super(const MenuState()) {
    loadMenuData();
  }

  Future<void> loadMenuData() async {
    emit(state.copyWith(status: MenuStatus.loading, errorMessage: null));
    try {
      final categories = await _repository.getCategories();
      final products = await _repository.getProducts();
      emit(state.copyWith(
        status: MenuStatus.success,
        categories: categories,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MenuStatus.error,
        errorMessage: 'تعذر تحميل قائمة الطعام، يرجى المحاولة مرة أخرى',
      ));
    }
  }

  void selectCategory(String categoryId) async {
    emit(state.copyWith(selectedCategoryId: categoryId, status: MenuStatus.loading));
    try {
      final products = await _repository.getProducts(
        categoryId: categoryId,
        search: state.searchQuery,
      );
      emit(state.copyWith(status: MenuStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(
        status: MenuStatus.error,
        errorMessage: 'تعذر تصفية الأصناف',
      ));
    }
  }

  void searchDishes(String query) async {
    emit(state.copyWith(searchQuery: query, status: MenuStatus.loading));
    try {
      final products = await _repository.getProducts(
        categoryId: state.selectedCategoryId,
        search: query,
      );
      emit(state.copyWith(status: MenuStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(
        status: MenuStatus.error,
        errorMessage: 'تعذر البحث عن الأصناف',
      ));
    }
  }
}
