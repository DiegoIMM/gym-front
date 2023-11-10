class Payment {
  final int id;
  final DateTime date;
  final DateTime expiredAt;
  final int price;
  final String typeOfPayment;
  final String rutClient;
  final int idPlan;
  final int idEmpresa;

  Payment({
    required this.id,
    required this.date,
    required this.expiredAt,
    required this.price,
    required this.typeOfPayment,
    required this.rutClient,
    required this.idPlan,
    required this.idEmpresa,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      date: DateTime.parse(json['date']),
      expiredAt: DateTime.parse(json['expiredAt']),
      price: json['price'],
      typeOfPayment: json['typeOfPayment'],
      rutClient: json['rutClient'],
      idPlan: json['idPlan'],
      idEmpresa: json['idEmpresa'],
    );
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
        'rutClient': rutClient,
        'idPlan': idPlan,
        'idEmpresa': idEmpresa,
      };
}
