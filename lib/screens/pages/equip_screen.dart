import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/button_tab_bar.dart';
import 'package:sff/widgets/fitted_text.dart';
import 'package:sff/widgets/pages/avatar_selection.dart';
import 'package:sff/widgets/pages/equipment_selection.dart';

class EquipScreen extends StatelessWidget {
  const EquipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: UserAvatarWidget(
                userId: UserAuthentication.getInstance().userId!,
              ),
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                EquipmentSelection(),
                AvatarSelection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
