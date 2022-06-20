import 'package:flutter/material.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/widgets/pages/item_selection.dart';

class AvatarSelection extends StatelessWidget {
  final EditableAvatar avatar;

  const AvatarSelection({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemSelectionByCategory(
      avatar: avatar,
      categories: [
        ItemCategory(
          category: "skin",
          icon: "assets/icons/Avatar/hautfarbe_schwarz.png",
        ),
        ItemCategory(
          category: "face",
          icon: "assets/icons/Avatar/gesicht_schwarz.png",
        ),
        ItemCategory(
          category: "hair",
          icon: "assets/icons/Avatar/haar_schwarz.png",
        ),
      ],
    );
  }
}
