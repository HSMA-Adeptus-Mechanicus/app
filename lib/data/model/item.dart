import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/streamable.dart';

class Item extends Streamable<Item> {
  Item(super.id, this._category, this._url);
  String _category;
  String _url;

  String get category {
    return _category;
  }

  String get url {
    return _url;
  }

  static Item fromJSON(Map<String, dynamic> json) {
    return Item(json["_id"], json["category"], json["url"]);
  }

  @override
  bool processUpdatedJSON(Map<String, dynamic> json) {
    bool change = _category != json["category"] || _url != json["url"];
    _category = json["category"];
    _url = json["url"];
    return change;
  }

  static clearCache() async {
    await _ItemImageCache.getInstance().clearCache();
  }

  static Future<Item> itemRandomizer() async {
    List<Item> itemArray = await first(data.getItemsStream());
    List<String> starterItems =
        (await CachedAPI.getInstance().get("db/items/starter") as List<dynamic>)
            .map((e) => e as String)
            .toList();
    itemArray = itemArray
        .where((element) => !starterItems.contains(element.id))
        .toList();

    itemArray =
        itemArray.where((element) => element.category != "hand").toList();

    var rng = Random().nextInt(itemArray.length);
    return itemArray[rng];
  }

  Future<Uint8List> getImageData() async {
    return await _ItemImageCache.getInstance().getImage(url);
  }

  @override
  bool operator ==(Object other) {
    if (other is! Item) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _ItemImageCache {
  static _ItemImageCache? _imageCache;

  static _ItemImageCache getInstance() {
    _imageCache ??= _ItemImageCache();
    return _imageCache!;
  }

  final GetStorage storage = GetStorage("ItemImageCache");

  clearCache() async {
    await storage.initStorage;
    await storage.erase();
  }

  Future<Uint8List> getImage(String url) async {
    await storage.initStorage;
    final cached = storage.read<List<dynamic>>(url);
    if (cached != null) {
      return Uint8List.fromList(cached.map((e) => e as int).toList());
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Image response status not ok");
    }
    final data = response.bodyBytes;
    await storage.write(url, data.toList(growable: false));
    return data;
  }
}
