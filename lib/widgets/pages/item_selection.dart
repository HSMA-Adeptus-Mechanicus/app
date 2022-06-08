import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';
import 'package:sff/data/user.dart';
import 'package:sff/utils/image_tools.dart';

class ItemSelectionByCategory extends StatelessWidget {
  final List<String> categories;

  const ItemSelectionByCategory({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: TabBar(
          isScrollable: true,
          tabs: categories.map((e) => Tab(child: Text(e))).toList(),
        ),
        body: TabBarView(
          children: categories.map((e) => _ItemSelection(category: e)).toList(),
        ),
      ),
    );
  }
}

class _ItemSelection extends StatelessWidget {
  final String category;

  const _ItemSelection({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
      stream: data.getItemsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Item> items = snapshot.data!
              .where((element) => element.category == category)
              .toList();
          return StreamBuilder<List<User>>(
            stream: data.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data!.firstWhere((user) =>
                    user.name == UserAuthentication.getInstance().username);
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _ItemButton(
                      user: user,
                      item: items[index],
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return ErrorWidget(snapshot.error!);
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _ItemButton extends StatelessWidget {
  const _ItemButton({
    Key? key,
    required this.user,
    required this.item,
  }) : super(key: key);

  final User user;
  final Item item;

  @override
  Widget build(BuildContext context) {
    var image = () async {
      var response = await http.get(Uri.parse(item.url));
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

    final imageWidget = FutureBuilder<Image?>(
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
    );

    const paddingStyle =
        EdgeInsets.symmetric(vertical: 8 + padding, horizontal: padding);

    onPressed() {
      if (user.avatar.isEquipped(item)) {
        Avatar.unequip(item);
      } else {
        Avatar.equip(item);
      }
    }

    if (user.avatar.isEquipped(item)) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: paddingStyle,
        ),
        onPressed: onPressed,
        child: imageWidget,
      );
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: paddingStyle,
        ),
        onPressed: onPressed,
        child: imageWidget,
      );
    }
  }
}