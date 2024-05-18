import 'package:flutter/material.dart';
import 'package:gym_front/models/company.dart';
import 'package:gym_front/models/plan.dart';

class Client {
  bool enabled;
  String? rut;
  int? numberClient;
  String? name;
  String? email;
  String? phone;
  String? auxiliarPhone;
  Company? empresa;

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
    this.rut,
    this.numberClient,
    this.name,
    this.email,
    this.phone,
    this.auxiliarPhone,
    this.empresa,
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
        enabled: json['enabled'],
        rut: json['rut'],
        numberClient: json['numberClient'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        auxiliarPhone: json['auxiliarPhone'],
        empresa:
            json['empresa'] != null ? Company.fromJson(json['empresa']) : null,
        comuna: json['comuna'],
        city: json['city'],
        birthDate: json['birthDate'] != null
            ? DateTime.parse(json['birthDate'].toString())
            : null,
        expiredAt: json['expiredAt'] != null
            ? DateTime.parse(json['expiredAt'].toString())
            : null,
        idPlan: json['idPlan'] == null ? 0 : int.parse(json['idPlan']),
        idPayment: json['idPayment'] == null ? 0 : int.parse(json['idPayment']),
        plan: json['plan'] == null ? null : Plan.fromJson(json['plan']),
      );

  static List<Client> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Client.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'rut': rut,
        'numberClient': numberClient,
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
        'empresa': empresa?.toJson() ?? '',
        'plan': plan?.toJson() ?? '',
      };

  String getFormattedExpireDate() {
    if (expiredAt == null) return 'Sin plan';
    // responder en formato dd/mm/yyyy
    return '${expiredAt!.day.toString().padLeft(2, '0')}/${expiredAt!.month.toString().padLeft(2, '0')}/${expiredAt!.year}';
  }

  String getFormattedBirthDate() {
    if (birthDate == null) return 'Sin fecha';
    // responder en formato dd/mm/yyyy
    return '${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.year}';
  }

  bool get isExpired {
    if (expiredAt == null) return false;
    return expiredAt!.difference(DateTime.now()).inDays < 0;
  }

  bool get isExpiring {
    if (expiredAt == null) return false;
    if (isExpired) return false;
    return expiredAt!.difference(DateTime.now()).inDays < 15;
  }

  bool get isExpiringTomorrow {
    if (expiredAt == null) return false;
    if (isExpired) return false;
    return expiredAt!.difference(DateTime.now()).inDays < 1;
  }

  bool get isNotExpired {
    if (expiredAt == null) return false;
    return expiredAt!.difference(DateTime.now()).inDays >= 0;
  }

  Color get color {
    if (expiredAt == null) return Colors.grey;
    if (isExpired) return Colors.red;
    if (isExpiring) return Colors.orange;
    return Colors.green;
  }

//   obtener cuanto tiempo falta para que expire
  String get timeToExpire {
    if (expiredAt == null) return 'Sin plan';
    if (isExpired) return 'Expirado';
    if (isExpiringTomorrow) return 'Expira mañana';
    if (isExpiring) {
      return 'Expira en ${expiredAt!.difference(DateTime.now()).inDays} dias';
    }
    return 'Expira en ${expiredAt!.difference(DateTime.now()).inDays} dias';
  }
}
