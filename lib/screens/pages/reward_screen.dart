import 'package:flutter/material.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/widgets/loading.dart';
import 'package:sff/widgets/pages/reward/reward_chest.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: data.getCurrentUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!;
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 13.0, vertical: 25.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Text(
                    user.currency >= 15
                        ? "Du hast genug Münzen gesammelt, ${user.name}!\nHol dir dein neues Item!"
                        : "Hallo ${user.name}.\nDir fehlen ${15 - user.currency} Münzen\n zum neuen Item!",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: RewardChest(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const LoadingWidget(message: "Benutzer wird geladen...");
      },
    );
  }
}
