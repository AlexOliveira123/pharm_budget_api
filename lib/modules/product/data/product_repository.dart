import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import '../../../application/exceptions/database_exception.dart';
import '../../../application/logger/i_logger.dart';
import '../../../application/database/i_database_connection.dart';

import '../../../entities/product.dart';
import './i_product_repository.dart';

@LazySingleton(as: IProductRepository)
class ProductRepository implements IProductRepository {
  final IDatabaseConnection _connection;
  final ILogger _logger;

  ProductRepository({
    required IDatabaseConnection connection,
    required ILogger logger,
  })  : _connection = connection,
        _logger = logger;

  @override
  Future<List<Product>> getProductByName(String name) async {
    MySqlConnection? conn;
    try {
      conn = await _connection.openConnection();
      final query = 'select * from product where name like ?';
      final result = await conn.query(query, <Object?>['%$name%']);
      return result.map((item) {
        return Product(
          id: item['id'] as int?,
          categoryId: item['category_id'] as int?,
          name: item['name'],
        );
      }).toList();
    } on MySqlException catch (e, s) {
      _logger.error('Error on get product', e, s);
      throw DatabaseException(message: 'Error on get product', exception: e);
    } catch (e, s) {
      _logger.error('Unknown error on get product', e, s);
      throw Exception();
    } finally {
      conn?.close();
    }
  }
}
