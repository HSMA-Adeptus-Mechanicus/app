import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/widgets/avatar.dart';

class BossfightTeam extends StatelessWidget {
  const BossfightTeam({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: () async* {
        yield* (await ProjectManager.getInstance())
            .currentProject!
            .getTeamStream();
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<User> users = snapshot.data!;
          int currentUserIndex = users.indexWhere((element) =>
              element.id == UserAuthentication.getInstance().userId);

          if (currentUserIndex >= 0) {
            // swap current user to center
            // in case there is an even number of users it will be the center right
            int centerIndex = users.length ~/ 2;
            User temp = users[currentUserIndex];
            users[currentUserIndex] = users[centerIndex];
            users[centerIndex] = temp;
          }

          List<Widget> avatars = users
              .map((user) => StreamBuilder<Avatar>(
                    stream:
                        user.asStream().asyncMap((user) => user.getAvatar()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AvatarWidget(avatar: snapshot.data!);
                      }
                      return const SizedBox.shrink();
                    },
                  ))
              .toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              getSize(int i) {
                return 3 /
                    ((i - ((users.length - (users.length.isEven ? 0 : 1)) / 2))
                            .abs() +
                        3) *
                    min(
                      constraints.maxWidth / 0.9,
                      constraints.maxHeight / 1.5,
                    );
              }

              double totalWidth = List.generate(users.length, getSize).reduce(
                (value, element) => value + element,
              );
              double overflowAmount = constraints.maxWidth * 0.1;
              double availableSpace = constraints.maxWidth + overflowAmount;

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
                  (((b.left! + b.width! / 2) - constraints.maxWidth / 2).abs() -
                          ((a.left! + a.width! / 2) - constraints.maxWidth / 2)
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
        return const SizedBox.shrink();
      },
    );
  }
}
