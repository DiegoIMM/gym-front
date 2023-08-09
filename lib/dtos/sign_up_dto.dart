
class SignUpDTO {
  String name;
  String username;
  String email;
  String password;

  SignUpDTO({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
      };

  factory SignUpDTO.fromJson(Map<String, dynamic> json) => SignUpDTO(
        name: json['name'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
      );
}
