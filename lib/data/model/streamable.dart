import 'dart:async';

import 'package:flutter/material.dart';

abstract class Streamable<T extends Streamable<T>> {
  final String id;
  final StreamController<T> _controller = StreamController();
  late final Stream<T> _broadcastStream;

  Streamable(this.id) {
    _broadcastStream = _controller.stream.asBroadcastStream();
  }

  /// processes new json data and if it changed returns true
  @protected
  bool processUpdatedJSON(Map<String, dynamic> json);

  void updateJSON(Map<String, dynamic> json) {
    if (json["_id"] != id) {
      throw Exception("The supplied JSON object is not a version of this object");
    }
    try {
      if (processUpdatedJSON(json)) {
        _controller.add(this as T);
      }
    } catch (e) {
      // TODO: add debug warning
    }
  }

  @protected
  void updateStream() {
    _controller.add(this as T);
  }

  Stream<T> asStream() {
    late StreamController<T> controller;
    onListen() {
      controller.add(this as T);
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
}
