import 'package:sff/data/data.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/settings/edit_name.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:flutter/material.dart';

/// Provides information about the login status, like time until the session expires (and maybe more in the future), and a logout button
class LoginInfo extends StatelessWidget {
  const LoginInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: UserAvatarWidget(
            userId: UserAuthentication.getInstance().userId!,
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: StreamBuilder<String?>(
                        stream: data.getCurrentUserStream().map((user) => user.name),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? "-",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const EditNameDialog();
                        },
                      );
                    },
                    color: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
