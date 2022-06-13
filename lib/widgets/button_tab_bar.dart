import 'package:flutter/material.dart';

class ButtonTabBar extends StatelessWidget {
  final List<Widget> tabs;

  const ButtonTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      padding: const EdgeInsets.all(20),
      indicatorPadding: const EdgeInsets.all(5),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).colorScheme.primary,
      ),
      labelColor: Theme.of(context).colorScheme.onPrimary,
      unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
