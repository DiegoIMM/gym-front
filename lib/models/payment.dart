class Payment {
  final int id;
  final String name;

  Payment({
    required this.id,
    required this.name,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<Payment> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Payment.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
