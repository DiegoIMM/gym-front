class ContactFormDTO {
  String name;
  String email;
  String subject;
  String message;

  ContactFormDTO(
      {required this.name,
      required this.email,
      required this.subject,
      required this.message});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
      };

  factory ContactFormDTO.fromJson(Map<String, dynamic> json) => ContactFormDTO(
        name: json['name'],
        email: json['email'],
        subject: json['subject'],
        message: json['message'],
      );
}
