import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/item.dart';
import 'package:sff/data/user.dart';
import 'package:sff/utils/image_tools.dart';

class ItemCategory {
  final String icon;
  final String category;

  ItemCategory({required this.icon, required this.category});
}

class ItemSelectionByCategory extends StatelessWidget {
  final List<ItemCategory> categories;

  const ItemSelectionByCategory({super.key, required this.categories});

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
              .map((e) => _ItemSelection(category: e.category))
              .toList(),
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
                    user.id == UserAuthentication.getInstance().userId);
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
      // TODO: give immediate feedback when equipping items
      if (user.avatar.isEquipped(item)) {
        Avatar.unequip(item);
      } else {
        Avatar.equip(item);
      }
    }

    var border = user.avatar.isEquipped(item)
        ? BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.primary,
          )
        : null;

    return Opacity(
      opacity: user.ownsItem(item) ? 1 : 0.25,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 8 + padding,
            horizontal: padding,
          ),
          side: border,
        ),
        onPressed: onPressed,
        child: imageWidget,
      ),
    );
  }
}
