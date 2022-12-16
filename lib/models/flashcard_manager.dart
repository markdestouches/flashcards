import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'package:flashcards/models/user_manager.dart';
import 'package:flashcards/views/styled_widgets.dart';
import 'package:flashcards/views/user.dart';
import 'package:flashcards/views/user_manager_view.dart';
import 'package:flashcards/models/flashcard.dart';
// import 'dart:collection/collection.dart';

class FlashcardManager extends ChangeNotifier {
  final PriorityQueue<Flashcard> _flashcards;
  FlashcardManager()
      : _flashcards =
            PriorityQueue((p0, p1) => p0.alertTime.compareTo(p1.alertTime));

  int get length => _flashcards.length;
  bool get isEmpty => _flashcards.isEmpty;
  bool get isNotEmpty => _flashcards.isNotEmpty;
  Iterable<Flashcard> get flashcards => _flashcards.unorderedElements;

  Flashcard? first() {
    if (_flashcards.isNotEmpty) {
      return _flashcards.first;
    } else {
      return null;
    }
  }

  Flashcard removeFirst() {
    notifyListeners();
    return _flashcards.removeFirst();
  }

  void add(Flashcard flashcard) {
    _flashcards.add(flashcard);
    notifyListeners();
  }

  void addAll(Iterable<Flashcard> flashcards) {
    _flashcards.addAll(flashcards);
  }

  void clear() {
    _flashcards.clear();
    notifyListeners();
  }
}
