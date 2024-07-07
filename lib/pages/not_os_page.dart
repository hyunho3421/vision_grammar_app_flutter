import 'package:flutter/material.dart';
import '../widgets/base_app_bar.dart';
import '../widgets/back_block_pop_scope.dart';

class NotOsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackBlockPopScope(
      child: Scaffold(
        appBar: BaseAppBar(title: 'Unsupported os Page'),
        body: Center(
          child: Text(
            'Unsupported os',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
