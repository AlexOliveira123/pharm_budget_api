// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../modules/product/controller/product_controller.dart' as _i15;
import '../../modules/product/data/i_product_repository.dart' as _i6;
import '../../modules/product/data/product_repository.dart' as _i7;
import '../../modules/product/service/i_product_service.dart' as _i9;
import '../../modules/product/service/product_service.dart' as _i10;
import '../../modules/user/controller/auth_controller.dart' as _i16;
import '../../modules/user/data/i_user_repository.dart' as _i11;
import '../../modules/user/data/user_repository.dart' as _i12;
import '../../modules/user/service/i_user_service.dart' as _i13;
import '../../modules/user/service/user_service.dart' as _i14;
import '../database/database_connection.dart' as _i4;
import '../database/i_database_connection.dart' as _i3;
import '../logger/i_logger.dart' as _i8;
import 'database_connection_config.dart' as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get, {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.IDatabaseConnection>(() => _i4.DatabaseConnection(get<_i5.DatabaseConnectionConfig>()));
  gh.lazySingleton<_i6.IProductRepository>(
      () => _i7.ProductRepository(connection: get<_i3.IDatabaseConnection>(), logger: get<_i8.ILogger>()));
  gh.lazySingleton<_i9.IProductService>(() => _i10.ProductService(get<_i6.IProductRepository>()));
  gh.lazySingleton<_i11.IUserRepository>(
      () => _i12.UserRepository(connection: get<_i3.IDatabaseConnection>(), logger: get<_i8.ILogger>()));
  gh.lazySingleton<_i13.IUserService>(() => _i14.UserService(get<_i11.IUserRepository>()));
  gh.factory<_i15.ProductController>(
      () => _i15.ProductController(productService: get<_i9.IProductService>(), logger: get<_i8.ILogger>()));
  gh.factory<_i16.AuthController>(
      () => _i16.AuthController(userService: get<_i13.IUserService>(), logger: get<_i8.ILogger>()));
  return get;
}
