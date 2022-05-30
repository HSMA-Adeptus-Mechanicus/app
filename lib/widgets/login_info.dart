import 'package:app/data/api/user_authentication.dart';
import 'package:app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoginInfo extends StatelessWidget {
  const LoginInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? expirationTime =
        UserAuthentication.getInstance().expirationTime?.toLocal();
    return Center(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Text(
                "Session expires at: ${expirationTime != null ? DateFormat("H:m:s MMM d yyyy").format(expirationTime) : "unknown"}"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                UserAuthentication.getInstance().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
