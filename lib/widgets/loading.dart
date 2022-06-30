import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    String? m = message;
    var textWidgets = m != null
        ? [
            Text(m),
            const SizedBox(height: 30),
          ]
        : [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...textWidgets,
        const CircularProgressIndicator(),
      ],
    );
  }
}
