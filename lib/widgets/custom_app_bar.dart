import 'package:app/screens/settings_screen.dart';
import 'package:flutter/material.dart';

final Size prefSize = AppBar().preferredSize;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => prefSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
          IconButton(
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
          ),
        ],
      title: const Text("Scrum for Fun"),
    );
  }
}
