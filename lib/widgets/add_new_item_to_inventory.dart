import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sff/widgets/item_randomizer.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';
import 'package:sff/data/user.dart';
import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/api/user_authentication.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => RandomizerWidgetGesture();
}

class RandomizerWidgetGesture extends State<MyStatefulWidget> {
  Future<void> addItemToInventory(Item addedItem) async {
    User currentUser = await data.getCurrentUser();
    List<Item> inventory = await currentUser.getInventory();
    inventory.add(addedItem);
    //how to write this into Back End?
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () async {
            User helperUser = await data.getCurrentUser();
            if (helperUser.currency > 14) {
              addItemToInventory(await itemRandomizer());
              print("You HAVE enough coins!");
              //Subtract 15 from User Coins HOW
            } else {
              final snackBar =
                  SnackBar(content: const Text('You DONT have enough coins!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: const Text("hier bin ich"),
        ),
      ),
    );
  }
}
