import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/project.dart';
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
            indicatorStream: () async* {
              yield* (await (await ProjectManager.getInstance())
                      .currentProject!
                      .getCurrentSprint())
                  .getAnyChangeTicketsStream()
                  .map(
                    (ticket) => ticket.any((element) =>
                        element.assignee ==
                            UserAuthentication.getInstance().userId &&
                        element.done &&
                        !element.rewardClaimed),
                  );
            }(),
          ),
          createNavigationItem(
            icon: "assets/icons/Navigation/kleiderbuegel_weiss.png",
            label: "Inventar",
          ),
          createNavigationItem(
            icon: "assets/icons/Navigation/schatzkiste_weiss.png",
            label: "Belohnungen",
            indicatorStream: () async* {
              yield* data
                  .getCurrentUserStream()
                  .map((event) => event.currency >= 15);
            }(),
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
    {required String icon,
    required String label,
    Stream<bool>? indicatorStream}) {
  Stream<bool>? broadcastStream = indicatorStream?.asBroadcastStream();
  return BottomNavigationBarItem(
    icon: NavigationIcon(
      iconAsset: icon,
      active: false,
      indicatorStream: broadcastStream,
    ),
    label: label,
    activeIcon: NavigationIcon(
      iconAsset: icon,
      active: true,
      indicatorStream: broadcastStream,
    ),
  );
}

class NavigationIcon extends StatelessWidget {
  final bool active;
  final String iconAsset;
  final Stream<bool>? indicatorStream;
  const NavigationIcon(
      {Key? key,
      required this.iconAsset,
      required this.active,
      this.indicatorStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              active
                  ? iconAsset.replaceFirst(RegExp(r"weiss"), "orange")
                  : iconAsset,
              fit: BoxFit.scaleDown,
              height: 20,
            ),
          ),
          StreamBuilder<bool>(
            stream: indicatorStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red,
                    ),
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
