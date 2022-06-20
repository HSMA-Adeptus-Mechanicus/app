import 'package:sff/data/data.dart';
import 'package:sff/data/ticket.dart';
import 'package:flutter/material.dart';

class AllTickets extends StatelessWidget {
  const AllTickets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ticket>>(
      stream: data.getTicketsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Ticket> tickets = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return AllTicketsItem(tickets[index]);
            },
            separatorBuilder: (context, index) {
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

class AllTicketsItem extends StatelessWidget {
  const AllTicketsItem(this._ticket, {Key? key}) : super(key: key);

  final Ticket _ticket;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: _ticket.done
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).cardColor,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _ticket.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Divider(
                height: 10,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              Text(_ticket.description),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_ticket.storyPoints.toString()),
                  Text(_ticket.done ? "done" : "in progress"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}