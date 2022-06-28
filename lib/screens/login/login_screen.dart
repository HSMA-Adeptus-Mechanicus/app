import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/project_selection.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget with WidgetsBindingObserver {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      UserAuthentication.getInstance().completeAuthentication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: StreamBuilder<LoginState>(
        stream: UserAuthentication.getInstance().getStateStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            LoginState state = snapshot.data!;
            if (state == LoginState.loggedIn) {
              Future.microtask(() {
                navigateTopLevelToWidget(const ProjectSelection());
              });
              return const Center(child: CircularProgressIndicator());
            } else if (state == LoginState.loggedOut) {
              return const LoginWidget();
            } else if (state == LoginState.loggingIn) {
              return Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        UserAuthentication.getInstance()
                            .completeAuthentication();
                      },
                      child: const Text("Finish"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        UserAuthentication.getInstance().cancelAuthentication();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          child: const Text("Login with Jira"),
          onPressed: () async {
            String token =
                UserAuthentication.getInstance().startAuthentication();
            const scopes = [
              "read:jira-work",
              "read:jira-user",
              "read:sprint:jira-software",
              "read:issue-details:jira",
              "read:jql:jira",
            ];

            await launchUrl(
              Uri.parse(
                  "https://auth.atlassian.com/authorize?audience=api.atlassian.com&client_id=XlvwG0C178rgOFlgQYhy5dxmgn6Lxu1p&scope=${scopes.join(" ")}&redirect_uri=https%3A%2F%2Fsffj-api.azurewebsites.net%2Fapi%2Fjira-auth&state=${Uri.encodeComponent(token)}&response_type=code&prompt=consent"),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ),
    );
  }
}
