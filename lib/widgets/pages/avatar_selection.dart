import 'package:flutter/material.dart';
import 'package:sff/widgets/pages/item_selection.dart';

class AvatarSelection extends StatelessWidget {
  const AvatarSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemSelectionByCategory(
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
