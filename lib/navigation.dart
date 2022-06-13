import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

navigateTopLevelToWidget(Widget destination) async {
  await Navigator.pushAndRemoveUntil(
    navigatorKey.currentContext!,
    MaterialPageRoute(builder: (context) => destination),
    (route) => false,
  );
}
