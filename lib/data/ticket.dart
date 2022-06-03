class Ticket {
  const Ticket(this.name, this.description, this.storyPoints, this.duration, this.done);
  final String name;
  final String description;
  final int storyPoints;
  final double duration;
  final bool done;
  static Ticket fromJSON(Map<String, dynamic> json) {
    return Ticket(json["name"], json["description"], json["storyPoints"], (json["duration"]).toDouble(), json["done"]);
  }
}
