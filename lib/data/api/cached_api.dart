import 'dart:async';

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
      final value = _storage.read<Map<String, dynamic>>(path)?["data"];
      if (value != state) {
        state = value;
        controller.add(value);
      }
    }

    onListen() {
      _storage.listenable.addListener(onUpdate);
      final value = _storage.read<Map<String, dynamic>>(path);
      if (value != null) {
        controller.add(value["data"]);
      }
      requestIfOutdated(path).ignore();
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
    return controller.stream;
  }

  /// Gets the data at path, first trying the cache, but if it does not exist or is outdated trying the API.
  /// If the API fails it goes back to the cache.
  Future<dynamic> get(String path) async {
    try {
      return await requestIfOutdated(path);
    } catch (e) {
      return await getCached(path);
    }
  }

  /// Gets the data at path, first trying the API and falling back to the cache.
  Future<dynamic> getAPIFirst(String path) async {
    try {
      return await request(path);
    } catch (e) {
      return await getCached(path);
    }
  }

  /// Gets the data at path, first trying the cache and falling back to the API.
  Future<dynamic> getCacheFirst(String path) async {
    try {
      return await getCached(path);
    } catch (e) {
      return await request(path);
    }
  }

  /// Gets the data from the cache only.
  Future<dynamic> getCached(String path) async {
    await _storage.initStorage;
    final result = _storage.read<Map<String, dynamic>>(path);
    if (result == null) {
      throw Exception("The data is not cached");
    }
    return result["data"];
  }

  Future<dynamic> requestIfOutdated(String path,
      {int maxMillisecondsAge = 30 * 1000}) async {
    await _storage.initStorage;
    final result = _storage.read<Map<String, dynamic>>(path);
    if (result == null ||
        result["time"] <
            DateTime.now().millisecondsSinceEpoch - maxMillisecondsAge) {
      return await request(path);
    }
    return result["data"];
  }

  Set<String> requestsInProgress = {};

  /// Requests the data from the API and caches it.
  Future<dynamic> request(String path) async {
    if (requestsInProgress.contains(path)) {
      throw Exception("Concurrent requests to the same data ($path) are not allowed");
    }
    requestsInProgress.add(path);
    try {
      final value = await authAPI.get(path);
      await _storage.write(
          path, {"data": value, "time": DateTime.now().millisecondsSinceEpoch});
      return value;
    } finally {
      requestsInProgress.remove(path);
    }
  }
}
