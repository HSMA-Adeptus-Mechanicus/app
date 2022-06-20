import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/settings/edit_username.dart';
import 'package:sff/widgets/settings/password_confirm.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Provides information about the login status, like time until the session expires (and maybe more in the future), and a logout button
class LoginInfo extends StatelessWidget {
  const LoginInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? expirationTime =
        UserAuthentication.getInstance().expirationTime?.toLocal();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
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
                        stream: UserAuthentication.getInstance()
                            .getUsernameStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? "-",
                              style: Theme.of(context).textTheme.titleLarge,
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
                          return const EditUsernameDialog();
                        },
                      );
                    },
                    color: Theme.of(context).colorScheme.primary,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              Text(
                UserAuthentication.getInstance().userId ?? "-",
              ),
              Text(
                "Session expires at: ${expirationTime != null ? DateFormat("H:m:s MMM d yyyy").format(expirationTime) : "unknown"}",
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      UserAuthentication.getInstance().logout();
                    },
                    child: const Text("Logout"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return PasswordConfirm(
                            action: "Delete Account",
                            callback: (password) async {
                              displayError(() async {
                                await UserAuthentication.getInstance()
                                    .deleteAccount(password);
                              });
                            },
                          );
                        },
                      );
                    },
                    child: const Text("Delete Account"),
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
