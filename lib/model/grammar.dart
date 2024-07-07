class Grammar {
  String deviceId;
  String questionText;

  Grammar({
    required this.deviceId,
    required this.questionText,
  });

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      deviceId: json['deviceId'],
      questionText: json['questionText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'questionText': questionText,
    };
  }
}
