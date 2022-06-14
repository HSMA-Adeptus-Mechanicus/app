import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/splash-screen/SplashBackgroundmitSchrift.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset(
              "assets/splash-screen/Hourglass.gif",
              scale: 1 / 3,
              filterQuality: FilterQuality.none,
            ),
          )
        ],
      ),
    );
  }
}
