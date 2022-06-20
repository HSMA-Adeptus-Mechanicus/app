import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  final String text;

  const FittedText(this.text, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(text),
    );
  }
}
