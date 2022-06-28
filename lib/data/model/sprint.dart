import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/streamable.dart';
import 'package:sff/data/model/ticket.dart';

class Sprint extends StreamableObject<Sprint> {
  String _name;
  List<String> _ticketIds;
  String state;
  DateTime _start;
  DateTime _end;

  String get name {
    return _name;
  }
  List<String> get ticketIds {
    return _ticketIds;
  }
  DateTime get start {
    return _start;
  }
  DateTime get end {
    return _end;
  }

  Sprint(super.id, this._name, this.state, this._ticketIds, this._start, this._end);

  static Sprint fromJSON(Map<String, dynamic> json) {
    return Sprint(
      json["_id"],
      json["name"],
      json["state"],
      ((json["tickets"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      DateTime.fromMillisecondsSinceEpoch(json["startTime"]),
      DateTime.fromMillisecondsSinceEpoch(json["endTime"]),
    );
  }

  @override
  bool processUpdatedJSON(Map<String, dynamic> json) {
    String newName = json["name"];
    List<String> newTickets = ((json["tickets"] ?? []) as List<dynamic>)
        .map((e) => e as String)
        .toList();
    DateTime newStartTime =
        DateTime.fromMillisecondsSinceEpoch(json["startTime"]);
    DateTime newEndTime = DateTime.fromMillisecondsSinceEpoch(json["endTime"]);
    bool change = newName != name || newTickets.length != ticketIds.length || !newTickets.every((element) => ticketIds.contains(element)) || newStartTime != start || newEndTime != end;
    _name = newName;
    _ticketIds = newTickets;
    _start = newStartTime;
    _end = newEndTime;
    return change;
  }

  void loadTickets() async {
    await authAPI.post("load-jira", {
      "resources": [
        {
          "type": "tickets",
          "args": {
            "sprintId": id,
          },
        },
      ],
    });
    CachedAPI.getInstance().reload("db/sprints");
  }

  Future<int> calculateCurrentHealth() async {
    List<Ticket> ticketArray = await first(data.getTicketsStream());
    return ticketArray
        .map((e) => e.done ? 0 : e.storyPoints)
        .reduce((value, element) => value + element);
  }

  Future<int> calculateMaxHealth() async {
    List<Ticket> ticketArray = await first(data.getTicketsStream());
    return ticketArray
        .map((e) => e.storyPoints)
        .reduce((value, element) => value + element);
  }

  Future<double> calculateHealthPercentage() async {
    List<Ticket> ticketArray = await first(data.getTicketsStream());
    final current = ticketArray
        .map((e) => e.done ? 0 : e.storyPoints)
        .reduce((value, element) => value + element);
    final max = ticketArray
        .map((e) => e.storyPoints)
        .reduce((value, element) => value + element);
    return current / max;
  }
}
