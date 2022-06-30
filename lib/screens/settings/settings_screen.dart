import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/settings/login_info.dart';
import 'package:flutter/material.dart';
import 'package:sff/widgets/settings/confirm_delete.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Spacer(flex: 1),
          const LoginInfo(),
          const Spacer(flex: 6),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: () {
                    ProjectManager.getInstance().currentProject = null;
                    Navigator.pop(context);
                  },
                  child: const Text("Projekt wechseln"),
                ),
                OutlinedButton(
                  onPressed: () {
                    UserAuthentication.getInstance().logout();
                  },
                  child: const Text("Logout"),
                ),
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return Confirm(
                          callback: () async {
                            displayError(() async {
                              await UserAuthentication.getInstance()
                                  .deleteAccount();
                            });
                          },
                        );
                      },
                    );
                  },
                  child: const Text("Account löschen"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
