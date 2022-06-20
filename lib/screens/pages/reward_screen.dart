import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2(
        streams: Tuple2(
            UserAuthentication().getUsernameStream(), data.getUsersStream()),
        builder: (context, snapshot) {
          String username = snapshot.item1.data as String;
          User user = (snapshot.item2.data as List<User>)
              .where(
                  (user) => UserAuthentication.getInstance().userId == user.id)
              .first;
          //return Text("Username: $username\nCoins: ${user.currency}");
          return Padding(
            padding: EdgeInsets.fromLTRB(
                13.0, 25.0, 0.0, 0.0), //EdgeInset Top 24.0 but left only 10.0
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      Image(
                        image: Image.asset(
                          "assets/icons/Pixel/Muenze.PNG",
                          scale: 1.3,
                        ).image,
                      ),
                      SizedBox(width: 7.0),
                      const Text(
                        "30",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80.0),
                  Row(
                    children: [
                      Text(
                        " Du hast ${user.currency} Münzen\n gesammelt, ${username}!\n Hol dir dein neues Item!",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
