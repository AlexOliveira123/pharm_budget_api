import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

import '../../../application/exceptions/database_exception.dart';
import '../../../application/exceptions/user_exists_exception.dart';
import '../../../application/exceptions/user_not_found_exception.dart';
import '../../../application/helpers/cripty_helper.dart';
import '../../../application/logger/i_logger.dart';
import '../../../application/database/i_database_connection.dart';
import '../../../entities/user.dart';

import './i_user_repository.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection _connection;
  final ILogger _logger;

  UserRepository({
    required IDatabaseConnection connection,
    required ILogger logger,
  })  : _connection = connection,
        _logger = logger;

  @override
  Future<User> createUser(User user) async {
    MySqlConnection? conn;
    try {
      conn = await _connection.openConnection();
      final query = 'insert user(full_name, email, cellphone, password) values(?,?,?,?)';
      final result = await conn.query(
        query,
        <Object?>[
          user.fullName,
          user.email,
          user.cellphone,
          CriptyHelper.generateSha256Hash(user.password ?? ''),
        ],
      );
      final userId = result.insertId;
      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('user.email_UNIQUE') || e.message.contains('user.cellphone_UNIQUE')) {
        _logger.error('User already registered on database', e, s);
        throw UserExistsException();
      }
      _logger.error('Error on create user', e, s);
      throw DatabaseException(message: 'Error on create user', exception: e);
    } catch (e, s) {
      _logger.error('Unknown error on create user', e, s);
      throw Exception();
    } finally {
      conn?.close();
    }
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await _connection.openConnection();
      final query = '''
        select * 
        from user 
        where 
          email = ? and 
          password = ?
      ''';
      final result = await conn.query(query, [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);
      if (result.isEmpty) {
        _logger.error('Invalid email or password!');
        throw UserNotFoundException('Invalid email or password!');
      } else {
        final userMap = result.first;
        return User(
          id: userMap['id'] as int,
          fullName: userMap['full_name'],
          email: userMap['email'],
          refreshToken: (userMap['refresh_token'] as Blob?)?.toString(),
        );
      }
    } on MySqlException catch (e, s) {
      _logger.error('Error on login', e, s);
      throw DatabaseException(message: e.message);
    } finally {
      await conn?.close();
    }
  }
}
