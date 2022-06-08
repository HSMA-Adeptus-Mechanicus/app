import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/widgets/avatar.dart';
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
          const TabBar(
            tabs: [
              Tab(child: Text("Garderobe")),
              Tab(child: Text("Avatar")),
            ],
          ),
          Expanded(
            child: Center(
              child: StreamBuilder<List<User>>(
                  stream: data.getUsersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<User> users = snapshot.data!;
                      Avatar avatar = users
                          .firstWhere((user) =>
                              user.name ==
                              UserAuthentication.getInstance().username)
                          .avatar;
                      return AvatarWidget(
                        avatar: avatar,
                      );
                    }
                    if (snapshot.hasError) {
                      return ErrorWidget(snapshot.error!);
                    }
                    return const CircularProgressIndicator();
                  }),
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
