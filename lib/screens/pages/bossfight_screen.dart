import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/widgets/avatar.dart';
import 'package:sff/widgets/pages/boss_health_bar.dart';

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
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 20,
                        width: constraints.maxWidth * 0.7,
                        child: const BossHealthBar(),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * 0.65,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: constraints.maxHeight * 0.55,
                            child: Image.asset(
                              "assets/boss/Boss_1_1.png",
                              filterQuality: FilterQuality.none,
                              scale: 1 / 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          StreamBuilder<List<User>>(
            stream: data.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data!;
                int currentUserIndex = users.indexWhere((element) =>
                    element.id == UserAuthentication.getInstance().userId);

                {
                  // swap current user to center
                  // in case there is an even number of users it will be the center right
                  int centerIndex = users.length ~/ 2;
                  User temp = users[currentUserIndex];
                  users[currentUserIndex] = users[centerIndex];
                  users[centerIndex] = temp;
                }

                List<Widget> avatars = users
                    .map((user) => AvatarWidget(avatar: user.avatar))
                    .toList();

                return LayoutBuilder(
                  builder: (context, constraints) {
                    getSize(int i) {
                      return 3 /
                          ((i -
                                      ((users.length -
                                              (users.length.isEven ? 0 : 1)) /
                                          2))
                                  .abs() +
                              3) *
                          min(
                            constraints.maxWidth / 0.9,
                            constraints.maxHeight / 1.5,
                          );
                    }

                    double totalWidth =
                        List.generate(users.length, getSize).reduce(
                      (value, element) => value + element,
                    );
                    double overflowAmount = constraints.maxWidth * 0.1;
                    double availableSpace =
                        constraints.maxWidth + overflowAmount;

                    double offset = -overflowAmount / 2;
                    List<Positioned> positionedAvatars = [];
                    for (int i = 0; i < users.length; i++) {
                      final size = getSize(i);
                      final space = size / totalWidth * availableSpace;
                      positionedAvatars.add(Positioned(
                        top: constraints.maxHeight - size + size * 0.2,
                        left: offset - (size - space) / 2,
                        width: size,
                        height: size,
                        child: avatars[i],
                      ));
                      offset += space;
                    }

                    positionedAvatars.sort((a, b) =>
                        (((b.left! + b.width! / 2) - constraints.maxWidth / 2)
                                    .abs() -
                                ((a.left! + a.width! / 2) -
                                        constraints.maxWidth / 2)
                                    .abs())
                            .sign
                            .toInt());

                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: Stack(
                        children: [
                          ...positionedAvatars,
                        ],
                      ),
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error!);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
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
