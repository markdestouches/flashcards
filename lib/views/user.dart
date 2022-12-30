import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/user.dart';
import 'package:flashcards/views/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

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
          children: [
            const _AddFlashcardButton(),
            SizedBox(
              width: 300,
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  int timeTillAlert =
                      flashcard.alertTime.difference(currentTime).inSeconds;
                  timeTillAlert = timeTillAlert >= 0 ? timeTillAlert : 0;
                  final buttonBackgroundColor = Colors
                          .primaries[(index * index) % Colors.primaries.length]
                      [((index + 1) * 100) % 700];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: buttonBackgroundColor,
                          shape: const BeveledRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) {
                              return CheckFlashcardView(
                                flashcard: flashcard,
                              );
                            }),
                          ),
                        );
                      },
                      child: Column(children: [
                        StyledText(flashcard.name),
                        StyledText("Next Alert In: $timeTillAlert"),
                      ]),
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
        Navigator.of(context).pushNamed('/add_flashcard');
      },
      child: const StyledText("Add Flashcard"),
    );
  }
}

class UserCardListView extends StatelessWidget {
  const UserCardListView({super.key});
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
          return CardView(card: card, index: index);
        }),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  const CardView({
    Key? key,
    required this.card,
    required this.index,
  }) : super(key: key);

  final Flashcard card;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.lightBlue[(index + 1) * 50],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const StyledText("name: "),
              card.hint != null ? const StyledText("hint: ") : Container(),
              Column(
                children: card.hidden
                    .mapIndexed(
                      (i, e) => StyledText("hidden field #${i + 1}: "),
                    )
                    .toList(),
              ),
              const StyledText("created: "),
              const StyledText("due: "),
              const StyledText("next alert in: "),
              const StyledText("id: "),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              StyledText(card.name),
              card.hint != null ? StyledText(card.hint!) : Container(),
              Column(
                children: card.hidden
                    .map(
                      (e) => StyledText(e),
                    )
                    .toList(),
              ),
              StyledText(card.created.toString()),
              StyledText(card.alertTime.toString()),
              StyledText(card.alertTime.difference(card.created).toString()),
            ]),
          ],
        ),
      ),
    );
  }
}
