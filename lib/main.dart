import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sff/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(App());
}

class App extends StatelessWidget {
  final Future initialized = Future.wait([
    GetStorage.init(),
    Future.delayed(const Duration(milliseconds: 3000)),
  ]);

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 255, 194, 12),
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 63, 63, 63),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.black,
          background: Color.fromARGB(255, 63, 63, 63),
          onBackground: Colors.white,
          surface: Color.fromARGB(255, 255, 194, 12),
          onSurface: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: "ZillaSlab",
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
        ),
        primaryTextTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 19),
        ),
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        cardColor: const Color.fromARGB(255, 142, 123, 255),
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromARGB(255, 255, 190, 38),
          onPrimary: Colors.black,
          secondary: Color.fromARGB(255, 63, 63, 63),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.black,
          background: Color.fromARGB(255, 136, 136, 136),
          onBackground: Colors.white,
          surface: Color.fromARGB(255, 75, 41, 199),
          onSurface: Colors.white,
        ),
      ),
      themeMode: ThemeMode.dark,
      navigatorKey: navigatorKey,
      home: Builder(builder: (context) {
        // TODO: refactor
        AudioCache player = AudioCache();
        player.play("audio/CRAWLING.mp3");
        UserAuthentication.getInstance()
            .getChangeStateStream()
            .where((stateChange) =>
                stateChange.previous == LoginState.loggingOut &&
                stateChange.state == LoginState.loggedOut)
            .listen((stateChange) {
          navigateTopLevelToWidget(const LoginScreen());
        });
        () async {
          await initialized;
          navigateTopLevelToWidget(const LoginScreen());
        }();
        return const SplashScreen();
      }),
    );
  }
}
