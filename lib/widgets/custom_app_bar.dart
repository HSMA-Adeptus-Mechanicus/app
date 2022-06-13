import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:sff/widgets/avatar.dart';

final Size prefSize = AppBar().preferredSize;

/// The app bar used throughout the app including a title and optional settings button
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, this.settingsButton = true}) : super(key: key);

  final bool settingsButton;

  @override
  Size get preferredSize => prefSize;

  @override
  Widget build(BuildContext context) {
    Widget? button;
    if (settingsButton && UserAuthentication.getInstance().authenticated) {
      button = IconButton(
        padding: EdgeInsets.zero,
        icon: UserAvatarWidget(
          userId: UserAuthentication.getInstance().userId!,
        ),
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
    }

    return AppBar(
      // TODO: adjust look of back button
      title: const Text("Scrum for Fun"),
      actions: button != null ? [button] : null,
    );
  }
}
