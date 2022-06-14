import 'package:flutter/material.dart';
import 'package:sff/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  int splashtime = 4;
  // duration of splash screen on second

  @override
  void initState() {
    Future.delayed(Duration(seconds: splashtime), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
          //pushReplacement = replacing the route so that
          //splash screen won't show on back button press
          //navigation to Home page.
          builder: (context) {
        return blub;
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/SplashBackgroundmitSchrift.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset(
              "assets/Hourglass.gif",
              scale: 1 / 3,
              filterQuality: FilterQuality.none,
            ),
          )
        ],
      ),
    );
  }
}
