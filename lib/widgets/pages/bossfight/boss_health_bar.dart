import 'dart:math';
import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BossHealthBar extends StatelessWidget {
  const BossHealthBar({
    Key? key,
    required this.health,
  }) : super(key: key);

  final double health;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: () async {
        final imageData =
            await rootBundle.load("assets/icons/Pixel/Lebensbalken.png");
        return decodeImageFromList(imageData.buffer.asUint8List());
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            painter: _BossBarPainter(snapshot.data!, health),
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _BossBarPainter extends CustomPainter {
  final ui.Image image;
  final double healthPercentage;

  _BossBarPainter(this.image, this.healthPercentage);

  @override
  void paint(Canvas canvas, Size size) {
    double pixelSize = size.width / 89;
    double offsetLeft = 12;
    double barWidth = (89 - offsetLeft - 1) * pixelSize;
    double barHeight = (14 - 3 - 3) * pixelSize;

    // TODO: refactor
    canvas.drawRect(
      Rect.fromLTWH(offsetLeft * pixelSize, 3 * pixelSize,
          (89 - offsetLeft - 2) * pixelSize, barHeight),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(offsetLeft * pixelSize, 5 * pixelSize, barWidth,
          (14 - 5 - 5) * pixelSize),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(
          offsetLeft * pixelSize,
          3 * pixelSize,
          min(healthPercentage * barWidth, (89 - offsetLeft - 2) * pixelSize),
          barHeight),
      Paint()..color = const Color.fromARGB(255, 210, 0, 0),
    );
    canvas.drawRect(
      Rect.fromLTWH(offsetLeft * pixelSize, 5 * pixelSize,
          healthPercentage * barWidth, (14 - 5 - 5) * pixelSize),
      Paint()..color = const Color.fromARGB(255, 210, 0, 0),
    );
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, image.height / image.width * size.width),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
