import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:flutter/material.dart';


class TeamScreen extends StatelessWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: data.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserItem(users[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 7,
              );
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
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_user.name),
          ],
        ),
      ),
    );
  }
}
