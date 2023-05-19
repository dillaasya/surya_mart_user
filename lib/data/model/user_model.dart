class User {
  final String? id;
  final String userName;
  final String email;
  final String phone;
  final String password;
  final String? image;

  User({
    this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.phone,
    this.image,
  });
}
