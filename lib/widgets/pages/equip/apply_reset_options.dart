import 'package:flutter/material.dart';
import 'package:sff/data/model/avatar.dart';
import 'package:sff/data/data.dart';
import 'package:sff/data/model/user.dart';
import 'package:sff/navigation.dart';
import 'package:sff/widgets/display_error.dart';
import 'package:sff/widgets/loading.dart';

class ApplyResetOptionsShower extends StatelessWidget {
  const ApplyResetOptionsShower({
    Key? key,
    required this.avatar,
  }) : super(key: key);

  final EditableAvatar avatar;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditableAvatar>(
      stream: avatar.getStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          EditableAvatar editableAvatar = snapshot.data!;
          return StreamBuilder<UserAndAvatar>(
            stream: () async* {
              yield* await data
                  .getCurrentUser()
                  .then((value) => value.getStreamWithAvatar());
            }(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ApplyResetOptions(
                  editableAvatar: editableAvatar,
                  userAvatar: snapshot.data!,
                );
              }
              return const SizedBox.shrink();
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ApplyResetOptions extends StatefulWidget {
  const ApplyResetOptions({
    Key? key,
    required this.editableAvatar,
    required this.userAvatar,
  }) : super(key: key);

  final EditableAvatar editableAvatar;
  final UserAndAvatar userAvatar;

  @override
  State<ApplyResetOptions> createState() => _ApplyResetOptionsState();
}

class _ApplyResetOptionsState extends State<ApplyResetOptions> {
  @override
  void dispose() {
    super.dispose();
    if (!widget.editableAvatar.equals(widget.userAvatar.avatar)) {
      Future.microtask(() {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (context) {
            return UnsavedChangesDialog(widget: widget);
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editableAvatar.equals(widget.userAvatar.avatar)) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              widget.editableAvatar
                  .setTo(widget.userAvatar.avatar.equippedItems);
            },
            child: Icon(
              Icons.replay_sharp,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () async {
              await showSavingDialog(
                  widget.userAvatar.user.applyAvatar(widget.editableAvatar));
            },
            child: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class UnsavedChangesDialog extends StatelessWidget {
  const UnsavedChangesDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ApplyResetOptions widget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Änderungen Speichern?"),
      content: const Text("Willst Du die Änderungen am Avatar speichern?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Verwerfen"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showSavingDialog(
                widget.userAvatar.user.applyAvatar(widget.editableAvatar));
          },
          child: const Text("Speichern"),
        ),
      ],
    );
  }
}

Future<T> showSavingDialog<T>(Future<T> future) async {
  return displayError(() async {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox.expand(
            child: LoadingWidget(message: "Speichern..."),
          ),
        );
      },
    );
    try {
      var result = await future;
      return result;
    } finally {
      Navigator.pop(navigatorKey.currentContext!);
    }
  });
}
