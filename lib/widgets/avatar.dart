import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';
import 'package:sff/data/user.dart';

// order from back to front
const categoryOrder = [
  "skin",
  "face",
  "hair",
  "hat",
  "weapon",
  "hand",
  "pants",
  "shoes",
  "torso",
];

class UserAvatarWidget extends StatelessWidget {
  final String userId;

  const UserAvatarWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: data.getUsersStream(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!.firstWhere(
            (user) => user.id == userId,
          );
          return AvatarWidget(avatar: user.avatar);
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final Avatar avatar;

  const AvatarWidget({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> equippedItems = avatar.equipped.toList();
    equippedItems.sort(
      (a, b) =>
          categoryOrder.indexOf(a.category) - categoryOrder.indexOf(b.category),
    );

    return Stack(
      children: equippedItems
          .map(
            (item) => FutureBuilder<Uint8List>(
              future: item.getImageData(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                {
                return Image.memory(
                  snapshot.data!,
                  scale: 1 / 3,
                  filterQuality: FilterQuality.none,
                );
                }
                if (snapshot.hasError) {
                  return ErrorWidget(snapshot.error!);
                }
                return const SizedBox.shrink();
              }
            ),
          )
          .toList(),
    );
  }
}
