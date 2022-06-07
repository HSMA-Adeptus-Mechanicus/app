class Ticket {
  const Ticket(this.name, this.description, this.storyPoints, this.duration,
      this.done, this.rewardClaimed);
  final String name;
  final String description;
  final int storyPoints;
  final double duration;
  final bool done;
  final bool rewardClaimed;
  static Ticket fromJSON(Map<String, dynamic> json) {
    return Ticket(json["name"], json["description"], json["storyPoints"],
        (json["duration"]).toDouble(), json["done"], json["rewardClaimed"]);
  }
}
