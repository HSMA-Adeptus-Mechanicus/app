import 'package:flutter/material.dart';
import 'package:sff/navigation.dart';

/// Calls a function and shows an error dialog if it throws an exception.
displayError(Future? Function() func) async {
  try {
    await func();
  } catch (e) {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return ErrorDialog(e);
      },
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final Object exception;

  const ErrorDialog(this.exception, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(exception.toString()),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}
