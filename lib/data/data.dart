import 'dart:async';

import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/ticket.dart';
import 'package:sff/data/user.dart';

const data = Data();

class Data {
  const Data();

  Stream<List<Ticket>> getTicketsStream() async* {
    Stream<dynamic> stream = CachedAPI.getInstance().getStream("db/tickets");
    await for (List<dynamic> snapshot in stream) {
      yield snapshot.map((e) => Ticket.fromJSON(e)).toList();
    }
  }

  Stream<List<User>> getUsersStream() async* {
    Stream<dynamic> stream = CachedAPI.getInstance().getStream("db/users");
    await for (List<dynamic> snapshot in stream) {
      yield snapshot.map((e) => User.fromJSON(e)).toList();
    }
  }
}
