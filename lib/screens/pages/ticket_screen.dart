import 'package:sff/data/data.dart';
import 'package:sff/data/ticket.dart';
import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: data.getTicketsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Ticket> tickets = snapshot.data as List<Ticket>;
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return TicketItem(tickets[index]);
            },
            separatorBuilder: (context, int) {
              return const SizedBox(
                height: 7,
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
}

class TicketItem extends StatelessWidget {
  const TicketItem(this._ticket, {Key? key}) : super(key: key);

  final Ticket _ticket;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_ticket.name),
            Text(_ticket.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_ticket.storyPoints.toString()),
                Text(_ticket.done ? "done" : "in progress"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
