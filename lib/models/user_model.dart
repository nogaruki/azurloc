class User {
  String id;
  String firstname;
  String lastname;
  String username;
  String email;
  String city;
  String address;
  String password;
  final bool emailVerified;
  final String? verificationToken;
  final DateTime? expireToken;
  final List<String> refreshToken;
  final Map<String, dynamic> roles;
  String? cart;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.password,
    required this.city,
    required this.address,
    required this.emailVerified,
    this.verificationToken,
    this.expireToken,
    required this.refreshToken,
    required this.roles,
    this.cart,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userJson = json['user'];
    return User(
      id: userJson['_id'],
      firstname: userJson['firstname'],
      lastname: userJson['lastname'],
      username: userJson['username'],
      email: userJson['email'],
      password: userJson['password'],
      city: userJson['city'],
      address: userJson['address'],
      emailVerified: userJson['email_verified'],
      verificationToken: userJson['verification_token'],
      expireToken: userJson['expire_token'] != null ? DateTime.parse(userJson['expire_token']) : null,
      refreshToken: List<String>.from(userJson['refreshToken'] ?? []),
      roles: userJson['roles'],
      cart: userJson['cart'] ?? '',
      createdAt: DateTime.parse(userJson['createdAt']),
      updatedAt: DateTime.parse(userJson['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'city': city,
      'address': address,
      'email_verified': emailVerified,
      'verification_token': verificationToken,
      'expire_token': expireToken?.toIso8601String(),
      'refreshToken': refreshToken,
      'roles': roles,
      'cart': cart,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({String? email}) {
    return User(
      id: id,
      firstname: firstname,
      lastname: lastname,
      username: username,
      email: email ?? this.email,
      city: city,
      password: password,
      address: address,
      emailVerified: emailVerified,
      verificationToken: verificationToken,
      expireToken: expireToken,
      refreshToken: refreshToken,
      roles: roles,
      cart: cart,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
