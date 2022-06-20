import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:flutter/material.dart';
import 'package:sff/screens/pages/bossfight_screen.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/border_card.dart';
import 'package:sff/widgets/button_tab_bar.dart';
import 'package:sff/widgets/fitted_text.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: const [
          ButtonTabBar(
            tabs: [
              Tab(child: FittedText("Bossfight")),
              Tab(child: FittedText("Teamübersicht")),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Bossfight(),
                Team(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Team extends StatelessWidget {
  const Team({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: data.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data!;
          return GridView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return UserItem(users[index]);
            },
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem(this._user, {Key? key}) : super(key: key);

  final User _user;

  @override
  Widget build(BuildContext context) {
    return BorderCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(_user.name),
              ),
            ),
            Expanded(
              child: Center(
                child: AvatarWidget(avatar: _user.avatar),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
