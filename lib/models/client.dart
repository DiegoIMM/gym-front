import 'package:gym_front/models/company.dart';
import 'package:gym_front/models/plan.dart';

class Client {
  bool enabled;
  String rut;
  String name;
  String email;
  String phone;
  String auxiliarPhone;
  Company empresa;

  String? city;
  String? comuna;
  String? address;
  DateTime? birthDate;
  int? idPlan;
  int? idPayment;
  DateTime? expiredAt;
  Plan? plan;

  Client({
    required this.enabled,
    required this.rut,
    required this.name,
    required this.email,
    required this.phone,
    required this.auxiliarPhone,
    required this.empresa,
    this.city,
    this.comuna,
    this.address,
    this.birthDate,
    this.idPlan,
    this.idPayment,
    this.expiredAt,
    this.plan,
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
        empresa: Company.fromJson(json['empresa']),
        plan: json['plan'] == null ? null : Plan.fromJson(json['plan']),
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
        'empresa': empresa.toJson(),
        'plan': plan?.toJson() ?? '',
      };
}
