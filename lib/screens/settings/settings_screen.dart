import 'package:app/widgets/app_scaffold.dart';
import 'package:app/widgets/login_info.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      settingsButton: false,
      body: Center(
        child: LoginInfo(),
      ),
    );
  }
}
