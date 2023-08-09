class QuestionDTO {
  String title;
  int categoryId;
  String detail;
  int countryId;
  int userId;
  List<dynamic> tags;

  QuestionDTO(
      {required this.title,
      required this.categoryId,
      required this.detail,
      required this.countryId,
      required this.userId,
      required this.tags});

  Map<String, dynamic> toJson() => {
        'title': title,
        'categoryId': categoryId,
        'detail': detail,
        'countryId': countryId,
        'userId': userId,
        'tags': tags,
      };

  factory QuestionDTO.fromJson(Map<String, dynamic> json) => QuestionDTO(
        title: json['title'],
        categoryId: json['categoryId'],
        detail: json['detail'],
        countryId: json['countryId'],
        userId: json['userId'],
        tags: json['tags'],
      );
}
