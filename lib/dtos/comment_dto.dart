class CommentDTO {
  String detail;
  int userId;
  int answerId;

  CommentDTO(
      {required this.detail, required this.userId, required this.answerId});

  Map<String, dynamic> toJson() => {
        'detail': detail,
        'userId': userId,
        'answerId': answerId,
      };

  factory CommentDTO.fromJson(Map<String, dynamic> json) => CommentDTO(
        detail: json['detail'],
        userId: json['userId'],
        answerId: json['answerId'],
      );
}
