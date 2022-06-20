import 'dart:math';
import 'dart:async';

import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';

Future<Item> itemRandomizer() async {
  List<Item> itemArray = await first(data.getItemsStream());
  var rng = Random().nextInt(itemArray.length);
  return itemArray[rng];
}
