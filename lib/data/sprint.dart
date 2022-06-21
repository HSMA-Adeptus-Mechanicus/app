class Sprint {
  final String name;
  final List<String> ticketIds;
  final DateTime start;
  final DateTime end;

  const Sprint(this.name, this.ticketIds, this.start, this.end);

  static Sprint fromJSON(Map<String, dynamic> json) {
    return Sprint(
      json["name"],
      ((json["tickets"] ?? []) as List<dynamic>).map((e) => e as String).toList(),
      DateTime.fromMillisecondsSinceEpoch(json["startTime"]),
      DateTime.fromMillisecondsSinceEpoch(json["endTime"]),
    );
  }
}
