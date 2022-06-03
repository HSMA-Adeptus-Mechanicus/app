import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/password_confirm.dart';
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
    return Center(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Text("Logged in as ${UserAuthentication.getInstance().username}"),
            Text(
                "Session expires at: ${expirationTime != null ? DateFormat("H:m:s MMM d yyyy").format(expirationTime) : "unknown"}"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                UserAuthentication.getInstance().logout();
              },
              child: const Text("Logout"),
            ),
            const SizedBox(
              height: 10,
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
      ),
    );
  }
}
