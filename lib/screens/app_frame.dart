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
    _controller.addListener(_updateIndex);
  }

  int _selectedIndex = 0;
  late TabController _controller;

  void _updateIndex() {
    setState(() {
      _selectedIndex = _controller.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_updateIndex);
  }

  @override
  Widget build(BuildContext context) {
    _controller.index = _selectedIndex;

    Color? itemColor = Theme.of(context).colorScheme.onSurface;

    return AppScaffold(
      body: TabBarView(
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

BottomNavigationBarItem createNavigationItem(
    {required String icon, required String label}) {
  return BottomNavigationBarItem(
    icon: Padding(
      padding: const EdgeInsets.all(6),
      child: Image.asset(
        icon,
        fit: BoxFit.scaleDown,
        height: 20,
      ),
    ),
    label: label,
    activeIcon: Padding(
      padding: const EdgeInsets.all(6),
      child: Image.asset(
        icon.replaceFirst(RegExp(r"weiss"), "orange"),
        fit: BoxFit.scaleDown,
        height: 20,
      ),
    ),
  );
}
