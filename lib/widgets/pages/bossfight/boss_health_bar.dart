import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BossHealthBar extends StatelessWidget {
  const BossHealthBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: () async {
        final data =
            await rootBundle.load("assets/icons/Pixel/Lebensbalken.png");
        return decodeImageFromList(data.buffer.asUint8List());
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            painter: _BossBarPainter(snapshot.data!),
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

  _BossBarPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    double percentage = 0.7;
    double pixelSize = size.width / 89;
    double offsetLeft = 12;
    double barWidth = (89 - offsetLeft - 1) * pixelSize;
    double barHeight = (14 - 3 - 3) * pixelSize;
    canvas.drawRect(
      Rect.fromLTWH(offsetLeft * pixelSize, 3 * pixelSize, barWidth, barHeight),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      Rect.fromLTWH(offsetLeft * pixelSize, 3 * pixelSize,
          barWidth * percentage, barHeight),
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
