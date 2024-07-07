import 'package:flutter/material.dart';
import 'package:vision_grammer_app_flutter/model/apiResponse.dart';
import 'package:flutter/services.dart';

import '../widgets/base_app_bar.dart';
import '../widgets/back_block_pop_scope.dart';
import '../api/visionGrammarApiService.dart' as VISION;
import '../constants/apiConstants.dart';
import '../constants/grantConstants.dart';
import '../constants/secureStorageConstants.dart';
import '../common/secureStorageService.dart' as STORAGE;

import '../pages/not_permission_page.dart';
import 'not_os_page.dart';
import '../pages/loading.dart';

class notExistPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final VISION.visionGrammarApiService _vision =
      VISION.visionGrammarApiService();
  final STORAGE.secureStorageservice _storage = STORAGE.secureStorageservice();

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("alert"),
          content: Text(message),
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

  void registButton(BuildContext context, String textToSend) {
    String textToSend = _controller.text;

    if (textToSend == null || textToSend.length < 3) {
      _showDialog(context, 'Name must be at least 3 characters');
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return loading();
        },
      );

      Future<ApiResponse> apiResponse = _vision.registUser(textToSend);

      apiResponse.then((response) => {
            if (response.result == apiConstants.RES_NOT_AVAILABLE_OS)
              {
                _storage.delete(Securestorageconstants.GRANT),
                _storage.write(
                    Securestorageconstants.GRANT, grantConstants.NOT_OS),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotOsPage(),
                  ),
                ),
              }
            else if (response.result == apiConstants.RES_SERVER_ERROR)
              {
                Navigator.pop(context),
                _showDialog(context, 'Server Error, Please try again later'),
              }
            else if (response.result == apiConstants.RES_SUCCESS_RESIT)
              {
                _storage.delete(Securestorageconstants.GRANT),
                _storage.delete(Securestorageconstants.NAME),
                _storage.write(
                    Securestorageconstants.GRANT, grantConstants.NO_PERMISSION),
                _storage.write(Securestorageconstants.NAME, textToSend),
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => notPermissionPage(name: textToSend),
                  ),
                )
              }
            else if (response.result == apiConstants.RES_EXIST_USER)
              {
                Navigator.pop(context),
                _showDialog(context, 'already exist user'),
                _storage.delete(Securestorageconstants.GRANT),
                _storage.delete(Securestorageconstants.NAME),
                _storage.write(
                    Securestorageconstants.GRANT, grantConstants.NO_PERMISSION),
                _storage.write(Securestorageconstants.NAME, textToSend),
              }
            else
              {Navigator.pop(context), _showDialog(context, 'error - 100')}
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackBlockPopScope(
        child: Scaffold(
      appBar: BaseAppBar(title: "Request Permission"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Please write name in english",
              style: TextStyle(
                fontSize: 24, // 폰트 크기 지정
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                    controller: _controller,
                    inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'name',
                    ),
                  )),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                child: Text(
                  'request',
                  style: TextStyle(
                      fontSize: 24, // 폰트 크기 지정
                      color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue,
                  ),
                ),
                onPressed: () {
                  String textToSend = _controller.text;
                  registButton(context, textToSend);
                }),
          ],
        ),
      ),
    ));
  }
}
