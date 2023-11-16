class Company {
  final int id;
  final String rut;
  final String nombre;
  final String direccion;

  Company({
    required this.id,
    required this.rut,
    required this.nombre,
    required this.direccion,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      rut: json['rut'],
      nombre: json['nombre'],
      direccion: json['direccion'],
    );
  }

  static List<Company> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Company.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'rut': rut,
        'nombre': nombre,
        'direccion': direccion,
      };
}
