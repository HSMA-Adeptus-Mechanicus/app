import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sff/data/item.dart';
import 'package:sff/navigation.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';

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
            (await itemRandomizer()).buy();
          } else {
            const snackBar =
                SnackBar(content: Text("You DON'T have enough coins!"));
            ScaffoldMessenger.of(navigatorKey.currentContext!)
                .showSnackBar(snackBar);
          }
        },
        child: const Text("hier bin ich"),
      ),
    );
  }
}

Future<Item> itemRandomizer() async {
  List<Item> itemArray = await first(data.getItemsStream());
  var rng = Random().nextInt(itemArray.length);
  return itemArray[rng];
}
