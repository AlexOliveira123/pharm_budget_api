import '../../../entities/product.dart';
import '../view_models/search_product_view_model.dart';

abstract class IProductService {
  Future<List<Product>> getProductByName(SearchProductViewModel searchProductViewModel);
}
