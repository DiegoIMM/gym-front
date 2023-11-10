class PaymentDTO {
  DateTime date;
  DateTime expiredAt;
  int price;
  String typeOfPayment;
  String rutClient;
  int idPlan;
  int idEmpresa;

  PaymentDTO({
    required this.date,
    required this.expiredAt,
    required this.price,
    required this.typeOfPayment,
    required this.rutClient,
    required this.idPlan,
    required this.idEmpresa,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toString().substring(0, 10),
        'expiredAt': expiredAt.toString().substring(0, 10),
        'price': price,
        'typeOfPayment': typeOfPayment,
        'rutClient': rutClient,
        'idPlan': idPlan,
        'idEmpresa': idEmpresa,
      };

  factory PaymentDTO.fromJson(Map<String, dynamic> json) => PaymentDTO(
        date: DateTime.parse(json['date']),
        expiredAt: DateTime.parse(json['expiredAt']),
        price: json['price'],
        typeOfPayment: json['typeOfPayment'],
        rutClient: json['rutClient'],
        idPlan: json['idPlan'],
        idEmpresa: json['idEmpresa'],
      );
}
