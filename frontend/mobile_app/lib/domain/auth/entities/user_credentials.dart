// lib/domain/auth/entities/user_credentials.dart

/// Value object for login credentials with basic normalization.
class UserCredentials {
  final String email;
  final String password;

  const UserCredentials({
    required this.email,
    required this.password,
  });

  factory UserCredentials.normalize({
    required String email,
    required String password,
  }) {
    return UserCredentials(
      email: email.trim().toLowerCase(),
      password: password.trim(),
    );
  }
}
