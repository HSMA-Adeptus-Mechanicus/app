import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';

class Ticket {
  const Ticket(
    this.id,
    this.name,
    this.description,
    this.storyPoints,
    this.duration,
    this.done,
    this.rewardClaimed,
    this.assignee,
    this.assignedUser,
  );
  final String id;
  final String name;
  final String description;
  final int storyPoints;
  final double duration;
  final bool done;
  final bool rewardClaimed;
  final String assignee;
  final User assignedUser;
  static Future<Ticket> fromJSON(Map<String, dynamic> json) async {
    List<User> users = await first(data.getUsersStream());
    User assignedUser;
    try {
      assignedUser = users.firstWhere((user) => user.id == json["assignee"]);
    } catch (e) {
      assignedUser = User("", "unknown", [], const Avatar({}), 0);
    }
    return Ticket(
      json["_id"],
      json["name"],
      json["description"],
      json["storyPoints"],
      json["duration"].toDouble(),
      json["done"],
      json["rewardClaimed"],
      json["assignee"],
      assignedUser,
    );
  }

  Future<void> claimReward() async {
    await authAPI.patch("db/tickets/claim-reward/$id", null);
    CachedAPI.getInstance().request("db/tickets").ignore();
    CachedAPI.getInstance().request("db/users").ignore();
  }
}
