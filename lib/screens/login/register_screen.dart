import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:sff/widgets/display_error.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: Center(
        child: IntrinsicHeight(
          child: Form(
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
                            labelText: "Username",
                          ),
                          autofillHints: const [AutofillHints.newUsername],
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please provide a username";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                          ),
                          autofillHints: const [AutofillHints.newPassword],
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please provide a password";
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
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
