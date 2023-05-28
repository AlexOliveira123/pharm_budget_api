import 'package:get_it/get_it.dart';
import 'package:pharm_budget_api/modules/user/controller/auth_controller.dart';

import '../../application/routers/i_router.dart';
import 'package:shelf_router/src/router.dart';

class UserRouter implements IRouter {
  @override
  void configure(Router router) {
    final authController = GetIt.I.get<AuthController>();
    router.mount('/auth/', authController.router);
  }
}
