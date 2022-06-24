import 'package:flutter/material.dart';
import 'package:sff/data/data.dart';
import 'package:sff/widgets/pages/bossfight/boss_health_bar.dart';

class Boss extends StatelessWidget {
  const Boss({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: StreamBuilder<double>(
            stream: data
                .getSprintsStream()
                .map((event) => event.first)
                .asyncMap((event) async => event.calculateHealthPercentage()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final health = snapshot.data!;
                const bossImages = [
                  "assets/boss/Boss2_3.png",
                  "assets/boss/Boss2_2.png",
                  "assets/boss/Boss2_1.png",
                ];
                final bossImage = bossImages[(bossImages.length * health)
                    .toInt()
                    .clamp(0, bossImages.length - 1)];
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: 20,
                        width: constraints.maxWidth * 0.7,
                        child: BossHealthBar(health: health),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * 0.65,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: constraints.maxHeight * 0.55,
                            child: Image.asset(
                              bossImage,
                              filterQuality: FilterQuality.none,
                              scale: 1 / 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
