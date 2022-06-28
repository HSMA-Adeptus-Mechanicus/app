import 'package:flutter/material.dart';
import 'package:sff/navigation.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/sprint.dart';

bool _resetter = true;

class Victory extends StatefulWidget {
  const Victory({Key? key}) : super(key: key);

  @override
  State<Victory> createState() => VictoryIndecator();
}

class VictoryIndecator extends State<Victory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Sprint>(
      stream: data.getSprintsStream().map((event) => event[0]),
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
                  // navigateToWidget(
                  //   VictoryScreen(),
                  // );
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
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Flexible(
                  child: Text(
                    "Dein Team und Du haben den Boss bezwungen! \nWoo!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 190, 38),
                        height: 1.5,
                        fontSize: 32),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
// class VictoryScreen extends StatelessWidget {
//   const VictoryScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Future<void> _showMyDialog() async {
//       return showDialog<void>(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return SizedBox(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image(
//                       image: Image.asset(
//                         "assets/icons/Pixel/Muenze.PNG",
//                         scale: 1.0,
//                       ).image,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     }

//     return FutureBuilder<void>(builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         _showMyDialog();
//       }
//       return Container();
//     });
//   }
// }





// class VictoryScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       body: GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () async {
//           Navigator.pop(context);
//         },
//         child: const Text("Du hast den Boss besiegt! Glückwunsch!"),
//       ),
//     );
//   }
// }
