import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/navigation.dart';
import 'package:sff/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            fontSize: 20,
            color: Colors.black,
          ),
          
        ),
        primaryTextTheme: const TextTheme(
          bodyText1: TextStyle(
            fontSize: 20
          ),
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
        UserAuthentication.getInstance()
            .getChangeStateStream()
            .where((stateChange) =>
                stateChange.previous == LoginState.loggingOut &&
                stateChange.state == LoginState.loggedOut)
            .listen((stateChange) {
          navigateTopLevelToWidget(const LoginScreen());
        });
        return const LoginScreen();
      }),
    );
  }
}
