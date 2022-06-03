import 'package:sff/data/api/user_authentication.dart';
import 'package:sff/screens/app_frame.dart';
import 'package:sff/screens/login/register_screen.dart';
import 'package:sff/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:sff/widgets/display_error.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      settingsButton: false,
      body: StreamBuilder(
        stream: UserAuthentication.getInstance().getStateStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            LoginState state = snapshot.data as LoginState;
            if (state == LoginState.loggedIn) {
              Future.microtask(
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AppFrame()),
                  );
                },
              );
              return const Center(child: CircularProgressIndicator());
            } else if (state == LoginState.loggedOut) {
              return const Scaffold(
                body: LoginWidget(),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IntrinsicHeight(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide a username";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please provide a password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await displayError(() async {
                        await UserAuthentication.getInstance().login(
                            _usernameController.text, _passwordController.text);
                      });
                    }
                  },
                  child: const Text("Login"),
                ),
                const Divider(
                  height: 30,
                  color: Color.fromARGB(255, 197, 197, 197),
                  indent: 20,
                  endIndent: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
