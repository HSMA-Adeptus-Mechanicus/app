import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sff/data/item.dart';
import 'package:sff/navigation.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/screens/app_frame.dart';
import 'package:sff/screens/pages/reward_screen.dart';
import 'package:sff/utils/image_tools.dart';
import 'package:sff/widgets/app_scaffold.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => RandomizerWidgetGesture();
}

class RandomizerWidgetGesture extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () async {
          User user = await data.getCurrentUser();
          if (user.currency > 14) {
            final item = (await Item.itemRandomizer())..buy();
            if ((await (await data.getCurrentUser()).getInventory())
                .contains(item)) {
              navigateToWidget(
                AppScaffold(
                  body: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: toImageWidget((await cropImageData(
                              await item.getImageData()))!),
                        ),
                        Image.asset(
                          "assets/icons/Pixel/Schatzkiste2.png",
                          filterQuality: FilterQuality.none,
                          scale: 1,
                        ),
                        const Text(
                            "Aber leider hast du das Item schon. Hier hast du eine (1) Münze zurück. Kauf dir ein Eis davon.")
                      ],
                    ),
                  ),
                ),
              );
            } else if ((await (await data.getCurrentUser()).getInventory())
                    .contains(item) ==
                false) {
              navigateToWidget(
                AppScaffold(
                  body: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: toImageWidget((await cropImageData(
                              await item.getImageData()))!),
                        ),
                        Image.asset(
                          "assets/icons/Pixel/Schatzkiste2.png",
                          filterQuality: FilterQuality.none,
                          scale: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          } else {
            const snackBar =
                SnackBar(content: Text("You DON'T have enough coins!"));
            ScaffoldMessenger.of(navigatorKey.currentContext!)
                .showSnackBar(snackBar);
          }
        },
        child: Image.asset("assets/icons/Pixel/Schatzkiste1.png",
            filterQuality: FilterQuality.none),
      ),
    );
  }
}
