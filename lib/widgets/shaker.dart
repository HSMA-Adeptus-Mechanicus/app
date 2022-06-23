import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';

import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';

class TestAnimWidget extends StatefulWidget {
  const TestAnimWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestAnimWidgetState();
}

class _TestAnimWidgetState extends State<TestAnimWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 15.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {});

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<User>(
          stream: data.getUsersStream().map((event) => event.firstWhere(
              (user) => user.id == UserAuthentication.getInstance().userId)),
          builder: (context, snapshot) {
            if ((snapshot.data?.currency ?? 0) > 14) {
              controller.forward(from: 25.0);
              controller.repeat();
            } else {
              controller.reset();
            }
            return AnimatedBuilder(
              animation: offsetAnimation,
              builder: (buildContext, child) {
                return Container(
                  padding: EdgeInsets.only(
                    // left: offsetAnimation.value + 24.0,
                    // right: 24.0 - offsetAnimation.value,
                    bottom: offsetAnimation.value + 24.0,
                    top: 24.0 - offsetAnimation.value,
                  ),
                  child: Image.asset(
                    "assets/icons/Pixel/Schatzkiste1.png",
                    filterQuality: FilterQuality.none,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
