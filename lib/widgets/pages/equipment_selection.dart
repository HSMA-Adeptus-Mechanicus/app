import 'package:flutter/material.dart';
import 'package:sff/widgets/pages/item_selection.dart';

class EquipmentSelection extends StatelessWidget {
  const EquipmentSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ItemSelectionByCategory(
      categories: [
        "torso",
        "pants",
        "shoes",
        "hat",
        "weapon",
      ],
    );
  }
}