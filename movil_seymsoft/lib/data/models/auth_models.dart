class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  final int id;
  final String fullName;
  final String email;
  final String phone;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['idUser'] as int,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }
}

class AuthRole {
  const AuthRole({required this.id, required this.name});

  final int id;
  final String name;

  bool get isAdministrator => id == 1 && name == 'Administrator';

  factory AuthRole.fromJson(Map<String, dynamic> json) {
    return AuthRole(
      id: json['idRole'] as int,
      name: json['nameRole'] as String? ?? '',
    );
  }
}

class AuthProfile {
  const AuthProfile({required this.user, required this.role});

  final AuthUser user;
  final AuthRole role;

  factory AuthProfile.fromJson(Map<String, dynamic> json) {
    return AuthProfile(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      role: AuthRole.fromJson(json['role'] as Map<String, dynamic>),
    );
  }
}
