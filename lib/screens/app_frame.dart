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
        fixedColor: itemColor,
        unselectedItemColor: itemColor.withAlpha(140),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: "Quests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: "Inventar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
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
