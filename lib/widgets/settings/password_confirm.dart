import 'package:flutter/material.dart';

class PasswordConfirm extends StatefulWidget {
  final String action;
  final void Function(String password) callback;

  const PasswordConfirm(
      {super.key, required this.action, required this.callback});

  @override
  State<PasswordConfirm> createState() => _PasswordConfirmState();
}

class _PasswordConfirmState extends State<PasswordConfirm> {
  final _passwordController = TextEditingController();

  _PasswordConfirmState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter password to confirm"),
      content: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
        ),
        obscureText: true,
        controller: _passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please provide a password";
          }
          return null;
        },
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
            widget.callback(_passwordController.text);
          },
          child: Text(widget.action),
        ),
      ],
    );
  }
}