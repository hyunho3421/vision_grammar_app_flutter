import '../constants/visionConstants.dart';

class VisionResponse {
  final String text;
  final String result;

  VisionResponse({required this.text, required this.result});

  factory VisionResponse.fromJson(Map<String, dynamic> json) {
    var text = json['responses'][0]['fullTextAnnotation']['text'];

    return VisionResponse(text: text, result: visionConstants.RES_SUCCESS);
  }
}
