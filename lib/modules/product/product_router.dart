import 'package:get_it/get_it.dart';

import '../../application/routers/i_router.dart';
import 'package:shelf_router/src/router.dart';

import 'controller/product_controller.dart';

class ProductRouter implements IRouter {
  @override
  void configure(Router router) {
    final productController = GetIt.I.get<ProductController>();
    router.mount('/product/', productController.router);
  }
}
