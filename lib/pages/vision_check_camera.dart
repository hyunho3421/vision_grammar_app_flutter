import 'package:flutter/material.dart';
import 'package:vision_grammer_app_flutter/constants/grantConstants.dart';
import 'package:vision_grammer_app_flutter/constants/visionConstants.dart';
import '../widgets/base_app_bar.dart';
import '../widgets/back_block_pop_scope.dart';
import 'package:camera/camera.dart';

import 'dart:async';
import 'dart:convert';
import '../api/visionGrammarApiService.dart' as VISION;
import '../common/correctGrammarService.dart' as GRAMMAR;
import '../model/visionResponse.dart';
import '../model/apiResponse.dart';
import '../constants/apiConstants.dart';
import '../pages/not_permission_page.dart';
import '../pages/not_exist_page.dart';
import '../common/secureStorageService.dart' as STORAGE;

class visionCheckCamera extends StatefulWidget {
  final CameraDescription firstCamera;
  final String name;
  visionCheckCamera({Key? key, required this.firstCamera, required this.name})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<visionCheckCamera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isTakingPicture = false;

  final VISION.visionGrammarApiService _apiService =
      VISION.visionGrammarApiService();
  final GRAMMAR.correctGrammarService _grammarService =
      GRAMMAR.correctGrammarService();
  final STORAGE.secureStorageservice _storage = STORAGE.secureStorageservice();

  void _showDialog(
      BuildContext context, String correctSentences, Duration difference) {
    String pattern = r'[1-5][번]';
    RegExp regExp = RegExp(pattern);
    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in regExp.allMatches(correctSentences)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: correctSentences.substring(currentIndex, match.start),
          style: TextStyle(color: Colors.black),
        ));
      }
      spans.add(TextSpan(
        text: match.group(0),
        style: TextStyle(fontSize: 24, color: Colors.red),
      ));
      currentIndex = match.end;
    }

    if (currentIndex < correctSentences.length) {
      spans.add(TextSpan(
        text: correctSentences.substring(currentIndex),
        style: TextStyle(fontSize: 24, color: Colors.black),
      ));
    }

    spans.add(TextSpan(
      text:
          '\n (duration : ${difference.inSeconds}.${difference.inMilliseconds % 1000}초)', // 번호와 문자를 개행
      style: TextStyle(color: Colors.black),
    ));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Correct Sentences'),
          content: RichText(
            text: TextSpan(children: spans),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(
            content,
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = screenWidth * 0.2; // 화면 너비의 20%

    return BackBlockPopScope(
      child: Scaffold(
        appBar: BaseAppBar(title: 'Take a Picture (${widget.name})'),
        body: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            if (_isTakingPicture)
              Container(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
                ),
              ),
          ],
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: SizedBox(
                width: screenWidth * 0.6,
                height: buttonSize,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (_isTakingPicture) return;

                    setState(() {
                      _isTakingPicture = true;
                    });

                    try {
                      await _initializeControllerFuture;

                      DateTime sDate = DateTime.now();
                      // Duration difference = secondTime.difference(firstTime);

                      final image = await _controller.takePicture();

                      final bytes = await image.readAsBytes();
                      final base64String = base64Encode(bytes);

                      VisionResponse visionResponse =
                          await _apiService.analyzeImage(base64String);

                      if (visionResponse.result == visionConstants.RES_ERROR) {
                        // 다시찍도록 팝업
                        _showErrorDialog(context, "server error",
                            "try again take a picture");

                        setState(() {
                          _isTakingPicture = false;
                        });
                      } else if (visionResponse.text == "") {
                        // 다시찍도록 팝업
                        _showErrorDialog(context, "camera error",
                            "try again take a picture");

                        setState(() {
                          _isTakingPicture = false;
                        });
                      } else {
                        String fullSentences = visionResponse.text;
                        String extractSentences =
                            _grammarService.getExtractSentences(fullSentences);

                        ApiResponse apiResponse =
                            await _apiService.checkGrammar(extractSentences);

                        if (apiResponse.result ==
                            apiConstants.RES_SERVER_ERROR) {
                          // 서버에러
                          _showErrorDialog(context, "server error",
                              "try again take a picture");

                          setState(() {
                            _isTakingPicture = false;
                          });
                        } else if (apiResponse.result ==
                            apiConstants.RES_NOT_GRANT) {
                          // 권한없음
                          _storage.delete("grant");
                          _storage.write("grant", grantConstants.NO_PERMISSION);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  notPermissionPage(name: widget.name),
                            ),
                          );
                        } else if (apiResponse.result ==
                            apiConstants.RES_NOT_EXIST_USER) {
                          _storage.delete("grant");
                          _storage.delete("name");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => notExistPage(),
                            ),
                          );
                        } else {
                          String correctSentences = apiResponse.message;
                          DateTime eDate = DateTime.now();
                          Duration difference = eDate.difference(sDate);

                          _showDialog(context, correctSentences, difference);

                          setState(() {
                            _isTakingPicture = false;
                          });
                        }
                      }
                    } catch (e) {
                      setState(() {
                        _isTakingPicture = false;
                      });
                    }
                  },
                  child: Icon(Icons.camera_alt, size: buttonSize * 0.5),
                ))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
