import 'package:vision_grammer_app_flutter/model/grammar.dart';

import '../model/apiResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/user.dart';
import '../constants/apiConstants.dart';
import '../common/deviceInfoService.dart' as DEVICE;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/visionResponse.dart';
import '../constants/visionConstants.dart';

class visionGrammarApiService {
  final DEVICE.deviceInfoService _device = DEVICE.deviceInfoService();

  final _googleApiKey = "";
  static const String _firestoreUrl = "https://vision-427210.as.r.appspot.com";
  static const String _visionUrl =
      "https://vision.googleapis.com/v1/images:annotate?key=";

  Future<ApiResponse> checkDevice() async {
    try {
      Future<String> deviceId = _device.getDeviceId();
      User? user = User.checkDevice(await deviceId);

      final response = await http.post(
          Uri.parse(_firestoreUrl + apiConstants.REQ_CHECK),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(user));

      if (response.statusCode == 200) {
        return ApiResponse.fromGrantJson(json.decode(response.body));
      } else {
        return ApiResponse(
            result: apiConstants.RES_SERVER_ERROR,
            grant: false,
            message: "",
            name: "");
      }
    } catch (error) {
      print("error is ${error}");
      return ApiResponse(
          result: apiConstants.RES_SERVER_ERROR,
          grant: false,
          message: "",
          name: "");
    }
  }

  Future<ApiResponse> registUser(String name) async {
    User? user = await _device.firstApp(name);

    if (user == null) {
      // ios등 다른 os
      return ApiResponse(
          result: apiConstants.RES_NOT_AVAILABLE_OS,
          grant: false,
          message: "",
          name: "");
    }

    try {
      final response = await http.post(
          Uri.parse(_firestoreUrl + apiConstants.REQ_REGIST),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(user));

      if (response.statusCode == 200) {
        return ApiResponse.fromGrantJson(json.decode(response.body));
      } else {
        return ApiResponse(
            result: apiConstants.RES_SERVER_ERROR,
            grant: false,
            message: "",
            name: "");
      }
    } catch (e) {
      return ApiResponse(
          result: apiConstants.RES_SERVER_ERROR,
          grant: false,
          message: "",
          name: "");
    }
  }

  Future<ApiResponse> checkGrammar(String text) async {
    String deviceId = await _device.getDeviceId();
    Grammar grammar = Grammar(deviceId: deviceId, questionText: text);

    try {
      final response = await http.post(
          Uri.parse(_firestoreUrl + apiConstants.REQ_GRAMMAR),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(grammar));

      if (response.statusCode == 200) {
        return ApiResponse.fromGrammarJson(json.decode(response.body));
      } else {
        return ApiResponse(
            result: apiConstants.RES_SERVER_ERROR,
            grant: false,
            message: "",
            name: "");
      }
    } catch (e) {
      return ApiResponse(
          result: apiConstants.RES_SERVER_ERROR,
          grant: false,
          message: "",
          name: "");
    }
  }

  Future<VisionResponse> analyzeImage(String base64Image) async {
    VisionResponse visionResponse;
    try {
      final response = await http.post(
        Uri.parse(_visionUrl + _googleApiKey),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'requests': [
            {
              'image': {
                'content': base64Image,
              },
              'features': [
                {
                  'type': 'TEXT_DETECTION',
                },
              ],
            },
          ],
        }),
      );

      final decodedResponse = jsonDecode(response.body);

      visionResponse = VisionResponse.fromJson(decodedResponse);
    } catch (error) {
      visionResponse =
          VisionResponse(text: "", result: visionConstants.RES_ERROR);
    }

    return visionResponse;
  }
}
