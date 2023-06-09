import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  JwtHelper._();

  static final String _jwtSecret = env['JWT_SECRET'] ?? env['jwtSecret']!;

  static String generateJWT(int userId) {
    final claimSet = JwtClaim(
      issuer: 'pharm_budget',
      subject: userId.toString(),
      expiry: DateTime.now().add(const Duration(days: 1)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      maxAge: const Duration(days: 1),
    );
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }

  static JwtClaim getClaims(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }

  static String refreshToken(String accessToken) {
    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(const Duration(days: 15)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
    );
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }
}
