class User {
  final int? id;
  final String? fullName;
  final String? email;
  final String? cellphone;
  final String? password;
  final String? refreshToken;

  User({
    this.id,
    this.fullName,
    this.email,
    this.cellphone,
    this.password,
    this.refreshToken,
  });

  User copyWith({
    int? id,
    String? fullName,
    String? email,
    String? cellphone,
    String? password,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      cellphone: cellphone ?? this.cellphone,
      password: password ?? this.password,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
