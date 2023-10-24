class User {
  int id;
  String name;
  String username;
  String email;
  bool validatedEmail;

  String? profilePicture;
  DateTime createdAt;
  DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.validatedEmail,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

// crear un usuario desde un json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      validatedEmail: json['validated_email'],
      profilePicture: json['profile_picture'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

//   exportar un json desde un usuario
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'validated_email': validatedEmail,
      'profile_picture': profilePicture,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
