import 'package:pharm_budget_api/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';

import 'i_router.dart';

class RouterConfig {
  final Router _router;
  final List<IRouter> _routers = [
    UserRouter(),
  ];

  RouterConfig(this._router);

  void configure() {
    for (final router in _routers) {
      router.configure(_router);
    }
  }
}
