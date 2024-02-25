import '../models/payment.dart';
import '../models/plan.dart';

class ClientDTO {
  bool enabled;
  String rut;
  String name;
  String email;
  String phone;
  String auxiliarPhone;
  int idEmpresa;
  int? numberClient;
  DateTime? expiredAt;
  Plan? plan;
  Payment? payment;
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
    this.numberClient,
    this.expiredAt,
    this.plan,
    this.payment,
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
        'numberClient': numberClient,
        // FIXME: Esto quizas de errores para planes diarios, ya que no guarda la hora
        'expiredAt': expiredAt?.toString().substring(0, 10),
        'name': name,
        'phone': phone,
        'plan': plan?.toJson(),
        'payment': payment?.toJson(),
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
        numberClient: json['numberClient'],
        expiredAt: json['expiredAt'],
        name: json['name'],
        phone: json['phone'],
        plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
        payment:
            json['payment'] != null ? Payment.fromJson(json['payment']) : null,
        idEmpresa: json['idEmpresa'],
      );
}
