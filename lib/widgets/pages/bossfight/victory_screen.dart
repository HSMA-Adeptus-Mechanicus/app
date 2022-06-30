import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sff/data/model/project.dart';
import 'package:sff/navigation.dart';
import 'package:sff/data/model/sprint.dart';

bool _resetter = true;

class Victory extends StatelessWidget {
  const Victory({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Sprint>(
      stream: () async* {
        Sprint sprint = await ProjectManager.getInstance()
            .currentProject!
            .getCurrentSprint();
        yield* sprint.asStream();
      }(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Sprint sprint = snapshot.data!;
          return FutureBuilder(
            future: sprint.calculateCurrentHealth(),
            builder: (context, snapshot) {
              if (snapshot.data == 0 && _resetter == true) {
                Future.microtask(() {
                  _showMyDialog();
                  _resetter = false;
                });
              }
              return Container();
            },
          );
        }
        return Container();
      },
    );
  }
}

Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: navigatorKey.currentContext!,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const VictoryDialog();
    },
  );
}

class VictoryDialog extends StatelessWidget {
  const VictoryDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Geschafft!",
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Dein Team und Du haben den Boss bezwungen.\nWoo!",
                    style: TextStyle(
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}