import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/user.dart';
import 'package:flashcards/views/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:provider/provider.dart';

const List<Color> flashcardColors = [
  // Russian Violet
  Color(0xff0B0033),
  // Russian Violet
  Color(0xff210032),
  // Dark Purple
  Color(0xff370031),
  // Tyrian Purple
  Color(0xff5D1132),
  // Antique Ruby
  Color(0xff832232),
  // Redwood
  Color(0xffA9564B),
  // Copper Crayola
  Color(0xffCE8964),
  // Antique Brass
  Color(0xffD29472),
  // Middle Yellow
  Color(0xffFFEB3B),
];

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

class UserRegisterView extends StatelessWidget {
  const UserRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return _UserFieldsView(
      submitButtonText: "Create",
      handleUserInput: (context, username, passHash) {
        context.read<UserManager>().create(username, passHash);
        // Navigator.of(context).pop();
        Navigator.of(context).pop();
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
        context.read<UserManager>().login(username, passHash);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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
        context.read<UserManager>().delete(username, passHash);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }
}

class CurrentTime {
  final DateTime value;
  CurrentTime() : value = DateTime.now();
}

class UserFlashcardsView extends StatelessWidget {
  const UserFlashcardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final flashcards =
        context.select<User, List<Flashcard>>((user) => user.flashcards);
    return StreamProvider<CurrentTime>.value(
      initialData: CurrentTime(),
      value: Stream.periodic(
        const Duration(seconds: 1),
        (_) => CurrentTime(),
      ),
      child: Builder(builder: (context) {
        final currentTime = context.watch<CurrentTime>().value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _AddFlashcardButton(),
            SizedBox(
              height: 300,
              width: 500,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dismissible(
                      direction: DismissDirection.endToStart,
                      key: Key(flashcard.id.toString()),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        context.read<User>().removeFlashcardAt(index);
                      },
                      child: FlashcardView(
                          buttonBackgroundColor: Colors.primaries[
                              flashcard.id % Colors.primaries.length],
                          flashcard: flashcard,
                          currentTime: currentTime),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _AddFlashcardButton extends StatelessWidget {
  const _AddFlashcardButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainButtonStyle(
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddFlashcardView()));
      },
      child: const StyledText("Add Flashcard"),
    );
  }
}

class UserDebugFlashcardListView extends StatelessWidget {
  const UserDebugFlashcardListView({super.key});
  @override
  Widget build(BuildContext context) {
    final flashcards = context.watch<User>().flashcards;
    return Flexible(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: flashcards.length,
        itemBuilder: ((context, index) {
          final card = flashcards[index];
          return DebugFlashcardView(card: card, index: index);
        }),
      ),
    );
  }
}
