import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flashcards/models/flashcard.dart';

part 'user.g.dart';

@collection
class PersistentUserData {
  Id id;
  final String name;
  final flashcardLinks = IsarLinks<Flashcard>();
  PersistentUserData({
    required this.name,
    required this.id,
  });
}

class User extends ChangeNotifier {
  PersistentUserData persistentUserData;
  late List<Flashcard> flashcards;
  final Isar isarInstance;

  String get name => persistentUserData.name;

  User({
    required this.persistentUserData,
    required this.isarInstance,
  }) {
    loadFlashcards();
  }

  void loadFlashcards() {
    persistentUserData.flashcardLinks.loadSync();
    flashcards = persistentUserData.flashcardLinks.toList();
    sortFlashcards();
  }

  static void transferFlashcardManager(User sourceUser, User targetUser) {
    // targetUser.flashcards = sourceUser.flashcards;
    // sourceUser.flashcards = [];
    throw UnimplementedError(
        "transferFlashcardManager function is unimplemented");
  }

  // @override
  // String toString() {
  //   String flashcardsString = "flashcards:\n";
  //   for (Flashcard f in flashcards) {
  //     flashcardsString += "${f.toString()}\n";
  //   }
  //   return "id: $id\nname: $name\nflashcards: $flashcardsString";
  // }

  void sortFlashcards() {
    flashcards.sort(
      (a, b) => a.alertTime.compareTo(b.alertTime),
    );
  }

  void addFlashcard(Flashcard flashcard) {
    persistentUserData.flashcardLinks.add(flashcard);
    isarInstance.writeTxnSync(() {
      isarInstance.flashcards.putSync(flashcard);
      persistentUserData.flashcardLinks.saveSync();
    });
    flashcards.add(flashcard);
    sortFlashcards();
    notifyListeners();
  }

  // void addAllFlashcards(Iterable<Flashcard> iterableFlashcards) {
  //   flashcards.addAll(iterableFlashcards);
  //   sortFlashcards();
  //   notifyListeners();
  // }

  void clearFlashcards() {
    flashcards.clear();
    persistentUserData.flashcardLinks.clear();
    isarInstance.writeTxnSync(() {
      persistentUserData.flashcardLinks.save();
    });
    notifyListeners();
  }

  bool checkFlashcardGuess(Flashcard flashcard, List<String> guessFields) {
    if (guessFields.length != flashcard.hidden.length) {
      throw FlashcardCheckException(
          cause: "guessFields.length does not match flashcard.hidden.length");
    }

    bool isCorrectGuess = true;

    for (int i = 0; i < guessFields.length; i++) {
      if (guessFields[i] != flashcard.hidden[i]) {
        isCorrectGuess = false;
        break;
      }
    }

    flashcard.adjustAlertTime(isCorrectGuess);
    isarInstance.writeTxnSync(() {
      return isarInstance.flashcards.putSync(flashcard);
    });
    sortFlashcards();
    notifyListeners();
    return isCorrectGuess;
  }
}

class FlashcardCheckException implements Exception {
  String cause;
  FlashcardCheckException({required this.cause});
}
