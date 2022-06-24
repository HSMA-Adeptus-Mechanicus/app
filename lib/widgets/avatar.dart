import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/item.dart';

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
    return StreamBuilder<Avatar>(
      stream: data.getUserStream(userId).asyncMap((event) => event.getAvatar()),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return AvatarWidget(avatar: snapshot.data!);
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  final Avatar avatar;

  const AvatarWidget({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Item> equippedItems = avatar.equippedItems;
    final sortedItems = categoryOrder.map((category) => equippedItems[category]).whereType<Item>();

    return Stack(
      children: sortedItems
          .map(
            (item) => FutureBuilder<Uint8List>(
                future: item.getImageData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
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
                }),
          )
          .toList(),
    );
  }
}
