import 'package:flutter/material.dart';
import 'pages/screen_move_page.dart';
import 'package:camera/camera.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Flutter 엔진과 위젯 트리의 초기화를 보장합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // 사용 가능한 카메라 리스트를 비동기로 가져옵니다.
  final cameras = await availableCameras();
  // 가져온 카메라 리스트에서 첫 번째 카메라를 선택합니다.
  final firstCamera = cameras.first;

  // await dotenv.load(fileName: ".env");
  runApp(MyApp(firstCamera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription firstCamera;
  const MyApp({Key? key, required this.firstCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Navigation Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(builder: (context) {
          // MyApp에서 FirstPage로 값 전달
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => screenMovePage(firstCamera: firstCamera),
              ),
            );
          });
          return Container(); // 빈 컨테이너로 초기 화면 설정
        }));
  }
}
