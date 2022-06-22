import 'package:flutter/material.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/user.dart';
import 'package:sff/widgets/pages/reward/add_new_item_to_inventory.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: data.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = (snapshot.data as List<User>).firstWhere(
                (user) => UserAuthentication.getInstance().userId == user.id);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 25.0),
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
                        Text(
                          " Du hast ${user.currency} Münzen\n gesammelt, ${user.name}!\n ${user.currency >= 15 ? "Hol dir dein neues Item!" : "Dir fehlen ${15 - user.currency} Münzen\n zum neuen Item!"}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const Expanded(
                      child: Center(
                        child: RandomizerWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
