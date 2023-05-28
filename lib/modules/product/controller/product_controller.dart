import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../application/logger/i_logger.dart';
import '../service/i_product_service.dart';
import '../view_models/search_product_view_model.dart';

part 'product_controller.g.dart';

@Injectable()
class ProductController {
  final IProductService _productService;
  final ILogger _logger;

  ProductController({
    required IProductService productService,
    required ILogger logger,
  })  : _productService = productService,
        _logger = logger;

  @Route.get('/')
  Future<Response> find(Request request) async {
    try {
      final queryParams = jsonEncode(request.url.queryParameters);
      final searchProductViewModel = SearchProductViewModel(queryParams);
      final result = await _productService.getProductByName(searchProductViewModel);
      final response = result.map((item) {
        return {'id': item.id, 'category_id': item.categoryId, 'name': item.name};
      }).toList();
      return Response.ok(jsonEncode({'data': response}));
    } catch (e, s) {
      _logger.error('Error on search user', e, s);
      return Response.internalServerError();
    }
  }

  Router get router => _$ProductControllerRouter(this);
}
