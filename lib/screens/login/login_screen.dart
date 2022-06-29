import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/login/setup_avatar_screen.dart';
import 'package:sff/screens/project_selection.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
              Future.microtask(() async {
                User user = await data.getCurrentUser();
                if (user.avatarSetup) {
                  navigateTopLevelToWidget(const ProjectSelection());
                } else {
                  navigateTopLevelToWidget(const SetupAvatarScreen());
                }
              });
              return const Center(child: CircularProgressIndicator());
            } else if (state == LoginState.loggedOut) {
              return const LoginWidget();
            } else if (state == LoginState.loggingIn) {
              return const LoginExternal();
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class LoginExternal extends StatefulWidget {
  const LoginExternal({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginExternal> createState() => _LoginExternalState();
}

class _LoginExternalState extends State<LoginExternal>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      UserAuthentication.getInstance().completeAuthentication();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
              "Logge dich durch den Browser in Jira ein. Wenn du dich eingeloggt hast und es nicht weiter geht tippe auf 'Weiter'."),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              UserAuthentication.getInstance().completeAuthentication();
            },
            child: const Text("Weiter"),
          ),
          OutlinedButton(
            onPressed: () {
              UserAuthentication.getInstance().cancelAuthentication();
            },
            child: const Text("Abbrechen"),
          ),
        ],
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Logge dich mit Jira ein um anzufangen."),
          const SizedBox(height: 30),
          ElevatedButton(
            child: const Text("Login mit Jira"),
            onPressed: () async {
              String token =
                  UserAuthentication.getInstance().startAuthentication();
              const scopes = [
                "offline_access",
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
        ],
      ),
    );
  }
}
