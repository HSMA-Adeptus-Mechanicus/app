import 'dart:async';

import 'package:sff/data/data.dart';
import 'package:sff/data/ticket.dart';

Future<int> currentHealthBarCalculator() async {
  List<Ticket> ticketArray = await first(data.getTicketsStream());
  var currentHealth = 0;
  for (int i = 0; i <= ticketArray.length; i++) {
    if (ticketArray[i].done) {
      currentHealth++;
    }
  }

  return currentHealth;
}

Future<int> maxHealthBarCalculator() async {
  List<Ticket> ticketArray = await first(data.getTicketsStream());
  var maxHealth = ticketArray.length;

  return maxHealth;
}
