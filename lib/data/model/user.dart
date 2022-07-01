import 'dart:async';

import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/model/item.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/data/model/streamable.dart';
import 'package:sff/data/model/ticket.dart';

class User extends StreamableObject<User> {
  User(super.id, this._name, this._wardrobe, this._avatarSetup, this._avatar,
      this._currency);
  String _name;
  bool _avatarSetup;
  Map<String, String?> _avatar;
  List<String> _wardrobe;
  int _currency;
  Future<Avatar>? _avatarFuture;

  String get name {
    return _name;
  }

  bool get avatarSetup {
    return _avatarSetup;
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
      json["avatarSetup"] ?? true,
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
        _avatarSetup != (json["avatarSetup"] ?? true) ||
        avatarChanged ||
        json["currency"] != currency;
    _name = json["name"];
    _wardrobe = newWardrobe;
    _avatarSetup = json["avatarSetup"] ?? true;
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

  Future<void> loadProjects() async {
    await authAPI.post("load-jira", {
      "resources": [
        {
          "type": "projects",
        },
      ],
    });
    await CachedAPI.getInstance().request("db/projects");
  }

  Stream<List<Project>> getProjectsStream() async* {
    // The team of a project could change which would change if the project is part of this users projects
    Stream<List<Project>> projectsStream = data.getAnyChangeProjectsStream();
    await for (List<Project> projects in projectsStream) {
      yield projects.where((element) => element.team.contains(id)).toList();
    }
  }

  bool ownsItem(Item item) {
    return wardrobe.contains(item.id);
  }

  Future<void> changeName(String name) async {
    if (id != UserAuthentication.getInstance().userId) {
      throw Exception(
          "Only the currently authenticated user can change its name");
    }
    String previous = _name;
    _name = name;
    updateStream();
    try {
      await authAPI.patch("db/users/change-name", {"name": name});
    } catch (e) {
      _name = previous;
      updateStream();
      rethrow;
    } finally {
      CachedAPI.getInstance().reload("db/users");
    }
  }

  Future<void> buy(Item item) async {
    if (id != UserAuthentication.getInstance().userId) {
      throw Exception("Only the currently authenticated user can buy an item");
    }

    bool doubleItem = ownsItem(item);
    _currency -= doubleItem ? 14 : 15;
    if (!doubleItem) {
      _wardrobe.add(item.id);
    }
    updateStream();
    try {
      await authAPI.post("db/items/buy/${item.id}", null);
    } catch (e) {
      if (!doubleItem) {
        _wardrobe.remove(item.id);
      }
      _currency += doubleItem ? 14 : 15;
      updateStream();
      rethrow;
    } finally {
      CachedAPI.getInstance().reload("db/users");
    }
  }

  Future<void> applyAvatar(Avatar newAvatar) async {
    Map<String, String?> previous = avatar;
    _avatar =
        newAvatar.equippedItems.map((key, value) => MapEntry(key, value.id));
    _avatarFuture = null;
    updateStream();
    try {
      await authAPI.post("db/avatar/equip",
          newAvatar.equippedItems.map((key, value) => MapEntry(key, value.id)));
    } catch (e) {
      _avatar = previous;
      _avatarFuture = null;
      updateStream();
    } finally {
      CachedAPI.getInstance().reload("db/users");
    }
  }

  Future<void> claimReward(Ticket ticket) async {
    if (ticket.rewardClaimed) {
      throw Exception("Unable to claim reward of ticket already claimed");
    }
    ticket.setClaimed(true);
    _currency += ticket.rewardCurrency;
    updateStream();
    try {
      await authAPI.patch("db/tickets/claim-reward/${ticket.id}", null);
    } catch (e) {
      ticket.setClaimed(false);
      _currency -= ticket.rewardCurrency;
      updateStream();
    } finally {
      CachedAPI.getInstance().reload("db/tickets");
      CachedAPI.getInstance().reload("db/users");
    }
  }

  Future<List<Item>> getInventory() async {
    List<Item> items = await first(data.getItemsStream());
    List<Item> inventory = items.where((items) => ownsItem(items)).toList();
    return inventory;
  }

  Stream<UserAndAvatar> getStreamWithAvatar() {
    return asStream()
        .asyncMap((user) async => UserAndAvatar(user, await user.getAvatar()));
  }
}

class UserAndAvatar {
  final User user;
  final Avatar avatar;

  const UserAndAvatar(this.user, this.avatar);
}
