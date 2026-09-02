import '../../../../core/network/mock_resto_api.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class MenuRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts({String? categoryId, String? search});
  Future<ProductModel?> getProductById(String id);
}

class MenuRepositoryImpl implements MenuRepository {
  final MockRestoApi _api;

  MenuRepositoryImpl(this._api);

  @override
  Future<List<CategoryModel>> getCategories() => _api.getCategories();

  @override
  Future<List<ProductModel>> getProducts({String? categoryId, String? search}) =>
      _api.getProducts(categoryId: categoryId, search: search);

  @override
  Future<ProductModel?> getProductById(String id) => _api.getProductById(id);
}
