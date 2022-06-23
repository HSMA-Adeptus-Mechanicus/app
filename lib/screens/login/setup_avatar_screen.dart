import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/app_frame.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/pages/equip/apply_reset_options.dart';
import 'package:sff/widgets/pages/equip/avatar_selection.dart';

class SetupAvatarScreen extends StatelessWidget {
  const SetupAvatarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: FutureBuilder<List<User>>(
        future: first(data.getUsersStream()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Avatar userAvatar = snapshot.data!
                .firstWhere((element) =>
                    element.id == UserAuthentication.getInstance().userId)
                .avatar;
            EditableAvatar avatar = EditableAvatar(userAvatar.equippedItems);
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Text("Passe hier noch deinen Avatar an."),
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
                      await showSavingDialog(avatar.applyToCurrentUser());
                      navigateTopLevelToWidget(const AppFrame());
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
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
