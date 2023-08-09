

class User {
  int id;
  String name;
  String username;
  String email;
  bool validatedEmail;
  bool validatedProfession;
  int countAnswers;
  int countQuestions;
  int countQuestionsUpVotes;
  int countQuestionsDownVotes;
  int countMyAnswersUpVotes;
  int countMyAnswersAccepted;
  String? profilePicture;
  String? biography;
  DateTime createdAt;
  DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.validatedEmail,
    required this.validatedProfession,
    required this.countAnswers,
    required this.countQuestions,
    required this.countQuestionsUpVotes,
    required this.countQuestionsDownVotes,
    required this.countMyAnswersUpVotes,
    required this.countMyAnswersAccepted,
    required this.profilePicture,
    required this.biography,
    required this.createdAt,
    required this.updatedAt,
  });

// crear un usuario desde un json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      validatedEmail: json['validated_email'],
      validatedProfession: json['validated_profession'],
      countAnswers: json['count_answers'],
      countQuestions: json['count_questions'],
      countQuestionsUpVotes: json['count_questions_up_votes'],
      countQuestionsDownVotes: json['count_questions_down_votes'],
      countMyAnswersUpVotes: json['count_my_answers_up_votes'],
      countMyAnswersAccepted: json['count_my_answers_accepted'],
      profilePicture: json['profile_picture'],
      biography: json['biography'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

//   exportar un json desde un usuario
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'validated_email': validatedEmail,
      'validated_profession': validatedProfession,
      'count_answers': countAnswers,
      'count_questions': countQuestions,
      'count_questions_up_votes': countQuestionsUpVotes,
      'count_questions_down_votes': countQuestionsDownVotes,
      'count_my_answers_up_votes': countMyAnswersUpVotes,
      'count_my_answers_accepted': countMyAnswersAccepted,
      'profile_picture': profilePicture,
      'biography': biography,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // String getStringCreateDateFromNow() {
  //   return Moment(createdAt, localization: LocalizationEsEs()).fromNow();
  // }



  String getProfilePicture() {
    return profilePicture ??
        'https://firebasestorage.googleapis.com/v0/b/stacklawyers-352318.appspot.com/o/profilePicture%2FdefaultProfilePicture.jpeg?alt=media&token=7521ff30-139b-43d1-8133-85f9e378d0c4&_gl=1*tbxbfe*_ga*MTY4NTI0MjE2My4xNjY2NzEyNDYy*_ga_CW55HF8NVT*MTY4NTkzOTAyMS4xNC4xLjE2ODU5NDA1MzMuMC4wLjA.';
  }
}
