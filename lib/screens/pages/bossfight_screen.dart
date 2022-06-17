import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/widgets/avatar.dart';

class AlignedAvatar {
  final AvatarWidget avatar;
  final double align;

  AlignedAvatar(this.avatar, this.align);
}

class Bossfight extends StatelessWidget {
  const Bossfight({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: data.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AlignedAvatar> alignedUserWidgets = [];
          List<User> users = snapshot.data!;
          int currentUserIndex = users.indexWhere((element) =>
              element.id == UserAuthentication.getInstance().userId);

          {
            // swap current user to center
            int centerIndex = (users.length - 1) ~/ 2;
            User temp = users[currentUserIndex];
            users[currentUserIndex] = users[centerIndex];
            users[centerIndex] = temp;
          }

          for (int i = 0; i < users.length; i++) {
            alignedUserWidgets.add(AlignedAvatar(
              AvatarWidget(
                avatar: users[i].avatar,
              ),
              sin((i / (users.length - 1) * 2 - 1) * 90 / 180 * pi) * 1.9,
            ));
          }

          // sort such that the avatars in the center are on top
          alignedUserWidgets
              .sort((a, b) => (b.align.abs() - a.align.abs()).sign.toInt());

          double width = MediaQuery.of(context).size.width;

          return Stack(
            children: [
              CustomPaint(
                painter: VersusPainter(),
                child: const Center(
                  child: Text(
                    "VS",
                    style: TextStyle(
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
              Stack(
                children: alignedUserWidgets.map((e) {
                  final size =
                      width / users.length * 5 / ((e.align.abs() / 3) + 1);
                  return Align(
                    alignment:
                        Alignment(e.align, 1 + 0.8 / (e.align.abs() + 1.5)),
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Center(child: e.avatar),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class VersusPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path separationPath = Path();
    const lineSegments = 7;
    const angle = -35 / 180 * pi;
    double length = size.width / cos(angle) + 80;
    for (int i = 0; i <= lineSegments; i++) {
      Offset pos = size.center(Offset.zero);
      Offset diagonalVec = Offset(cos(angle), sin(angle));
      Offset tangent = Offset(cos(angle + pi / 2), sin(angle + pi / 2));
      pos += diagonalVec * ((i / lineSegments - 0.5) * length);
      pos += tangent * (i % 2 == 0 ? 1 : -1) * 10;
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
