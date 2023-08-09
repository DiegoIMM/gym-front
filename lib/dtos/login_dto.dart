class LoginDTO {
  String email;
  String password;

  LoginDTO({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  factory LoginDTO.fromJson(Map<String, dynamic> json) => LoginDTO(
        email: json['email'],
        password: json['password'],
      );
}
