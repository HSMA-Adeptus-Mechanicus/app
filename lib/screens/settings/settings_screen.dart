import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/fitted_text.dart';
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
          // const Spacer(flex: 1),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<String?>(
                    stream: ProjectManager.getStream()
                        .map((event) => event.currentProject?.name),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Aktuelles Projekt:",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            FittedText(snapshot.data!),
                          ],
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      (ProjectManager.getInstance())
                          .then((value) => value.currentProject = null);
                      Navigator.pop(context);
                    },
                    child: const Text("Projekt wechseln"),
                  ),
                  const Spacer(flex: 5),
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
          ),
        ],
      ),
    );
  }
}
