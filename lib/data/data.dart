import 'dart:async';

import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/model/item.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/data/model/sprint.dart';
import 'package:sff/data/model/streamable.dart';
import 'package:sff/data/model/ticket.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/data/api/user_authentication.dart';

const data = Data();

// TODO: Delete once it has been solved
/// This is a workaround for stream.first that should (hopefully)
/// no longer be necessary in the next release of dart (2.18)
/// more information: https://github.com/dart-lang/sdk/issues/34775
Future<T> first<T>(Stream<T> stream) {
  Completer<T> completer = Completer();
  StreamSubscription<T>? subscription;
  subscription = stream.listen((event) {
    completer.complete(event);
    subscription!
        .cancel()
        .then((value) {}); // This future might not complete at all
  });
  return completer.future;
}

class Data {
  const Data();

  Stream<List<Ticket>> getTicketsStream() {
    return _StreamListSupplier.getInstance("db/tickets", Ticket.fromJSON)
        .getStream();
  }

  Stream<List<Ticket>> getAnyChangeTicketsStream() {
    return _StreamListSupplier.getInstance("db/tickets", Ticket.fromJSON)
        .getAnyChangeStream();
  }

  Stream<List<User>> getUsersStream() {
    return _StreamListSupplier.getInstance("db/users", User.fromJSON)
        .getStream();
  }

  Stream<List<Item>> getItemsStream() {
    return _StreamListSupplier.getInstance("db/items", Item.fromJSON)
        .getStream();
  }

  Stream<List<Project>> getProjectsStream() {
    return _StreamListSupplier.getInstance("db/projects", Project.fromJSON)
        .getStream();
  }

  Stream<List<Sprint>> getSprintsStream() {
    return _StreamListSupplier.getInstance("db/sprints", Sprint.fromJSON)
        .getStream();
  }

  Future<User> getUser(String id) async {
    List<User> users = await first(data.getUsersStream());
    try {
      return users.firstWhere((element) => element.id == id);
    } catch (e) {
      await CachedAPI.getInstance().request("db/users");
      List<User> users = await first(data.getUsersStream());
      return users.firstWhere((user) => user.id == id);
    }
  }

  Stream<User> getUserStream(String id) async* {
    User user = await getUser(id);
    yield* user.asStream();
  }

  Future<User> getCurrentUser() async {
    return getUser(UserAuthentication.getInstance().userId!);
  }

  Stream<User> getCurrentUserStream() {
    return getUserStream(UserAuthentication.getInstance().userId!);
  }
}

typedef ParseFunction<T> = T Function(Map<String, dynamic> data);

class _StreamListSupplier<T extends StreamableObject<T>> {
  static final Map<String, _StreamListSupplier> _streamSupplier = {};

  static _StreamListSupplier<T> getInstance<T extends StreamableObject<T>>(
      String path, ParseFunction<T> parse) {
    var existing = _streamSupplier[path];
    if (existing == null) {
      var newSupplier = _StreamListSupplier<T>(path, parse);
      _streamSupplier[path] = newSupplier;
      return newSupplier;
    } else {
      CachedAPI.getInstance().reloadIfOutdated(path);
    }
    if (existing is! _StreamListSupplier<T>) {
      throw Exception("A stream supplier for a path can only have one type");
    }
    return existing;
  }

  List<T>? _dataList;
  late final Stream<List<T>> _broadcastStream;
  final StreamController<List<T>> _anyChangeController = StreamController();
  late final Stream<List<T>> _anyChangeBroadcastStream;

  _StreamListSupplier(String apiPath, ParseFunction<T> parse) {
    _broadcastStream = _createStream(apiPath, parse).asBroadcastStream();
    _anyChangeBroadcastStream = _anyChangeController.stream.asBroadcastStream();
  }
  Stream<List<T>> _createStream(String apiPath, ParseFunction<T> parse) async* {
    Stream<dynamic> stream = CachedAPI.getInstance().getStream(apiPath);
    await for (List<dynamic> snapshot in stream) {
      // if _dataList is null this first state should be yielded even if it is an empty list
      bool addedOrRemoved = _dataList == null;
      bool anyChange = false;
      List<T> dataList = _dataList ??= [];
      dataList.retainWhere((element) {
        bool result = snapshot.any((json) => json["_id"] == element.id);
        addedOrRemoved = addedOrRemoved || !result;
        return result;
      });
      for (Map<String, dynamic> json in snapshot) {
        try {
          final element =
              dataList.firstWhere((element) => element.id == json["_id"]);
          if (element.updateJSON(json)) {
            anyChange = true;
          }
        } catch (e) {
          dataList.add(parse(json));
          addedOrRemoved = true;
        }
      }
      anyChange = anyChange || addedOrRemoved;
      _anyChangeController.add(dataList);
      if (addedOrRemoved) {
        yield dataList;
      }
    }
  }

  Stream<List<T>> getStream() {
    late StreamController<List<T>> controller;
    onListen() {
      final dataList = _dataList;
      if (dataList != null) {
        controller.add(dataList);
      }
      controller.addStream(_broadcastStream);
    }

    onCancel() {
      controller.close();
    }

    controller = StreamController(
      onListen: onListen,
      onCancel: onCancel,
    );
    return controller.stream;
  }

  /// Fires an event even if the list itself does not change but only the elements in it.
  Stream<List<T>> getAnyChangeStream() {
    late StreamController<List<T>> controller;
    onListen() {
      final dataList = _dataList;
      if (dataList != null) {
        controller.add(dataList);
      }
      controller.addStream(_anyChangeBroadcastStream);
    }

    onCancel() {
      controller.close();
    }

    controller = StreamController(
      onListen: onListen,
      onCancel: onCancel,
    );
    return controller.stream;
  }
}
