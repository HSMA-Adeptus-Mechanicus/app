import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/widgets/display_error.dart';

class EditUsernameDialog extends StatefulWidget {
  const EditUsernameDialog({super.key});

  @override
  State<EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<EditUsernameDialog> {
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  _EditUsernameDialogState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit username"),
      content: Form(
        child: AutofillGroup(
          child: IntrinsicHeight(
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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  autofillHints: const [AutofillHints.password],
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            displayError(() async {
              await UserAuthentication.getInstance().editUsername(
                _passwordController.text,
                _usernameController.text,
              );
            });
          },
          child: const Text("Edit username"),
        ),
      ],
    );
  }
}
