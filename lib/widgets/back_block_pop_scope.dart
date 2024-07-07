import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 앱 종료를 위해 추가

class BackBlockPopScope extends StatelessWidget {
  final Widget child;
  DateTime? _lastPressed;

  BackBlockPopScope({required this.child});

  // canPop: false, // 뒤로가기 비활성화

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool popped) {
        DateTime now = DateTime.now();
        if (_lastPressed == null ||
            now.difference(_lastPressed!) > Duration(seconds: 2)) {
          _lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('뒤로가기 버튼을 한 번 더 누르면 종료됩니다.'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
