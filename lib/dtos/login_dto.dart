class LoginDTO {
  String users;
  String pass;

  LoginDTO({required this.users, required this.pass});

  Map<String, dynamic> toJson() => {
        'users': users,
        'pass': pass,
      };

  factory LoginDTO.fromJson(Map<String, dynamic> json) => LoginDTO(
        users: json['users'],
        pass: json['pass'],
      );
}
