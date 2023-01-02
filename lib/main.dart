import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/user.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:flashcards/views/flashcard.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/views/user.dart';
import 'package:flashcards/views/user_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

void main() {
  Isar isarInstance =
      Isar.openSync([FlashcardSchema, PersistentUserDataSchema]);
  final UserManager userManager = UserManager(isarInstance: isarInstance);
  runApp(FlashcardsApp(
    userManager: userManager,
  ));
}

class FlashcardsApp extends StatelessWidget {
  final UserManager userManager;
  const FlashcardsApp({required this.userManager, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserManager>.value(
      value: userManager,
      child: Builder(
        builder: ((context) {
          final user = context.select<UserManager, User?>(
            (userManager) => userManager.currentUser,
          );
          if (user == null) {
            return const MyMaterialApp(home: UnloggedLandingPage());
          } else {
            return ChangeNotifierProxyProvider<UserManager, User>(
              create: (context) => context.read<UserManager>().currentUser!,
              update: (context, userManager, previousUser) =>
                  context.read<UserManager>().currentUser!,
              child: const MyMaterialApp(
                home: HomePage(),
              ),
            );
          }
        }),
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  final Widget home;
  const MyMaterialApp({required this.home, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: TextTheme(bodyText1: GoogleFonts.roboto(fontSize: 18.0)),
      ),
      title: 'Flashcards',
      home: home,
    );
  }
}

class UnloggedLandingPage extends StatelessWidget {
  const UnloggedLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MainButtonStyle(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const UserLoginView();
              },
            ),
          );
        },
        child: const StyledText("Login"),
      ),
      MainButtonStyle(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const UserRegisterView();
              },
            ),
          );
        },
        child: const StyledText("Register"),
      ),
    ]);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UserManagerView()));
        },
        child: StyledText(context.watch<UserManager>().currentUser!.name),
      ),
      const UserFlashcardsView(),
      const Divider(),
      const UserDebugFlashcardListView(),
    ]);
  }
}
