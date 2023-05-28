import '../middleware.dart';
import 'package:shelf/src/response.dart';
import 'package:shelf/src/request.dart';

class DefaultContentTypeMiddlaware extends Middleware {
  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    return response.change(headers: {'content-type': 'application/json;charset=utf-8'});
  }
}
