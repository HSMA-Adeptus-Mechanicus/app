import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/login/setup_avatar_screen.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:sff/widgets/display_error.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: StreamBuilder<LoginState>(
        stream: UserAuthentication.getInstance().getStateStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final state = snapshot.data!;
            if (state == LoginState.loggedIn) {
              Future.microtask(() {
                navigateTopLevelToWidget(const SetupAvatarScreen());
              });
              return const SizedBox.shrink();
            }
            if (state == LoginState.loggedOut) {
              return const RegisterForm();
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicHeight(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text("Hallo! Bevor es richtig losgeht, verrate uns deinen Namen und passe deinen Avatar an."),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Benutzername",
                            ),
                            autofillHints: const [AutofillHints.newUsername],
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bitte Benutzername eingeben";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Passwort",
                            ),
                            autofillHints: const [AutofillHints.newPassword],
                            obscureText: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Bitte Passwort eingeben";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          displayError(() async {
                            await UserAuthentication.getInstance().register(
                              _usernameController.text,
                              _passwordController.text,
                            );
                          });
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
