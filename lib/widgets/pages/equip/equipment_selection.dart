import 'package:flutter/material.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/widgets/pages/equip/item_selection.dart';

class EquipmentSelection extends StatelessWidget {
  final EditableAvatar avatar;

  const EquipmentSelection({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemSelectionByCategory(
      avatar: avatar,
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
