import 'package:flutter/material.dart';
import 'package:sff/data/item.dart';
import 'package:sff/navigation.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/utils/image_tools.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/shaker.dart';

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
              NewItemScreen(item: item, duplicate: true),
            );
          } else if ((await (await data.getCurrentUser()).getInventory())
                  .contains(item) ==
              false) {
            navigateToWidget(
              NewItemScreen(item: item),
            );
          }
        } else {
          const snackBar =
              SnackBar(content: Text("You don't have enough coins!"));
          ScaffoldMessenger.of(navigatorKey.currentContext!)
              .showSnackBar(snackBar);
        }
      },
      child: TestAnimWidget(),
    );
  }
}

class NewItemScreen extends StatelessWidget {
  const NewItemScreen({Key? key, required this.item, this.duplicate = false})
      : super(key: key);

  final Item item;
  final bool duplicate;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
              child: FutureBuilder<Image>(future: () async {
                return toImageWidget(
                    (await cropImageData(await item.getImageData()))!);
              }(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
                return Container();
              }),
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/icons/Pixel/Schatzkiste2.png",
              filterQuality: FilterQuality.none,
              scale: 1,
            ),
            ...(duplicate
                ? [
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text(
                              "Oh! Du hast das Item leider schon. Hier hast du eine Münze wieder.",
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
                  ]
                : []),
          ],
        ),
      ),
    );
  }
}
