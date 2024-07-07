class ApiResponse {
  final String result;
  final bool grant;
  final String message;
  final String name;

  ApiResponse(
      {required this.result,
      required this.grant,
      required this.message,
      required this.name});

  factory ApiResponse.fromGrantJson(Map<String, dynamic> json) {
    return ApiResponse(
        result: json['result'],
        grant: json['grant'],
        message: "",
        name: json['name']);
  }

  factory ApiResponse.fromGrammarJson(Map<String, dynamic> json) {
    return ApiResponse(
        result: json['result'],
        grant: json['grant'],
        message: json['message'],
        name: "");
  }

  Map<String, dynamic> toJson() {
    return {"result": result, "grant": grant, "message": message, "name": name};
  }
}
