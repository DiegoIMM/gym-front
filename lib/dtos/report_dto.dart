class ReportDTO {
  int userId;
  int questionId;
  String reason;

  ReportDTO(
      {required this.userId, required this.questionId, required this.reason});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'questionId': questionId,
        'reason': reason,
      };

  factory ReportDTO.fromJson(Map<String, dynamic> json) => ReportDTO(
        userId: json['userId'],
        questionId: json['questionId'],
        reason: json['reason'],
      );
}
