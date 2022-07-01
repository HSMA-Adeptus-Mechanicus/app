import 'package:flutter/material.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/project_selection.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/loading.dart';
import 'package:sff/widgets/pages/equip/apply_reset_options.dart';
import 'package:sff/widgets/pages/equip/avatar_selection.dart';

class SetupAvatarScreen extends StatelessWidget {
  const SetupAvatarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: FutureBuilder<UserAndAvatar>(
        future: data.getCurrentUser().then((value) => first(value.getStreamWithAvatar())),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!.user;
            Avatar userAvatar = snapshot.data!.avatar;
            EditableAvatar avatar = EditableAvatar(userAvatar.equippedItems);
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text("Passe hier noch Deinen Avatar an."),
                ),
                Expanded(
                  child: StreamBuilder<Avatar>(
                      stream: avatar.getStream(),
                      builder: (context, snapshot) {
                        return AvatarWidget(
                          avatar: avatar,
                        );
                      }),
                ),
                Expanded(
                  child: AvatarSelection(avatar: avatar),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: ElevatedButton(
                    onPressed: () async {
                      await showSavingDialog(user.applyAvatar(avatar));
                      navigateTopLevelToWidget(const ProjectSelection());
                    },
                    child: const Text("Fertig!"),
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          return const LoadingWidget(message: "Avatar wird geladen...");
        },
      ),
    );
  }
}
