import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("tickets");

    return StreamBuilder(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        if (snapshot.hasData) {
          var event = snapshot.data as DatabaseEvent;
          if (event.snapshot.value is Map<String, dynamic>) {
            var data = event.snapshot.value as Map<String, dynamic>;
            var tickets = data.values.toList();
            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Text(tickets[index]["name"]),
                      Text(tickets[index]["duration"].toString()),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No Tickets"));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
