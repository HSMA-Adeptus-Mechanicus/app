import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  final void Function() callback;

  const Confirm(
      {super.key, required this.callback});

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {

  _ConfirmState();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Account löschen"),
      content: const Text("Wenn Du Deinen Account löschst, verlierst Du jeglichen Fortschritt in Scrum for Fun."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Abbrechen"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.callback();
          },
          child: const Text("Account löschen"),
        ),
      ],
    );
  }
}
