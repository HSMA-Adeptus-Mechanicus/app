import 'dart:async';

import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';

class User {
  User(this.id, this.name, this.wardrobe, this.avatar, this.currency);
  final String id;
  final String name;
  final Avatar avatar;
  final List<String> wardrobe;
  final int currency;
  static Future<User> fromJSON(Map<String, dynamic> json) async {
    List<Item> items = await first(data.getItemsStream());
    Map<String, Item> equippedItems = {};
    Map<String, dynamic> avatar = json["avatar"];
    for (var entry in avatar.entries) {
      if (entry.value is String) {
        equippedItems[entry.key] =
            items.firstWhere((item) => item.id == entry.value);
      }
    }
    return User(
      json["_id"],
      json["name"],
      (json["wardrobe"] as List<dynamic>)
          .map((element) => element as String)
          .toList(),
      Avatar(equippedItems),
      json["currency"],
    );
  }

  bool ownsItem(Item item) {
    return wardrobe.contains(item.id);
  }

  Future<List<Item>> getInventory() async {
    List<Item> items = await first(data.getItemsStream());
    List<Item> inventory = items.where((items) => ownsItem(items)).toList();
    return inventory;
  }

  String getId() {
    return id;
  }
}
