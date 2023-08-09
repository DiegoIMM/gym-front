class VoteQuestionDTO {
  int userId;
  int questionId;

  VoteQuestionDTO({required this.userId, required this.questionId});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'questionId': questionId,
      };

  factory VoteQuestionDTO.fromJson(Map<String, dynamic> json) =>
      VoteQuestionDTO(
        userId: json['userId'],
        questionId: json['questionId'],
      );
}
