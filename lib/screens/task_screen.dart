import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref("counter");

    return StreamBuilder(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        }
        if (snapshot.hasData) {
          var event = snapshot.data as DatabaseEvent;
          double data = event.snapshot.value as double;
          return Center(
            child: Text("test: $data"),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
