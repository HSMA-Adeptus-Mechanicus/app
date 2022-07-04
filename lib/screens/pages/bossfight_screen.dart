import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/data/model/sprint.dart';
import 'package:sff/widgets/pages/bossfight/boss.dart';
import 'package:sff/widgets/pages/bossfight/bossfight_team.dart';
import 'package:sff/widgets/pages/bossfight/victory_screen.dart';

class Bossfight extends StatelessWidget {
  const Bossfight({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          const Victory(),
          CustomPaint(
            painter: VersusPainter(),
            child: const Center(
              child: Text(
                "VS",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          StreamBuilder<Sprint>(
            stream: () async* {
              Sprint sprint = await (await ProjectManager.getInstance())
                  .currentProject!
                  .getCurrentSprint();
              yield* sprint.asStream();
            }(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final sprint = snapshot.data!;
                return Stack(
                  children: [
                    Align(
                      alignment: const Alignment(0.8, -0.8),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Sprintanfang ${DateFormat("dd.MM.").format(sprint.start)}"),
                            Text(
                                "Sprintende ${DateFormat("dd.MM.").format(sprint.end)}"),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.9, 0),
                      child: IntrinsicHeight(
                        child: RemainingSprintTimer(sprint: sprint),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const Boss(),
          const BossfightTeam(),
        ],
      ),
    );
  }
}

class RemainingSprintTimer extends StatefulWidget {
  const RemainingSprintTimer({
    Key? key,
    required this.sprint,
  }) : super(key: key);

  final Sprint sprint;

  @override
  State<RemainingSprintTimer> createState() => _RemainingSprintTimerState();
}

class _RemainingSprintTimerState extends State<RemainingSprintTimer>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timeLeft = const Duration(minutes: 10, seconds: 59);
    animationController.repeat(reverse: true);
    final colorAnimation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(animationController);
    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, _) {
        var timeLeft = widget.sprint.end.difference(DateTime.now());
        final timeLeftString =
            "${timeLeft.inHours.toString().padLeft(2, "0")}:${timeLeft.inMinutes.remainder(60).toString().padLeft(2, "0")}:${timeLeft.inSeconds.remainder(60).toString().padLeft(2, "0")}";
        int brightness = (colorAnimation.value * 255).toInt();
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            timeLeft < const Duration(minutes: 10)
                ? Color.fromARGB(255, 255, brightness, brightness)
                : Colors.white,
            BlendMode.modulate,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  "assets/icons/Pixel/Sanduhr.PNG",
                  filterQuality: FilterQuality.none,
                  scale: 1 / 10,
                ),
              ),
              Text(timeLeftString),
            ],
          ),
        );
      },
    );
  }
}

class VersusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path separationPath = Path();
    const lineSegments = 7;
    // const angle = -35 / 180 * pi;
    double angle = atan2(size.height * -0.2, size.width / 2);
    double length = size.width / cos(angle) + 80;
    for (int i = 0; i <= lineSegments; i++) {
      Offset pos = size.center(Offset.zero);
      Offset diagonalVec = Offset(cos(angle), sin(angle));
      Offset tangent = Offset(cos(angle + pi / 2), sin(angle + pi / 2));
      pos += diagonalVec * ((i / lineSegments - 0.5) * length);
      pos += tangent * (i % 2 == 0 ? 1 : -1) * length * 0.03;
      if (i == 0) {
        separationPath.moveTo(pos.dx, pos.dy);
      } else {
        separationPath.lineTo(pos.dx, pos.dy);
      }
    }
    canvas.drawPath(
      separationPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20,
    );

    const spikes = 10;
    Path starPath = Path();
    Offset center = size.center(Offset.zero);
    for (int i = 0; i < spikes * 2; i++) {
      double magnitude = i % 2 == 0 ? 40 : 70;
      Offset pos = Offset(
                cos(i / (spikes * 2) * pi * 2),
                sin(i / (spikes * 2) * pi * 2),
              ) *
              magnitude +
          center;
      if (i == 0) {
        starPath.moveTo(pos.dx, pos.dy);
      } else {
        starPath.lineTo(pos.dx, pos.dy);
      }
    }
    starPath.close();
    canvas.drawPath(
      starPath,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
