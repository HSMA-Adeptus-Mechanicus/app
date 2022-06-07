import 'package:flutter/material.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/item.dart';

// order from back to front
const categoryOrder = [
  "skin",
  "face",
  "hair",
  "head-cover",
  "weapon",
  "hand",
  "pants",
  "boots",
  "shirt",
];

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
            (item) => Image.network(
              item.url,
              scale: 1 / 3,
              filterQuality: FilterQuality.none,
            ),
          )
          .toList(),
    );
  }
}
