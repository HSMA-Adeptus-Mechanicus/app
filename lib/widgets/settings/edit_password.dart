import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/widgets/display_error.dart';

class EditPasswordDialog extends StatefulWidget {
  const EditPasswordDialog({super.key});

  @override
  State<EditPasswordDialog> createState() => _EditPasswordDialogState();
}

class _EditPasswordDialogState extends State<EditPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _oldPasswordController = TextEditingController();

  _EditPasswordDialogState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Passwort ändern"),
      content: Form(
        key: _formKey,
        child: AutofillGroup(
          child: IntrinsicHeight(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Altes Passwort",
                  ),
                  autofillHints: const [AutofillHints.password],
                  obscureText: true,
                  controller: _oldPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte altes Passwort eingeben";
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
                    labelText: "Neues Passwort",
                  ),
                  autofillHints: const [AutofillHints.newPassword],
                  obscureText: true,
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte neues Passwort eingeben";
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
              await UserAuthentication.getInstance().editPassword(
                _oldPasswordController.text,
                _newPasswordController.text,
              );
            });
          },
          child: const Text("Passwort ändern"),
        ),
      ],
    );
  }
}
