import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:sff/data/api/authenticated_api.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/data.dart';

class Item {
  const Item(this.id, this.category, this.url);
  final String id;
  final String category;
  final String url;
  static Item fromJSON(Map<String, dynamic> json) {
    return Item(json["_id"], json["category"], json["url"]);
  }

  static clearCache() async {
    await _ItemImageCache.getInstance().clearCache();
  }

  static Future<Item> itemRandomizer() async {
    List<Item> itemArray = await first(data.getItemsStream());
    itemArray =
        itemArray.where((element) => element.category != "hand").toList();
    var rng = Random().nextInt(itemArray.length);
    return itemArray[rng];
  }

  Future<Uint8List> getImageData() async {
    return await _ItemImageCache.getInstance().getImage(url);
  }

  Future<void> buy() async {
    await authAPI.post("db/items/buy/$id", null);
    CachedAPI.getInstance().request("db/users").ignore();
  }

  bool operator ==(Object other) {
    if (other is! Item) return false;
    return id == other.id;
  }
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
