import 'dart:async';
import 'dart:convert';

import 'package:app/data/api/authenticated_api.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

Future<T> firstSuccess<T>(List<Future<T>> futures) {
  Completer<T> completer = Completer();
  int resolved = 0;
  for (var future in futures) {
    future.then((value) {
      completer.complete(value);
    }).whenComplete(() {
      resolved++;
    }).onError((error, stackTrace) {
      if (resolved == futures.length) {
        completer.completeError(error ?? Error());
      }
    });
  }
  return completer.future;
}

class CachedAPI {
  static CachedAPI? _cachedAPI;

  static CachedAPI getInstance() {
    _cachedAPI ??= CachedAPI();
    return _cachedAPI!;
  }

  final GetStorage _storage = GetStorage("APICache");

  Stream<dynamic> getStream(String path) {
    late StreamController<dynamic> controller;
    dynamic state;
    onUpdate() {
      if (state != _storage.listenable.state?[path]) {
        state = _storage.listenable.state?[path];
        controller.add(jsonDecode(state));
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

  Future<dynamic> get(String path) async {
    try {
      return await request(path);
    } catch (e) {
      return await getCached(path);
    }
  }

  Future<dynamic> getCached(String path) async {
    await _storage.initStorage;
    final result = _storage.read<String>(path);
    if (result == null) {
      throw ErrorDescription("The data is not cached");
    }
    return jsonDecode(result);
  }

  Future<dynamic> request(String path) async {
    final value = await authAPI.get(path);
    await _storage.write(path, jsonEncode(value));
    return value;
  }
}
