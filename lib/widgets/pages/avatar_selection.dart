import 'package:flutter/material.dart';
import 'package:sff/widgets/pages/item_selection.dart';

class AvatarSelection extends StatelessWidget {
  const AvatarSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ItemSelectionByCategory(
      categories: [
        "skin",
        "face",
        "hair",
      ],
    );
  }
}