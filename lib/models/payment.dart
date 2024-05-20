import 'package:gym_front/models/client.dart';
import 'package:gym_front/models/plan.dart';

class Payment {
  final int id;
  final DateTime date;
  final DateTime expiredAt;
  final int price;
  final String typeOfPayment;
  final Plan plan;
  final Client client;

  Payment({
    required this.id,
    required this.date,
    required this.expiredAt,
    required this.price,
    required this.typeOfPayment,
    required this.plan,
    required this.client,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      date: DateTime.parse(json['date']),
      expiredAt: DateTime.parse(json['expiredAt']),
      price: json['price'],
      typeOfPayment: json['typeOfPayment'],
      plan: Plan.fromJson(json['plan']),
      client: Client.fromJson(json['client']),
    );
  }

  String getFormattedDate() {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String getFormattedExpiredAt() {
    return '${expiredAt.day.toString().padLeft(2, '0')}/${expiredAt.month.toString().padLeft(2, '0')}/${expiredAt.year}';
  }

  String getFormattedPrice(){
    return '\$${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  static List<Payment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Payment.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toString().substring(0, 10),
        'expiredAt': expiredAt.toString().substring(0, 10),
        'price': price,
        'typeOfPayment': typeOfPayment,
        'plan': plan.toJson(),
        'client': client.toJson(),
      };
}
