import 'package:flutter/material.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/button_tab_bar.dart';
import 'package:sff/widgets/fitted_text.dart';
import 'package:sff/widgets/pages/equip/apply_reset_options.dart';
import 'package:sff/widgets/pages/equip/avatar_selection.dart';
import 'package:sff/widgets/pages/equip/equipment_selection.dart';

class EquipScreen extends StatelessWidget {
  const EquipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Avatar>(
      future: data.getCurrentUser().then((value) => value.getAvatar()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Avatar userAvatar = snapshot.data!;
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
                  child: Stack(
                    children: [
                      Center(
                        child: StreamBuilder<Avatar>(
                          stream: avatar.getStream(),
                          builder: (context, snapshot) {
                            return AvatarWidget(
                              avatar: avatar,
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ApplyResetOptionsShower(avatar: avatar),
                      ),
                    ],
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
