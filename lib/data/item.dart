class Item {
  const Item(this.id, this.category, this.url);
  final String id;
  final String category;
  final String url;
  static Item fromJSON(Map<String, dynamic> json) {
    return Item(json["_id"], json["category"], json["url"]);
  }
}
