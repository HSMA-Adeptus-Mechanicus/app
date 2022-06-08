import 'dart:async';

import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/item.dart';
import 'package:sff/data/ticket.dart';
import 'package:sff/data/user.dart';

const data = Data();

// TODO: Delete once it has been solved
/// This is a workaround for stream.first that should (hopefully)
/// no longer be necessary in the next release of dart
/// more information: https://github.com/dart-lang/sdk/issues/34775
Future<T> first<T>(Stream<T> stream) {
  Completer<T> completer = Completer();
  StreamSubscription<T>? subscription;
  subscription = stream.listen((event) {
    completer.complete(event);
    subscription!.cancel().then((value) {}); // This future might not complete at all
  });
  return completer.future;
}

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
      yield await Future.wait(snapshot.map((e) => User.fromJSON(e)).toList(),
          eagerError: true);
    }
  }

  Stream<List<Item>> getItemsStream() async* {
    Stream<dynamic> stream = CachedAPI.getInstance().getStream("db/items");
    await for (List<dynamic> snapshot in stream) {
      yield snapshot.map((e) => Item.fromJSON(e)).toList();
    }
  }
}
