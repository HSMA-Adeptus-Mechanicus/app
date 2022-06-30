import 'package:flutter/material.dart';

class Shaker extends StatefulWidget {
  const Shaker({
    Key? key,
    required this.child,
    required this.shake,
    this.animationDuration = const Duration(milliseconds: 400),
  }) : super(key: key);

  final Duration animationDuration;
  final Widget child;
  final bool shake;

  @override
  State<StatefulWidget> createState() => _ShakerState();
}

class _ShakerState extends State<Shaker> with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 9.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {});

    if (widget.shake) controller.repeat(reverse: true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: offsetAnimation,
          builder: (buildContext, child) {
            return Container(
              padding: EdgeInsets.only(
                // left: offsetAnimation.value + 24.0,
                // right: 24.0 - offsetAnimation.value,
                bottom: offsetAnimation.value + 9,
                top: 9 - offsetAnimation.value,
              ),
              child: widget.child,
            );
          },
        ),
      ],
    );
  }
}
