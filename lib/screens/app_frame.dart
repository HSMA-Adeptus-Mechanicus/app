import 'package:sff/screens/pages/avatar_screen.dart';
import 'package:sff/screens/pages/equip_screen.dart';
import 'package:sff/screens/pages/ticket_screen.dart';
import 'package:sff/screens/pages/team_screen.dart';
import 'package:sff/widgets/custom_app_bar.dart';
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

    Color? itemColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: TabBarView(
        controller: _controller,
        children: const [
          TeamScreen(),
          TicketScreen(),
          EquipScreen(),
          AvatarScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        fixedColor: itemColor,
        unselectedItemColor: itemColor?.withAlpha(100),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.takeout_dining),
            label: "Tickets",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: "Equip",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Avatar",
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
