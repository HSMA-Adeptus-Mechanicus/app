import 'package:sff/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

/// Provides a scaffold including the app bar
class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {Key? key,
      required this.body,
      this.settingsButton = true,
      this.bottomNavigationBar})
      : super(key: key);

  final Widget body;
  final bool settingsButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        settingsButton: settingsButton,
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.7, -0.4),
              end: Alignment(1, 0.8),
              colors: [
                Color.fromARGB(255, 140, 5, 246),
                Color.fromARGB(255, 1, 30, 184),
              ],
            ),
          ),
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
