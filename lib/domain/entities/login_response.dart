import 'package:melamine_elsherif/domain/entities/user.dart';

class LoginResponse {
  final User user;
  final String token;

  const LoginResponse({
    required this.user,
    required this.token,
  });
} 