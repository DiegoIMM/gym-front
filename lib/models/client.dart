class Client {
  bool enabled;
  String rut;
  String name;
  String email;
  String phone;
  String auxiliarPhone;
  int? idEmpresa;

  String? city;
  String? comuna;
  String? address;
  DateTime? birthDate;
  int? idPlan;
  int? idPayment;
  DateTime? expiredAt;

  Client({
    required this.enabled,
    required this.rut,
    required this.name,
    required this.email,
    required this.phone,
    required this.auxiliarPhone,
    required this.idEmpresa,
    this.city,
    this.comuna,
    this.address,
    this.birthDate,
    this.idPlan,
    this.idPayment,
    this.expiredAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        rut: json['rut'],
        address: json['address'],
        comuna: json['comuna'],
        city: json['city'],
        auxiliarPhone: json['auxiliarPhone'],
        birthDate: json['birthDate'] != null
            ? DateTime.parse(json['birthDate'].toString())
            : null,
        email: json['email'],
        enabled: json['enabled'],
        expiredAt: json['expiredAt'] != null
            ? DateTime.parse(json['expiredAt'].toString())
            : null,
        name: json['name'],
        phone: json['phone'],
        idPlan: json['idPlan'] == null ? 0 : int.parse(json['idPlan']),
        idPayment: json['idPayment'] == null ? 0 : int.parse(json['idPayment']),
        idEmpresa: json['idEmpresa'] == null ? 0 : int.parse(json['idEmpresa']),
      );

  static List<Client> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Client.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'rut': rut,
        'address': address,
        'comuna': comuna,
        'city': city,
        'auxiliarPhone': auxiliarPhone,
        'birthDate': birthDate?.toString().substring(0, 10),
        'email': email,
        'enabled': enabled,
        'expiredAt': expiredAt,
        'name': name,
        'phone': phone,
        'idPlan': idPlan,
        'id_payment': idPayment,
        'empresa_id': idEmpresa,
      };
}
