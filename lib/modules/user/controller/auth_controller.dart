import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../modules/user/view_models/login_view_model.dart';
import '../../../application/helpers/jwt_helper.dart';
import '../../../application/exceptions/user_not_found_exception.dart';
import '../../../application/exceptions/user_exists_exception.dart';
import '../../../application/logger/i_logger.dart';
import '../service/i_user_service.dart';
import '../view_models/user_save_input_view_model.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  final IUserService _userService;
  final ILogger _logger;

  AuthController({
    required IUserService userService,
    required ILogger logger,
  })  : _userService = userService,
        _logger = logger;

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());
      final user = await _userService.loginWithEmailAndPassword(loginViewModel.login, loginViewModel.password);
      return Response.ok(jsonEncode({'access_token': JwtHelper.generateJWT(user.id!)}));
    } on UserNotFoundException {
      return Response.forbidden(jsonEncode({'message': 'Usuário ou senha inválidos!'}));
    } catch (e, s) {
      _logger.error('Error on login', e, s);
      return Response.internalServerError(body: jsonEncode({'message': 'Erro ao realizar login!'}));
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputViewModel(await request.readAsString());
      await _userService.createUser(userModel);
      return Response.ok(jsonEncode({'message': 'Cadastro realizado com sucesso!'}));
    } on UserExistsException {
      return Response(400, body: jsonEncode({'message': 'Usuário já cadastrado!'}));
    } catch (e, s) {
      _logger.error('Error on register user', e, s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
