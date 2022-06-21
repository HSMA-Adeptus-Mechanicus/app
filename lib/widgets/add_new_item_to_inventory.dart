import 'package:flutter/material.dart';
import 'package:sff/data/item.dart';
import 'package:sff/navigation.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/utils/image_tools.dart';
import 'package:sff/widgets/app_scaffold.dart';

class RandomizerWidget extends StatefulWidget {
  const RandomizerWidget({Key? key}) : super(key: key);

  @override
  State<RandomizerWidget> createState() => RandomizerWidgetGesture();
}

class RandomizerWidgetGesture extends State<RandomizerWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                        child: toImageWidget(
                            (await cropImageData(await item.getImageData()))!),
                      ),
                      Image.asset(
                        "assets/icons/Pixel/Schatzkiste2.png",
                        filterQuality: FilterQuality.none,
                        scale: 1,
                      ),
                      Row(
                        children: const [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Text(
                                "Aber leider hast du das Item schon. Hier hast du eine (1) Münze zurück. Kauf dir ein Eis davon.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
                        child: toImageWidget(
                            (await cropImageData(await item.getImageData()))!),
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
              SnackBar(content: Text("You don't have enough coins!"));
          ScaffoldMessenger.of(navigatorKey.currentContext!)
              .showSnackBar(snackBar);
        }
      },
      child: Image.asset("assets/icons/Pixel/Schatzkiste1.png",
          filterQuality: FilterQuality.none),
    );
  }
}
