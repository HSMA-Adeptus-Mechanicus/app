import 'package:flutter/material.dart';
import 'package:sff/data/api/cached_api.dart';
import 'package:sff/widgets/button_tab_bar.dart';
import 'package:sff/widgets/pages/all_tickets.dart';
import 'package:sff/widgets/pages/own_tickets.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await CachedAPI.getInstance().request("db/tickets");
      },
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: const [
            ButtonTabBar(
              tabs: [
                Tab(child: Text("Meine Tickets")),
                Tab(child: Text("Team Tickets")),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OwnTickets(),
                  AllTickets(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
