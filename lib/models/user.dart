class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String userImage;
  final String userType;
  final String createdAt;
  final String message;
  List<String> following;
  List<String> recipies;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.userImage,
    required this.userType,
    required this.createdAt,
    required this.message,
    required this.following,
    required this.recipies,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      userImage: json['userImage'] ?? '',
      userType: json['userType'] ?? '',
      createdAt: json['createdAt'] ?? '',
      message: json['message'] ?? '',
      following: json['following'] == null
          ? []
          : List<String>.from(json["following"].map((x) => x)),
      recipies: json['recipies'] == null
          ? []
          : List<String>.from(json["recipies"].map((x) => x)),
    );
  }

  @override
  toString() => 'User: $id';
}
