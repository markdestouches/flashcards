import 'package:flashcards/views/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:flashcards/views/styled_widgets.dart';

class UserManagerView extends StatelessWidget {
  const UserManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    final int userCount = context.select<UserManager, int>((manager) {
      return manager.length;
    });

    return Column(children: [
      Container(
        alignment: Alignment.topLeft,
        child: MainButtonStyle(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const StyledText("Back"),
        ),
      ),
      StyledText(context.watch<UserManager>().currentUser!.name),
      MainButtonStyle(
        onPressed: userCount > 0
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserLoginView()));
              }
            : () {},
        child: const StyledText("Change User"),
      ),
      MainButtonStyle(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const UserRegisterView()));
        },
        child: const StyledText("Create User"),
      ),
      MainButtonStyle(
        onPressed: userCount > 0
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserDeleteView()));
              }
            : () {},
        child: const StyledText("Delete User"),
      ),
    ]);
  }
}
