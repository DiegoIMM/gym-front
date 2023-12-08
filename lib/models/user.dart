class User {
  int id;
  String users;
  String rol;
  bool habilitado;

  User({
    required this.id,
    required this.users,
    required this.rol,
    required this.habilitado,
  });

// crear un usuario desde un json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      users: json['users'],
      rol: json['rol'],
      habilitado: json['habilitado'],
    );
  }

//   exportar un json desde un usuario
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users': users,
      'rol': rol,
      'habilitado': habilitado,
    };
  }
}
