import 'package:sff/data/api/authenticated_api.dart';

class Ticket {
  const Ticket(this.id, this.name, this.description, this.storyPoints,
      this.duration, this.done, this.rewardClaimed);
  final String id;
  final String name;
  final String description;
  final int storyPoints;
  final double duration;
  final bool done;
  final bool rewardClaimed;
  static Ticket fromJSON(Map<String, dynamic> json) {
    return Ticket(
        json["_id"],
        json["name"],
        json["description"],
        json["storyPoints"],
        (json["duration"]).toDouble(),
        json["done"],
        json["rewardClaimed"]);
  }

  Future<void> claimReward() async {
    print("____________________:${id}");
    await authAPI.patch("db/tickets/claim-reward/$id", null);
  }
}
