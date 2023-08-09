class PlanDTO {
  bool enabled;
  String name;
  String description;
  String period;
  int price;

  PlanDTO(
      {required this.enabled,
      required this.name,
      required this.description,
      required this.period,
      required this.price});

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'name': name,
        'description': description,
        'period': period,
        'price': price,
      };

  factory PlanDTO.fromJson(Map<String, dynamic> json) => PlanDTO(
        enabled: json['enabled'],
        name: json['name'],
        description: json['description'],
        period: json['period'],
        price: json['price'],
      );
}
