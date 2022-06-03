import 'dart:async';
import 'dart:convert';

import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:get_storage/get_storage.dart';

class CachedAPI {
  static CachedAPI? _cachedAPI;

  static CachedAPI getInstance() {
    _cachedAPI ??= CachedAPI();
    return _cachedAPI!;
  }

  final GetStorage _storage = GetStorage("APICache");

  CachedAPI() {
    // When logging out, delete information stored from requests authorized by the user.
    UserAuthentication.getInstance()
        .getStateStream()
        .where((state) => state == LoginState.loggedOut)
        .listen((state) => _storage.erase());
  }

  /// Get stream to the data requested at the specified path.
  /// When listening initially the cached data (if available) is added to the stream.
  /// Whenever a new data has been requested at this path a new event is added to the stream.
  /// Also a request is triggered when listening to the stream.
  Stream<dynamic> getStream(String path) {
    late StreamController<dynamic> controller;
    dynamic state;
    onUpdate() {
      if (state != _storage.listenable.state?[path]) {
        state = _storage.listenable.state?[path];
        if (state != null) {
          controller.add(jsonDecode(state));
        }
      }
    }

    onListen() {
      _storage.listenable.addListener(onUpdate);
      final value = _storage.read(path);
      if (value != null) {
        controller.add(jsonDecode(value));
      }
      request(path);
    }

    onResume() {
      _storage.listenable.addListener(onUpdate);
    }

    onStopListen() {
      _storage.listenable.removeListener(onUpdate);
    }

    controller = StreamController(
      onListen: onListen,
      onPause: onStopListen,
      onResume: onResume,
      onCancel: onStopListen,
    );
    onUpdate();
    return controller.stream;
  }

  /// Gets the the data at path, first trying the API and falling back to the cache.
  Future<dynamic> get(String path) async {
    try {
      return await request(path);
    } catch (e) {
      return await getCached(path);
    }
  }

  /// Gets the data from the cache only.
  Future<dynamic> getCached(String path) async {
    await _storage.initStorage;
    final result = _storage.read<String>(path);
    if (result == null) {
      throw Exception("The data is not cached");
    }
    return jsonDecode(result);
  }

  /// Requests the data from the API and caches it.
  Future<dynamic> request(String path) async {
    final value = await authAPI.get(path);
    await _storage.write(path, jsonEncode(value));
    return value;
  }
}
