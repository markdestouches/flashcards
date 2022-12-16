import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/flashcard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:provider/provider.dart';

class _UserFieldsView extends StatefulWidget {
  final void Function(BuildContext, String, int)? handleUserInput;
  final String submitButtonText;
  const _UserFieldsView(
      {required this.submitButtonText, this.handleUserInput, super.key});

  @override
  State<_UserFieldsView> createState() => _UserFieldsViewState();
}

class _UserFieldsViewState extends State<_UserFieldsView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const StyledText('Back'),
            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _usernameController,
              autofocus: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Username',
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: _passwordController,
              autofocus: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              final String username = _usernameController.text;
              final int passHash = _passwordController.text.hashCode;
              widget.handleUserInput?.call(context, username, passHash);
            },
            child: StyledText(widget.submitButtonText),
          ),
        ],
      ),
    );
  }
}

class UserCreateView extends StatelessWidget {
  const UserCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return _UserFieldsView(
      submitButtonText: "Create",
      handleUserInput: (context, username, passHash) {
        final result = context.read<UserManager>().create(username, passHash);
        print("$result");
        if (result == CreateUserResult.userAlreadyExists) {
          print("UNIMPLEMENTED: show \"User Already Exists\" popup");
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class UserLoginView extends StatelessWidget {
  const UserLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return _UserFieldsView(
      submitButtonText: "Login",
      handleUserInput: (context, username, passHash) {
        final result = context.read<UserManager>().login(username, passHash);
        print("$result");
        if (result == LoginUserResult.wrongUserKey) {
          print("UNIMPLEMENTED: show \"Username or password is incorrect\"");
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class UserDeleteView extends StatelessWidget {
  const UserDeleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return _UserFieldsView(
      submitButtonText: "Delete",
      handleUserInput: (context, username, passHash) {
        final result = context.read<UserManager>().delete(username, passHash);
        print("$result");
        if (result == DeleteUserResult.userDoesNotExist) {
          print("UNIMPLEMENTED: show \"The user does not exist\"");
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

class UserCardsView extends StatelessWidget {
  const UserCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final flashcard = context
        .select<FlashcardManager, Flashcard?>((manager) => manager.first());

    if (flashcard != null) {
      final timeTillAlert =
          DateTime.now().difference(flashcard.alertTime).toString();
      return Column(
        children: [
          MainButtonStyle(
            onPressed: () {
              Navigator.of(context).pushNamed('/add_flashcard');
            },
            child: const StyledText("Add Flashcard"),
          ),
          StyledText(flashcard.name),
          StyledText('Review in: $timeTillAlert'),
        ],
      );
    } else {
      return MainButtonStyle(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_flashcard');
        },
        child: const StyledText("Add Flashcard"),
      );
    }
  }
}
