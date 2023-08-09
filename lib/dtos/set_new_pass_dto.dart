class SetNewPassDTO {
  String token;
  String password;

  SetNewPassDTO({required this.token, required this.password});

  Map<String, dynamic> toJson() => {
        'token': token,
        'password': password,
      };

  factory SetNewPassDTO.fromJson(Map<String, dynamic> json) => SetNewPassDTO(
        token: json['token'],
        password: json['password'],
      );
}
