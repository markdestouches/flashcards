import 'package:flashcards/models/flashcard.dart';
import 'package:flashcards/models/user.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/views/user.dart';
import 'package:flashcards/views/user_manager_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:desktop_window/desktop_window.dart';

// TODO: add duration tooltip to flashcards
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
    return Column(
      children: [
        StyledButton(
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
        StyledButton(
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
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton(
            style: ButtonStyle(elevation:
                MaterialStateProperty.resolveWith<double?>(
                    (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return 0;
              } else {
                return 0;
              }
            }), backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                return Colors.transparent;
              },
            )),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const UserManagerView()));
            },
            child: StyledText(context.watch<UserManager>().currentUser!.name),
          ),
          const UserFlashcardListView(),
        ],
      ),
    );
  }
}
