class VoteAnswerDTO {
  int userId;
  int answerId;

  VoteAnswerDTO({required this.userId, required this.answerId});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'answerId': answerId,
      };

  factory VoteAnswerDTO.fromJson(Map<String, dynamic> json) => VoteAnswerDTO(
        userId: json['userId'],
        answerId: json['answerId'],
      );
}
