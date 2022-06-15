import 'package:flutter/material.dart';

class BorderCard extends StatelessWidget {
  final Color? color;
  final Widget child;

  const BorderCard({super.key, this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        color: color ?? Theme.of(context).cardColor,
      ),
      child: child,
    );
  }
}
