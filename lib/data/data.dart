import 'dart:async';

import 'package:app/data/api/cached_api.dart';
import 'package:app/data/ticket.dart';

const data = Data();

class Data {
  const Data();

  Stream<List<Ticket>> getTicketsStream() async* {
    Stream<dynamic> stream = CachedAPI.getInstance().getStream("db/tickets");
    await for (List<dynamic> snapshot in stream) {
      yield snapshot.map((e) => Ticket.fromJSON(e)).toList();
    }
  }
}
