import 'package:app/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: Center(
        child: Text("Settings Screen"),
      ),
    );
  }
}
