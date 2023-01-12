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

  void removeFlashcardAt(int index) {
    final flashcard = flashcards[index];
    flashcards.removeAt(index);
    persistentUserData.flashcardLinks.remove(flashcard);
    isarInstance.writeTxnSync(() {
      persistentUserData.flashcardLinks.updateSync(unlink: [flashcard]);
      isarInstance.flashcards.deleteSync(flashcard.id);
      persistentUserData.flashcardLinks.saveSync();
    });
    notifyListeners();
  }

  void clearFlashcards() {
    flashcards.clear();
    persistentUserData.flashcardLinks.clear();
    isarInstance.writeTxnSync(() {
      persistentUserData.flashcardLinks.save();
    });
    notifyListeners();
  }

  bool checkFlashcardGuess(FlashcardGuess flashcardGuess) {
    if (flashcardGuess.guessFields.length !=
        flashcardGuess.flashcard.hidden.length) {
      throw FlashcardCheckException(
          cause: "guessFields.length does not match flashcard.hidden.length");
    }

    bool isCorrectGuess = true;

    for (int i = 0; i < flashcardGuess.guessFields.length; i++) {
      if (flashcardGuess.guessFields[i] != flashcardGuess.flashcard.hidden[i]) {
        isCorrectGuess = false;
        break;
      }
    }

    flashcardGuess.flashcard
        .adjustAlertTime(isCorrectGuess, flashcardGuess.isHintShown);

    isarInstance.writeTxnSync(() {
      return isarInstance.flashcards.putSync(flashcardGuess.flashcard);
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
