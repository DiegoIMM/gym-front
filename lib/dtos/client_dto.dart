class ClientDTO {
  bool enabled;
  String rut;
  String name;
  String email;
  String phone;
  String auxiliarPhone;
  int idEmpresa;
  DateTime? expiredAt;
  int? idPlan;
  String? idPayment;
  String? address;
  String? comuna;
  String? city;
  DateTime? birthDate;

  ClientDTO({
    required this.enabled,
    required this.rut,
    required this.name,
    required this.email,
    required this.phone,
    required this.auxiliarPhone,
    required this.idEmpresa,
    this.expiredAt,
    this.idPlan,
    this.idPayment,
    this.address,
    this.comuna,
    this.city,
    this.birthDate,
  });

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
        'idEmpresa': idEmpresa,
      };

  factory ClientDTO.fromJson(Map<String, dynamic> json) => ClientDTO(
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
        expiredAt: json['expiredAt'],
        name: json['name'],
        phone: json['phone'],
        idPlan: json['idPlan'],
        idPayment: json['idPayment'],
        idEmpresa: json['idEmpresa'],
      );
}
