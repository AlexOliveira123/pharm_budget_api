import 'package:injectable/injectable.dart';
import 'package:mysql1/src/single_connection.dart';

import '../config/database_connection_config.dart';
import './i_database_connection.dart';

@LazySingleton(as: IDatabaseConnection)
class DatabaseConnection implements IDatabaseConnection {
  final DatabaseConnectionConfig _databaseConnectionConfig;

  DatabaseConnection(this._databaseConnectionConfig);

  @override
  Future<MySqlConnection> openConnection() {
    final connectionSettings = ConnectionSettings(
      host: _databaseConnectionConfig.host,
      port: _databaseConnectionConfig.port,
      user: _databaseConnectionConfig.user,
      password: _databaseConnectionConfig.password,
      db: _databaseConnectionConfig.databaseName,
    );
    return MySqlConnection.connect(connectionSettings);
  }
}
