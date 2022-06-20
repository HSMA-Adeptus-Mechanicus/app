import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/button_tab_bar.dart';
import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/fitted_text.dart';
import 'package:sff/widgets/pages/avatar_selection.dart';
import 'package:sff/widgets/pages/equipment_selection.dart';


// TODO: ask user what to do when switching to another tab if there are not applied changes

class EquipScreen extends StatelessWidget {
  const EquipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: first(data.getUsersStream()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Avatar userAvatar = snapshot.data!
              .firstWhere((element) =>
                  element.id == UserAuthentication.getInstance().userId)
              .avatar;
          EditableAvatar avatar = EditableAvatar(userAvatar.equippedItems);
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const ButtonTabBar(
                  tabs: [
                    Tab(child: FittedText("Garderobe")),
                    Tab(child: FittedText("Avatar")),
                  ],
                ),
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: StreamBuilder<Avatar>(
                        stream: avatar.getStream(),
                        builder: (context, snapshot) {
                          return AvatarWidget(
                            avatar: avatar,
                          );
                        },
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        // TODO: show loading indicator while applying (also in setup_avatar_screen)
                        displayError(() async {
                          await avatar.applyToCurrentUser();
                        });
                      },
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      EquipmentSelection(avatar: avatar),
                      AvatarSelection(avatar: avatar),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
