
class UpdateUserDTO {
  int userId;
  String name;
  String? biography;
  String? profilePicture;

  UpdateUserDTO({
    required this.userId,
    required this.name,
    this.biography = "",
    this.profilePicture = "",
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'biography': biography,
        'profilePicture': profilePicture,
      };

  factory UpdateUserDTO.fromJson(Map<String, dynamic> json) => UpdateUserDTO(
        userId: json['userId'],
        name: json['name'],
        biography: json['biography'],
        profilePicture: json['profilePicture'],
      );
}
