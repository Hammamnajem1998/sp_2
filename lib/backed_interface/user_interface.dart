class UserInterface {
  final int userId;
  final String email;
  final String password;

  UserInterface({ this.userId, this.email, this.password});

  factory UserInterface.fromJson(Map<String, dynamic> json) {
    return UserInterface(
      userId: json['userId'],
      email: json['id'],
      password: json['title'],
    );
  }
}