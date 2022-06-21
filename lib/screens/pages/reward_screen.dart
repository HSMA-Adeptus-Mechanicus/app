import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/widgets/add_new_item_to_inventory.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2(
        streams: Tuple2(
            UserAuthentication().getUsernameStream(), data.getUsersStream()),
        builder: (context, snapshot) {
          if (snapshot.item1.hasData && snapshot.item2.hasData) {
            String username = snapshot.item1.data as String;
            User user = (snapshot.item2.data as List<User>)
                .where((user) =>
                    UserAuthentication.getInstance().userId == user.id)
                .first;
            //return Text("Username: $username\nCoins: ${user.currency}");
            return Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 25.0, 0.0, 0.0),
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
                        const SizedBox(width: 7.0),
                        Text(
                          "${user.currency}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80.0),
                    Row(
                      children: [
                        // 15 sollte keine magic number sein
                        Text(
                          " Du hast ${user.currency} Münzen\n gesammelt, $username!\n ${user.currency >= 15 ? "Hol dir dein neues Item!" : "Dir fehlen ${15 - user.currency} Münzen\n zum neuen Item!"}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 260.0),
                    const RandomizerWidget(),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
