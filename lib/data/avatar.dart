import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/item.dart';

class Avatar {
  /// equips the avatar of the currently logged in user with the given item
  static equip(Item item) async {
    await authAPI.patch("db/avatar/equip/${item.id}", null);
    CachedAPI.getInstance().request("db/users").ignore(); // trigger update of users (which will automatically cause an update to all streams)
  }
  static unequip(Item item) async {
    await authAPI.delete("db/avatar/equip/${item.id}");
    CachedAPI.getInstance().request("db/users").ignore(); // trigger update of users (which will automatically cause an update to all streams)
  }

  final Map<String, Item> equippedItems;
  Iterable<Item> get equipped {
    return equippedItems.values;
  }

  const Avatar(this.equippedItems);

  bool isEquipped(Item item) {
    return equippedItems[item.category]?.id == item.id;
  }
}
