import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/widgets/display_error.dart';

class EditUsernameDialog extends StatefulWidget {
  const EditUsernameDialog({super.key});

  @override
  State<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  _EditUsernameDialogState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Benutzernamen ändern"),
      content: Form(
        key: _formKey,
        child: AutofillGroup(
          child: IntrinsicHeight(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Neuer Benutzername",
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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Passwort",
                  ),
                  autofillHints: const [AutofillHints.password],
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Abbrechen"),
        ),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.pop(context);
            displayError(() async {
              await UserAuthentication.getInstance().editUsername(
                _passwordController.text,
                _usernameController.text,
              );
            });
          },
          child: const Text("Benutzername ändern"),
        ),
      ],
    );
  }
}
