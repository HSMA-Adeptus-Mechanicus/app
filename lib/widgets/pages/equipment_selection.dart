import 'package:flutter/material.dart';
import 'package:sff/widgets/pages/item_selection.dart';

class EquipmentSelection extends StatelessWidget {
  const EquipmentSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemSelectionByCategory(
      categories: [
        ItemCategory(
          category: "torso",
          icon: "assets/icons/Garderobe/shirt_schwarz.png",
        ),
        ItemCategory(
          category: "pants",
          icon: "assets/icons/Garderobe/hose_schwarz.png",
        ),
        ItemCategory(
          category: "shoes",
          icon: "assets/icons/Garderobe/schuhe_schwarz.png",
        ),
        ItemCategory(
          category: "hat",
          icon: "assets/icons/Garderobe/hut_schwarz.png",
        ),
        ItemCategory(
          category: "weapon",
          icon: "assets/icons/Garderobe/waffen_schwarz.png",
        ),
      ],
    );
  }
}
