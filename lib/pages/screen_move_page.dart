import 'package:flutter/material.dart';
import '../widgets/base_app_bar.dart';
import '../widgets/back_block_pop_scope.dart';
import '../constants/grantConstants.dart';
import '../constants/secureStorageConstants.dart';
import '../common/validationService.dart' as Validation;
import '../common/secureStorageService.dart' as STORAGE;

import 'not_exist_page.dart';
import 'not_permission_page.dart';
import 'error_page.dart';
import 'not_os_page.dart';
import 'vision_check_camera.dart';

import 'package:camera/camera.dart';

class screenMovePage extends StatelessWidget {
  final Validation.validationService _validation =
      Validation.validationService();
  final STORAGE.secureStorageservice _storage = STORAGE.secureStorageservice();

  final CameraDescription firstCamera;
  screenMovePage({Key? key, required this.firstCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _validation.checkingDevice().then((val) {
      String? grant = val;

      if (grant == grantConstants.NO_USER) {
        // 유저 등록 화면으로
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => notExistPage(),
          ),
        );
      } else if (grant == grantConstants.NO_PERMISSION) {
        // 유저 대기화면
        _storage.read(Securestorageconstants.NAME).then((val) => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      notPermissionPage(name: val ?? "NO_HAVE"),
                ),
              )
            });
      } else if (grant == grantConstants.NOT_OS) {
        // 지원하지않는 Os
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NotOsPage(),
          ),
        );
      } else if (grant == grantConstants.PERMISSION) {
        // 카메라
        _storage.read(Securestorageconstants.NAME).then((val) => {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => visionCheckCamera(
                      firstCamera: firstCamera, name: val ?? "NO_HAVE"),
                ),
              )
            });
      } else {
        // 에러화면
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => errorPage(),
          ),
        );
      }
    });

    return BackBlockPopScope(
      child: Scaffold(
        appBar: BaseAppBar(title: 'Loading...'),
        body: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
        ),
      ),
    );
  }
}
