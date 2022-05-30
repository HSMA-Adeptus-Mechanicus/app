import 'package:app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

final Size prefSize = AppBar().preferredSize;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, this.settingsButton = true}) : super(key: key);

  final bool settingsButton;

  @override
  Size get preferredSize => prefSize;

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
      icon: const Icon(Icons.account_circle),
      onPressed: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return const SettingsScreen();
            },
          ),
        );
      },
    );

    return AppBar(
      actions: settingsButton ? [button] : null,
      title: const Text("Scrum for Fun"),
    );
  }
}
