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
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
      ),
      themeMode: ThemeMode.light,
      navigatorKey: navigatorKey,
      home: Builder(builder: (context) {
        UserAuthentication.getInstance()
            .getChangeStateStream()
            .where((stateChange) =>
                stateChange.previous == LoginState.loggingOut &&
                stateChange.state == LoginState.loggedOut)
            .listen((stateChange) {
          Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        });
        return const LoginScreen();
      }),
    );
  }
}
