import 'package:flutter/material.dart';
import 'package:sff/widgets/button_tab_bar.dart';
import 'package:sff/widgets/fitted_text.dart';
import 'package:sff/widgets/pages/ticket_list.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: const [
          ButtonTabBar(
            tabs: [
              Tab(child: FittedText("Meine Quests")),
              Tab(child: FittedText("Team Quests")),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                TicketList(onlyOwnTickets: true),
                TicketList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
