import 'dart:convert';
import 'package:shelf/src/response.dart';
import 'package:shelf/src/request.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../helpers/jwt_helper.dart';
import 'security_skip_url.dart';

import '../../logger/i_logger.dart';
import '../middleware.dart';

class SecurityMiddleware extends Middleware {
  final ILogger _logger;

  final securitySkipUrl = <SecuritySkipUrl>[
    SecuritySkipUrl(url: '/auth/register', method: 'POST'),
    SecuritySkipUrl(url: '/auth/', method: 'POST'),
  ];

  SecurityMiddleware(this._logger);

  @override
  Future<Response> execute(Request request) async {
    try {
      if (securitySkipUrl.contains(SecuritySkipUrl(url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }
      final authHeader = request.headers['Authorization'];
      if (authHeader == null || authHeader.isEmpty == true) {
        throw JwtException.invalidToken;
      }
      final authHeaderContent = authHeader.split(' ');
      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }
      final authorizationToken = authHeaderContent[1];
      final claims = JwtHelper.getClaims(authorizationToken);
      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }
      final claimsMap = claims.toJson();
      final userId = claimsMap['sub'];
      if (userId == null) {
        throw JwtException.invalidToken;
      }
      final securityHeaders = {
        'user': userId,
        'access_token': authorizationToken,
      };
      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      _logger.error('Error on validate token JWT', e, s);
      return Response.forbidden(
          jsonEncode({'message': 'Acesso negado!', 'error': e.message, 'stackTrace': s.toString()}));
    } catch (e, s) {
      _logger.error('Internal server error', e, s);
      return Response.forbidden(
          jsonEncode({'message': 'Acesso negado!', 'error': e.toString(), 'stackTrace': s.toString()}));
    }
  }
}
