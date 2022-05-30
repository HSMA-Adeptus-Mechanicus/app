import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({Key? key, required this.body, this.settingsButton = true})
      : super(key: key);

  final Widget body;
  final bool settingsButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        settingsButton: settingsButton,
      ),
      body: body,
    );
  }
}
