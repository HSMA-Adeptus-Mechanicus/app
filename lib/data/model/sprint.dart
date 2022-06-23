import 'package:sff/data/data.dart';
import 'package:sff/data/model/ticket.dart';

class Sprint {
  final String name;
  final List<String> ticketIds;
  final DateTime start;
  final DateTime end;

  const Sprint(this.name, this.ticketIds, this.start, this.end);

  static Sprint fromJSON(Map<String, dynamic> json) {
    return Sprint(
      json["name"],
      ((json["tickets"] ?? []) as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      DateTime.fromMillisecondsSinceEpoch(json["startTime"]),
      DateTime.fromMillisecondsSinceEpoch(json["endTime"]),
    );
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
