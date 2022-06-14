import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

List<int> addColors(List<int> a, List<int> b) {
  int newAlpha = ((1 - (1 - a[3] / 255) * (1 - b[3] / 255)) * 255).toInt();
  List<int> newColors = a
      .sublist(0, 3)
      .asMap()
      .entries
      .map(
          (e) => (e.value * (1 - b[3] / 255) + b[e.key] * (b[3] / 255)).toInt())
      .toList();
  return [...newColors, newAlpha];
}

img.Image cropImage(img.Image image) {
  int r = 0;
  int l = image.width - 1;
  int b = 0;
  int t = image.height - 1;
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int alpha = image.getPixel(x, y) >> 24;
      if (alpha != 0) {
        r = max(r, x);
        l = min(l, x);
        b = max(b, y);
        t = min(t, y);
      }
    }
  }
  var cropped = img.copyCrop(image, l, t, r - l + 1, b - t + 1);
  return cropped;
}

_cropImageWorker(SendPort sendPort) async {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  final image = await receivePort.first as Uint8List;
  final cropped = cropImage(img.decodeImage(image)!);
  sendPort.send(cropped);
}

Future<img.Image?> cropImageData(Uint8List data) async {
  bool isolateSupported = !kIsWeb;
  if (isolateSupported) {
    final receivePort = ReceivePort();
    final receiveIterator = StreamIterator(receivePort);
    await Isolate.spawn(_cropImageWorker, receivePort.sendPort);
    await receiveIterator.moveNext();
    final sendPort = await receiveIterator.current as SendPort;
    sendPort.send(data);
    await receiveIterator.moveNext();
    return await receiveIterator.current as img.Image;
  } else {
    final image = img.decodeImage(data);
    if (image != null) {
      return cropImage(image);
    }
    return null;
  }
}

Image toImageWidget(img.Image image) {
  return Image.memory(
    Uint8List.fromList(img.encodePng(image)),
    scale: 1 / 10,
    filterQuality: FilterQuality.none,
  );
}
