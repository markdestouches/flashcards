import 'package:flashcards/models/flashcard_manager.dart';
import 'package:flashcards/models/user.dart';
import 'package:flashcards/views/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/views/user.dart';
import 'package:flashcards/views/user_manager_view.dart';

void main() {
  runApp(const Flashcards());
}

class Flashcards extends StatelessWidget {
  const Flashcards({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserManager>(create: (_) => UserManager()),
        ChangeNotifierProvider<FlashcardManager>(
            create: (_) => FlashcardManager())
      ],
      child: MaterialApp(
        title: 'Flashcards',
        routes: {
          '/create_user': (context) => const UserCreateView(),
          '/login_user': (context) => const UserLoginView(),
          '/delete_user': (context) => const UserDeleteView(),
          '/user_manager_view': (context) => const UserManagerView(),
          '/add_flashcard': (context) => const AddFlashcardView(),
        },
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/user_manager_view');
        },
        child: StyledText(context.watch<UserManager>().currentUser.name),
      ),
      const UserCardsView(),
    ]);
  }
}
