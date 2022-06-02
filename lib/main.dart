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
          primarySwatch: Colors.deepPurple,
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            secondary: Color.fromARGB(255, 63, 63, 63),
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.black,
            background: Color.fromARGB(255, 63, 63, 63),
            onBackground: Colors.white,
            surface: Color.fromARGB(255, 85, 58, 183),
            onSurface: Colors.white,
          )),
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
    );
  }
}
