import 'package:sff/data/api/cached_api.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/ticket.dart';
import 'package:flutter/material.dart';
import 'package:sff/utils/stable_sort.dart';
import 'package:sff/widgets/border_card.dart';

class TicketList extends StatelessWidget {
  final bool onlyOwnTickets;

  const TicketList({Key? key, this.onlyOwnTickets = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await CachedAPI.getInstance().request("db/tickets");
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
                titleMedium: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black),
                titleLarge: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black),
              ),
        ),
        child: StreamBuilder<List<Ticket>>(
          stream: data.getTicketsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Ticket> tickets = snapshot.data!;
              if (onlyOwnTickets) {
                tickets = tickets
                    .where((ticket) =>
                        ticket.assignee ==
                        UserAuthentication.getInstance().userId)
                    .toList();
              }
              if (onlyOwnTickets) {
                stableSort<Ticket>(
                    tickets,
                    (a, b) => !a.done && b.done
                        ? 1
                        : a.done && !b.done
                            ? -1
                            : 0);
                stableSort<Ticket>(
                    tickets,
                    (a, b) => a.rewardClaimed && !b.rewardClaimed
                        ? 1
                        : !a.rewardClaimed && b.rewardClaimed
                            ? -1
                            : 0);
              } else {
                stableSort<Ticket>(
                    tickets,
                    (a, b) => a.done && !b.done
                        ? 1
                        : !a.done && b.done
                            ? -1
                            : 0);
              }

              return ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return TicketItem(tickets[index],
                      allowClaimingReward: onlyOwnTickets);
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
        ),
      ),
    );
  }
}

class TicketItem extends StatelessWidget {
  final bool allowClaimingReward;

  const TicketItem(this._ticket, {Key? key, required this.allowClaimingReward})
      : super(key: key);

  final Ticket _ticket;

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: Image.asset(
                        "assets/icons/Pixel/Muenze.PNG",
                        scale: 1.0,
                      ).image,
                    ),
                    Text(
                      "${_ticket.storyPoints * 7}",
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Du erhälst + ${_ticket.storyPoints * 7} Münzen!",
                ),
              ],
            ),
          );
        },
      );
    }

    return GestureDetector(
      child: ElevatedButton(
        onPressed: () {
          //_showMyDialog();
          if (!allowClaimingReward) return;
          if (!_ticket.rewardClaimed && _ticket.done) {
            _ticket.claimReward();
            _showMyDialog();
          }
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          side: const BorderSide(
            style: BorderStyle.none,
          ),
        ),
        child: BorderCard(
          color: _ticket.done
              ? _ticket.rewardClaimed || !allowClaimingReward
                  ? Theme.of(context).colorScheme.background
                  : Colors.green
              : Theme.of(context).cardColor,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _ticket.assignedUser.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Divider(
                  height: 10,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                Text(
                  _ticket.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(_ticket.description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_ticket.storyPoints.toString()),
                    Text(allowClaimingReward
                        ? _ticket.done
                            ? _ticket.rewardClaimed
                                ? "Belohnung abgeholt"
                                : "Belohnung abholen"
                            : "In Bearbeitung"
                        : _ticket.done
                            ? "Fertig"
                            : "In Bearbeitung"),

                    /*
                    ticket.done
              ? _ticket.rewardClaimed || !allowClaimingReward
                  ? Theme.of(context).colorScheme.background
                  : Colors.green
              : Theme.of(context).cardColor,*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
