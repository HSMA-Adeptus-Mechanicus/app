import 'dart:async';

import 'package:sff/data/data.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/model/item.dart';
import 'package:sff/data/model/streamable.dart';

class User extends Streamable<User> {
  User(super.id, this._name, this._wardrobe, this._avatar, this._currency);
  String _name;
  Map<String, String?> _avatar;
  List<String> _wardrobe;
  int _currency;
  Future<Avatar>? _avatarFuture;

  String get name {
    return _name;
  }

  Map<String, String?> get avatar {
    return _avatar;
  }

  List<String> get wardrobe {
    return _wardrobe;
  }

  int get currency {
    return _currency;
  }

  static User fromJSON(Map<String, dynamic> json) {
    Map<String, dynamic> avatar = json["avatar"];
    return User(
      json["_id"],
      json["name"],
      (json["wardrobe"] as List<dynamic>).whereType<String>().toList(),
      avatar.map((key, value) => MapEntry(key, value as String?)),
      json["currency"],
    );
  }

  @override
  bool processUpdatedJSON(Map<String, dynamic> json) {
    List<String> newWardrobe =
        (json["wardrobe"] as List<dynamic>).whereType<String>().toList();
    Map<String, String?> newAvatar = (json["avatar"] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as String?));
    bool avatarChanged = newAvatar.length != avatar.length ||
        !newAvatar.entries
            .every((element) => element.value == avatar[element.key]);
    bool change = json["name"] != name ||
        newWardrobe.length != wardrobe.length ||
        !newWardrobe.every((element) => wardrobe.contains(element)) ||
        avatarChanged ||
        json["currency"] != currency;
    _name = json["name"];
    _wardrobe = newWardrobe;
    _avatar = newAvatar;
    _currency = json["currency"];
    if (avatarChanged) {
      _avatarFuture = null;
    }
    return change;
  }

  Future<Avatar> getAvatar() {
    final avatarFuture = _avatarFuture ??= () async {
      List<Item> items = await first(data.getItemsStream());
      Map<String, Item> equippedItems = {};
      for (var entry in avatar.entries) {
        if (entry.value is String) {
          try {
            equippedItems[entry.key] =
                items.firstWhere((item) => item.id == entry.value);
          } catch (e) {
            // ignore if the item does not exist
          }
        }
      }
      return Avatar(equippedItems);
    }();
    return avatarFuture;
  }

  bool ownsItem(Item item) {
    return wardrobe.contains(item.id);
  }

  Future<List<Item>> getInventory() async {
    List<Item> items = await first(data.getItemsStream());
    List<Item> inventory = items.where((items) => ownsItem(items)).toList();
    return inventory;
  }
}
