import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/sprint.dart';
import 'package:sff/widgets/pages/bossfight/boss.dart';
import 'package:sff/widgets/pages/bossfight/bossfight_team.dart';

class Bossfight extends StatelessWidget {
  const Bossfight({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
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
          Align(
            alignment: const Alignment(0.8, -0.8),
            child: StreamBuilder<List<Sprint>>(
              stream: data.getSprintsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final sprint = snapshot.data![0];
                  return IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Sprintanfang ${DateFormat("dd.MM.").format(sprint.start)}"),
                        Text(
                            "Sprintende ${DateFormat("dd.MM.").format(sprint.end)}"),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorWidget(snapshot.error!);
                }
                return const SizedBox();
              },
            ),
          ),
          const Boss(),
          const BossfightTeam(),
        ],
      ),
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
