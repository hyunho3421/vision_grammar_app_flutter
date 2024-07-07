import 'package:flutter/material.dart';
import '../widgets/base_app_bar.dart';
import '../widgets/back_block_pop_scope.dart';

class notPermissionPage extends StatelessWidget {
  final String name;
  notPermissionPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackBlockPopScope(
      child: Scaffold(
        appBar: BaseAppBar(title: 'Permission denied (${name})'),
        body: Center(
          child: Text(
            'Waiting for Permission Request',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
