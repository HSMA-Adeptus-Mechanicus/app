import 'dart:math';
import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sff/data/data.dart';

class BossHealthBar extends StatelessWidget {
  const BossHealthBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = 0;
    return FutureBuilder<ui.Image>(
      future: () async {
        final imageData =
            await rootBundle.load("assets/icons/Pixel/Lebensbalken.png");
        percentage = await (await first(data.getSprintsStream()))
            .first
            .calculateHealthPercentage();
        return decodeImageFromList(imageData.buffer.asUint8List());
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            painter: _BossBarPainter(snapshot.data!, percentage),
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const SizedBox();
      },
    );
  }
}

class _BossBarPainter extends CustomPainter {
  final ui.Image image;
  final double percentage;

  _BossBarPainter(this.image, this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    double pixelSize = size.width / 89;
    double offsetLeft = 12;
    double barWidth = (89 - offsetLeft - 1) * pixelSize;
    double barHeight = (14 - 3 - 3) * pixelSize;
    canvas.drawRect(
      Rect.fromLTWH(offsetLeft * pixelSize, 3 * pixelSize,
          (89 - offsetLeft - 2) * pixelSize, barHeight),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(offsetLeft * pixelSize, 5 * pixelSize,
          (89 - offsetLeft - 1) * pixelSize, (14 - 5 - 5) * pixelSize),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(
          offsetLeft * pixelSize,
          3 * pixelSize,
          min(percentage * (89 - offsetLeft - 1) * pixelSize,
              (89 - offsetLeft - 2) * pixelSize),
          barHeight),
      Paint()..color = Colors.red,
    );
    canvas.drawRect(
      Rect.fromLTWH(
          offsetLeft * pixelSize,
          5 * pixelSize,
          percentage * (89 - offsetLeft - 1) * pixelSize,
          (14 - 5 - 5) * pixelSize),
      Paint()..color = Colors.red,
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
