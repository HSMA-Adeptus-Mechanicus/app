import 'package:sff/data/item.dart';

class Avatar {
  final Map<String, Item> equippedItems;
  Iterable<Item> get equipped {
    return equippedItems.values;
  }

  const Avatar(this.equippedItems);
}
