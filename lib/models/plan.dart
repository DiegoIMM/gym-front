class Plan {
  int id;
  bool enabled;
  String name;
  String description;
  String period;
  int price;

  Plan({
    required this.id,
    required this.enabled,
    required this.name,
    required this.description,
    required this.period,
    required this.price,
  });

  int durationInDays() {
    switch (period) {
      case 'Diario':
        return 1;
      case 'Semanal':
        return 7;
      case 'BiSemanal':
        return 14;
      case 'Mensual':
        return 30;
      case 'Trimestral':
        return 92;
      case 'Semestral':
        return 184;
      case 'Anual':
        return 365;
      default:
        return 0;
    }
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      enabled: json['enabled'],
      name: json['name'],
      description: json['description'],
      period: json['period'],
      price: json['price'],
    );
  }

  static List<Plan> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Plan.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'enabled': enabled,
        'name': name,
        'description': description,
        'period': period,
        'price': price,
      };
}
