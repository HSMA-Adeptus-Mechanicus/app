import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/settings/login_info.dart';
import 'package:flutter/material.dart';
import 'package:sff/widgets/settings/password_confirm.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: Column(
        children: [
          const LoginInfo(),
          const SizedBox(height: 50),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.copyWith(
                  titleMedium: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontSize: 20),
                  bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withAlpha(150)),
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SwitchListTile(
                    value: false,
                    title: const Text("Benachrichtigungston"),
                    subtitle: const Text("Standardklingelton"),
                    onChanged: (value) {},
                  ),
                  SwitchListTile(
                    value: false,
                    title: const Text("Vibration"),
                    subtitle: const Text("Standard"),
                    onChanged: (value) {},
                  ),
                  SwitchListTile(
                    value: false,
                    title: const Text("Push-up-Nachrichten"),
                    subtitle: const Text("immer anzeigen"),
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                        return PasswordConfirm(
                          action: "Account löschen",
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
