import 'package:dotenv/dotenv.dart' show load, env;
import 'package:get_it/get_it.dart';
import 'package:pharm_budget_api/application/routers/router_config.dart';
import 'package:shelf_router/shelf_router.dart';

import '../logger/i_logger.dart';
import '../logger/logger.dart';
import 'database_connection_config.dart';
import 'service_locator_config.dart';

class ApplicationConfig {
  Future<void> loadConfigApplication(Router router) async {
    await _loadEnv();
    _loadDatabaseConfig();
    _configLogger();
    _loadDependencies();
    _loadRoutersConfig(router);
  }

  Future<void> _loadEnv() async => load();

  void _loadDatabaseConfig() {
    final databaseConfig = DatabaseConnectionConfig(
      host: env['DATABASE_HOST'] ?? env['databaseHost']!,
      user: env['DATABASE_USER'] ?? env['databaseUser']!,
      port: int.tryParse(env['DATABASE_PORT'] ?? env['databasePort']!) ?? 0,
      password: env['DATABASE_PASSWORD'] ?? env['databasePassword']!,
      databaseName: env['DATABASE_NAME'] ?? env['databaseName']!,
    );
    GetIt.I.registerSingleton(databaseConfig);
  }

  void _configLogger() {
    GetIt.I.registerLazySingleton<ILogger>(() => Logger());
  }

  void _loadDependencies() => configureDepedencies();

  void _loadRoutersConfig(Router router) => RouterConfig(router).configure();
}
