import 'package:injectable/injectable.dart';

import '../../../entities/product.dart';
import '../data/i_product_repository.dart';
import '../view_models/search_product_view_model.dart';
import 'i_product_service.dart';

@LazySingleton(as: IProductService)
class ProductService implements IProductService {
  final IProductRepository _productRepository;

  ProductService(this._productRepository);

  @override
  Future<List<Product>> getProductByName(SearchProductViewModel searchProductViewModel) {
    return _productRepository.getProductByName(searchProductViewModel.name);
  }
}
