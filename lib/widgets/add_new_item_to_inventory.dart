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
  State<MyStatefulWidget> createState() => randomizerWidgetGesture();
}

class randomizerWidgetGesture extends State<MyStatefulWidget> {
  //HIER IF-ABFRAGE AN DIE MÜNZEN MACHEN UND ABZIEHEN!
  //Und halt pop up o.ä. um zu zeigen, was du gedroppt hast
  //What the fuck is this even

  Future<void> addItemToInventory(Item addedItem) async {
    List<User> allUsers = await first(data.getUsersStream());
    User currentUser;

    for (int i = 0; i <= allUsers.length; i++) {
      if (allUsers[i].id == UserAuthentication.getInstance().userId) {
        currentUser = allUsers[i];

        List<Item> inventory = await currentUser.getInventory();

        inventory.add(addedItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () async {
            addItemToInventory(await itemRandomizer());
          },
        ),
      ),
    );
  }
}
