import '../../../entities/product.dart';

abstract class IProductRepository {
  Future<List<Product>> getProductByName(String name);
}
