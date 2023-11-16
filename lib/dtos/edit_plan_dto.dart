class EditPlanDTO {
  int id;
  bool enabled;
  String name;
  String description;
  String period;
  int price;

  EditPlanDTO(
      {required this.id,
      required this.enabled,
      required this.name,
      required this.description,
      required this.period,
      required this.price});

  Map<String, dynamic> toJson() => {
        'id': id,
        'enabled': enabled,
        'name': name,
        'description': description,
        'period': period,
        'price': price,
      };

  factory EditPlanDTO.fromJson(Map<String, dynamic> json) => EditPlanDTO(
        id: json['id'],
        enabled: json['enabled'],
        name: json['name'],
        description: json['description'],
        period: json['period'],
        price: json['price'],
      );
}
