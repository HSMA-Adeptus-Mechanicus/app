import 'package:sff/screens/pages/reward_screen.dart';
import 'package:sff/screens/pages/equip_screen.dart';
import 'package:sff/screens/pages/ticket_screen.dart';
import 'package:sff/screens/pages/team_screen.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({Key? key}) : super(key: key);

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  int _selectedIndex = 0;
  late TabController _controller;

  @override
  Widget build(BuildContext context) {
    _controller.index = _selectedIndex;

    Color? itemColor = Theme.of(context).colorScheme.onSurface;

    return AppScaffold(
      // TODO: prevent app scaffold and thereby the app bar with the avatar to be rebuild when a different tab is selected causing the avatar to flicker
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: const [
          TeamScreen(),
          TicketScreen(),
          EquipScreen(),
          RewardScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        fixedColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: itemColor.withAlpha(140),
        items: [
          createNavigationItem(
            icon: "assets/icons/Navigation/home_weiss.png",
            label: "Home",
          ),
          createNavigationItem(
            icon: "assets/icons/Navigation/quests_weiss.png",
            label: "Quests",
          ),
          createNavigationItem(
            icon: "assets/icons/Navigation/kleiderbuegel_weiss.png",
            label: "Inventar",
          ),
          createNavigationItem(
            icon: "assets/icons/Navigation/schatzkiste_weiss.png",
            label: "Belohnungen",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _controller.animateTo(index,
                duration: const Duration(milliseconds: 200));
          });
        },
      ),
    );
  }
}

//boolStream ob ein Punkt angezeigt werden soll, oder nicht
//Punkt mit Stack und Positioned
BottomNavigationBarItem createNavigationItem(
    {required String icon, required String label}) {
  return BottomNavigationBarItem(
    icon: NavigationIcon(iconAsset: icon, active: false),
    label: label,
    activeIcon: NavigationIcon(iconAsset: icon, active: true),
  );
}

class NavigationIcon extends StatelessWidget {
  final bool active;
  final String iconAsset;

  const NavigationIcon(
      {Key? key, required this.iconAsset, required this.active})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Image.asset(
        active ? iconAsset.replaceFirst(RegExp(r"weiss"), "orange") : iconAsset,
        fit: BoxFit.scaleDown,
        height: 20,
      ),
    );
  }
}
