import 'package:flutter/material.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';
import 'package:sff/data/user.dart';
import 'package:sff/utils/image_tools.dart';
import 'package:sff/utils/stable_sort.dart';
import 'package:sff/utils/string_compare.dart';

class ItemCategory {
  final String icon;
  final String category;

  ItemCategory({required this.icon, required this.category});
}

class ItemSelectionByCategory extends StatelessWidget {
  final List<ItemCategory> categories;
  final EditableAvatar avatar;

  const ItemSelectionByCategory(
      {super.key, required this.categories, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: TabBar(
          isScrollable: true,
          tabs: categories
              .map((e) => Tab(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        e.icon,
                        height: 20,
                        width: 30,
                      ),
                    ),
                  ))
              .toList(),
        ),
        body: TabBarView(
          children: categories
              .map((e) => _ItemSelection(category: e.category, avatar: avatar))
              .toList(),
        ),
      ),
    );
  }
}

class _ItemSelection extends StatelessWidget {
  final String category;
  final EditableAvatar avatar;

  const _ItemSelection({
    required this.category,
    Key? key,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> starterItems = [];
    return FutureBuilder<List<User>>(
      future: () async {
        starterItems = (await CachedAPI.getInstance()
                .getCacheFirst("db/items/starter") as List<dynamic>)
            .map((e) => e as String)
            .toList();
        return first(data.getUsersStream());
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!.firstWhere(
              (user) => user.id == UserAuthentication.getInstance().userId);
          return FutureBuilder<List<Item>>(
            future: first(data.getItemsStream()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Item> items = snapshot.data!
                    .where((element) => element.category == category)
                    .toList();
                stableSort<Item>(
                    items, (a, b) => compareStringNumbers(a.url, b.url));
                stableSort<Item>(
                    items,
                    (a, b) =>
                        (user.ownsItem(a) ? 0 : 1) -
                        (user.ownsItem(b) ? 0 : 1));
                stableSort<Item>(items,
                    (a, b) => (starterItems.contains(a.id) ? 0 : 1) - (starterItems.contains(b.id) ? 0 : 1));
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
                      avatar: avatar,
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
    required this.avatar,
  }) : super(key: key);

  final User user;
  final Item item;
  final EditableAvatar avatar;

  @override
  Widget build(BuildContext context) {
    // TODO: make it so it does not repeatedly crop the image every time an item is equipped
    final image = () async {
      final data = await item.getImageData();
      final image = await cropImageData(data);
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
        return const Center(child: CircularProgressIndicator());
      },
    );

    onPressed() {
      if (avatar.isEquipped(item)) {
        avatar.removeItem(item.category);
      } else {
        avatar.setItem(item);
      }
    }

    return StreamBuilder<Avatar>(
      stream: avatar.getStream(),
      builder: (context, snapshot) {
        var border = avatar.isEquipped(item)
            ? null
            : const BorderSide(
                width: 1,
                color: Colors.grey,
              );
        return Opacity(
          opacity: user.ownsItem(item) ? 1 : 0.25,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8 + padding,
                horizontal: padding,
              ),
              side: border,
            ),
            onPressed: user.ownsItem(item) ? onPressed : null,
            child: imageWidget,
          ),
        );
      },
    );
  }
}
