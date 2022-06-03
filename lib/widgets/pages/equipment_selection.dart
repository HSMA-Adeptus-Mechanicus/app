import 'package:flutter/material.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';
import 'package:http/http.dart' as http;
import 'package:sff/utils/image_tools.dart';

class EquipmentSelection extends StatelessWidget {
  const EquipmentSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: first(data.getItemsStream()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Item> items = snapshot.data!;
            Map<String, List<Item>> byCategory = {};
            for (var item in items) {
              byCategory[item.category] ??= [];
              byCategory[item.category]?.add(item);
            }
            var categories = byCategory.entries;
            return DefaultTabController(
              length: categories.length,
              child: Scaffold(
                appBar: TabBar(
                  isScrollable: true,
                  tabs: categories.map((e) => Tab(child: Text(e.key))).toList(),
                ),
                body: TabBarView(
                  children: categories
                      .map((e) => ItemSelection(e.value))
                      .toList(),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class ItemSelection extends StatelessWidget {
  const ItemSelection(
    this._items, {
    Key? key,
  }) : super(key: key);

  final List<Item> _items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        childAspectRatio: 1 / 1,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return ItemButton(_items[index]);
      },
    );
  }
}

class ItemButton extends StatelessWidget {
  const ItemButton(
    this._item, {
    Key? key,
  }) : super(key: key);

  final Item _item;

  @override
  Widget build(BuildContext context) {
    var image = () async {
      var response = await http.get(Uri.parse(_item.url));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception();
      }
      var data = response.bodyBytes;
      var image = cropImageData(data);
      if (image != null) {
        return toImageWidget(image);
      }
      return null;
    }();

    const double padding = 10;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            vertical: 8 + padding, horizontal: padding),
      ),
      onPressed: () {},
      child: FutureBuilder<Image?>(
        future: image,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
