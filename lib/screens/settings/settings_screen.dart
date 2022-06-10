import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/settings/login_info.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: Column(
        children: const [
          LoginInfo(),
        ],
      ),
    );
  }
}
