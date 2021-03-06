import 'package:flutter/material.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/loading.dart';

class EditNameDialog extends StatefulWidget {
  const EditNameDialog({super.key});

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  _EditNameDialogState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: data.getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingWidget();
        }
        User user = snapshot.data!;
        return AlertDialog(
          title: const Text("Benutzernamen ändern"),
          content: Form(
            key: _formKey,
            child: AutofillGroup(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Aktueller Name: ${user.name}"),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Neuer Name",
                      ),
                      autofillHints: const [AutofillHints.nickname],
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Bitte Namen eingeben";
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
                  await user.changeName(_nameController.text);
                });
              },
              child: const Text("Benutzername ändern"),
            ),
          ],
        );
      },
    );
  }
}
