import 'package:flutter/material.dart';
import 'package:sff/data/model/item.dart';
import 'package:sff/navigation.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/utils/image_tools.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:sff/widgets/pages/reward/shaker.dart';

class RewardChest extends StatelessWidget {
  const RewardChest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: data.getCurrentUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!;
          return GestureDetector(
            onTap: () async {
              if (user.currency >= 15) {
                navigateToWidget(
                  NewItemScreen(user: user),
                );
              } else {
                const snackBar =
                    SnackBar(content: Text("You don't have enough coins!"));
                ScaffoldMessenger.of(navigatorKey.currentContext!)
                    .showSnackBar(snackBar);
              }
            },
            child: Shaker(
              shake: user.currency >= 15,
              child: Image.asset("assets/icons/Pixel/Schatzkiste1.png",
                  filterQuality: FilterQuality.none, scale: 1 / 2),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class NewItemScreen extends StatelessWidget {
  const NewItemScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    bool duplicate = false;
    return AppScaffold(
      body: FutureBuilder<Item>(
        future: () async {
          final item = await Item.itemRandomizer();
          duplicate = user.ownsItem(item);
          user.buy(item);
          return item;
        }(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final item = snapshot.data!;
          return GestureDetector(
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
                    return const SizedBox.shrink();
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
          );
        },
      ),
    );
  }
}
