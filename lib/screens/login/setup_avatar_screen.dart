import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/app_frame.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/pages/avatar_selection.dart';

class SetupAvatarScreen extends StatelessWidget {
  const SetupAvatarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: Column(
        children: [
          Expanded(
            child: UserAvatarWidget(
              userId: UserAuthentication.getInstance().userId!,
            ),
          ),
          const Expanded(
            child: AvatarSelection(),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () {
                navigateTopLevelToWidget(const AppFrame());
              },
              child: const Text("Fertig!"),
            ),
          ),
        ],
      ),
    );
  }
}
