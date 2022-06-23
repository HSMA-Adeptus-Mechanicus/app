import 'dart:async';

import 'package:flutter/material.dart';

abstract class Streamable<T> {
  final String id;
  final StreamController<T> _controller = StreamController();
  late final Stream<T> _broadcastStream;

  Streamable(this.id) {
    _broadcastStream = _controller.stream.asBroadcastStream();
  }

  /// processes new json data and if it changed returns true
  @protected
  bool processUpdatedJSON(dynamic json);

  
  updateJSON(dynamic json) {
    try {
      if (processUpdatedJSON(json))
      {
        
      }
    } catch (e) {
      // 
    }
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
