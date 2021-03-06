import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:sff/widgets/avatar.dart';

final Size prefSize = AppBar().preferredSize;

/// The app bar used throughout the app including a title and optional settings button
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, this.settingsButton = true}) : super(key: key);

  final bool settingsButton;

  @override
  Size get preferredSize => prefSize;

  @override
  Widget build(BuildContext context) {
    List<Widget>? actions;
    if (settingsButton && UserAuthentication.getInstance().authenticated) {
      actions = [
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return const SettingsScreen();
                },
              ),
            );
          },
          child: Row(
            children: [
              StreamBuilder<User>(
                stream: data.getCurrentUserStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    User user = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          user.name,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 17,
                              child:
                                  Image.asset("assets/icons/Pixel/Muenze.PNG"),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              user.currency.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).cardColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error!);
                  }
                  return const SizedBox.shrink();
                },
              ),
              UserAvatarWidget(
                userId: UserAuthentication.getInstance().userId!,
              ),
            ],
          ),
        )
      ];
    }

    return AppBar(
      // TODO: adjust look of back button
      title: SizedBox(
        height: 40,
        child: Image.asset("assets/logo/logo.png"),
      ),
      actions: [
        ...(actions ?? []),
      ],
    );
  }
}
