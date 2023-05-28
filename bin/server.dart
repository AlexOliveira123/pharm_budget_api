import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:pharm_budget_api/application/config/application_config.dart';
import 'package:pharm_budget_api/application/logger/i_logger.dart';
import 'package:pharm_budget_api/application/middlewares/cors/cors_middleware.dart';
import 'package:pharm_budget_api/application/middlewares/default_content_type/default_content_type_middlaware.dart';
import 'package:pharm_budget_api/application/middlewares/security/security_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final router = Router();
  final appConfig = ApplicationConfig();
  await appConfig.loadConfigApplication(router);

  final getIt = GetIt.I;

  router.get('/', (_) => Response.ok(jsonEncode({'hellorWord': 'Hello, World!'})));

  final handler = Pipeline()
      .addMiddleware(CorsMiddleware().handler)
      .addMiddleware(DefaultContentTypeMiddlaware().handler)
      .addMiddleware(SecurityMiddleware(getIt.get<ILogger>()).handler)
      .addMiddleware(logRequests())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
