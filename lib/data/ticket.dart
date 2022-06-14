import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';

class Ticket {
  const Ticket(this.id, this.name, this.description, this.storyPoints,
      this.duration, this.done, this.rewardClaimed, this.assignee);
  final String id;
  final String name;
  final String description;
  final int storyPoints;
  final double duration;
  final bool done;
  final bool rewardClaimed;
  final String assignee;
  static Ticket fromJSON(Map<String, dynamic> json) {
    return Ticket(
        json["_id"],
        json["name"],
        json["description"],
        json["storyPoints"],
        json["duration"].toDouble(),
        json["done"],
        json["rewardClaimed"],
        json["assignee"]);
  }

  Future<void> claimReward() async {
    await authAPI.patch("db/tickets/claim-reward/$id", null);
    CachedAPI.getInstance().request("db/tickets").ignore();
  }
}
