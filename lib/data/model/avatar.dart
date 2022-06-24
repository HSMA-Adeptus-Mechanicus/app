import 'dart:async';

import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/item.dart';

import 'item.dart';

class Avatar {
  final Map<String, Item> equippedItems;
  Iterable<Item> get equipped {
    return equippedItems.values;
  }

  const Avatar(this.equippedItems);

  bool isEquipped(Item item) {
    return equippedItems[item.category]?.id == item.id;
  }
}

const requiredItemCategories = [
  "skin",
  "hand",
  "face",
  "hair",
];

class EditableAvatar extends Avatar {
  EditableAvatar(Map<String, Item> equippedItems) : super({}) {
    setTo(equippedItems);
    broadcastStream = changeController.stream.asBroadcastStream();
  }

  final StreamController<EditableAvatar> changeController = StreamController();
  late final Stream<EditableAvatar> broadcastStream;

  setItem(Item item) async {
    if (item.category == "skin") {
      final number = RegExp(r"(?<!\d)(\d+)\..{3}$").firstMatch(item.url)?[1];
      List<Item> items = await first(data.getItemsStream());
      final handItem = items.firstWhere((item) =>
          item.category == "hand" &&
          RegExp(r"[^\d]" + number! + r"\..{3}$").hasMatch(item.url));
      equippedItems[handItem.category] = handItem;
    }
    equippedItems[item.category] = item;
    changeController.add(this);
  }

  void removeItem(String category) {
    if (requiredItemCategories.contains(category)) {
      return;
    }
    equippedItems.remove(category);
    changeController.add(this);
  }

  void setTo(Map<String, Item> items) {
    equippedItems.clear();
    equippedItems.addAll(items);
    changeController.add(this);
  }

  Stream<EditableAvatar> getStream() {
    late StreamController<EditableAvatar> controller;
    onListen() {
      controller.add(this);
      controller.addStream(broadcastStream);
    }

    onCancel() {
      controller.close();
    }

    controller = StreamController(
      onListen: onListen,
      onCancel: onCancel,
    );
    return controller.stream;
  }

  applyToCurrentUser() async {
    await authAPI.post("db/avatar/equip",
        equippedItems.map((key, value) => MapEntry(key, value.id)));
    CachedAPI.getInstance().reload("db/users");
  }

  bool equals(Avatar avatar) {
    if (equippedItems.length != avatar.equippedItems.length) return false;
    for (final entry in equippedItems.entries) {
      if (entry.value != avatar.equippedItems[entry.key]) {
        return false;
      }
    }
    return true;
  }
}
