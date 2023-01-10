import 'package:flashcards/models/user.dart';
import 'package:isar/isar.dart';

part 'flashcard.g.dart';

const List<Duration> _alertOffsets = _properAlertOffsets;

const List<Duration> _shortAlertOffsets = [
  Duration(seconds: 5),
  Duration(seconds: 10),
  Duration(seconds: 30),
  Duration(seconds: 60),
  Duration(seconds: 360),
];

const List<Duration> _properAlertOffsets = [
  Duration(seconds: 5),
  Duration(minutes: 2),
  Duration(minutes: 10),
  Duration(hours: 1),
  Duration(hours: 5),
  Duration(days: 1),
  Duration(days: 25),
  Duration(days: 120),
];

// If the review lock factor is 0.2, the flashcard is meant to be locked for review
// until 80% of the current alert offset duration has elapsed
const double _reviewLockFactor = 0.2;

@collection
class Flashcard {
  Id id = Isar.autoIncrement;
  String name = "";
  final List<String> hidden;
  final String? hint;
  final DateTime created;
  DateTime alertTime;
  int alertOffsetIndex;

  Flashcard({user, this.name = "", this.hidden = const [], this.hint})
      : created = DateTime.now(),
        alertTime = DateTime.now().add(_alertOffsets[0]),
        alertOffsetIndex = 0;

  void adjustAlertTime(bool isCorrectGuess, bool isHintShown) {
    if (isCorrectGuess == false) {
      if (alertOffsetIndex > 0) {
        alertOffsetIndex -= 1;
      }
    } else {
      if (alertOffsetIndex < _alertOffsets.length && isHintShown == false) {
        alertOffsetIndex += 1;
      }
    }
    alertTime = DateTime.now().add(_alertOffsets[alertOffsetIndex]);
  }

  Duration getFullAlertDelayDuration() {
    return _alertOffsets[alertOffsetIndex];
  }

  FlashcardAlertState getAlertState(DateTime currentTime) {
    final diffSec = alertTime.difference(currentTime).inSeconds;
    if (diffSec <= 0) {
      return FlashcardAlertState.triggered;
    } else if (diffSec / getFullAlertDelayDuration().inSeconds <
        _reviewLockFactor) {
      return FlashcardAlertState.reviewUnlocked;
    } else {
      return FlashcardAlertState.reviewLocked;
    }
  }

  String getFormattedTimeTillALert(DateTime currentTime) {
    final timeTillNextAlert = alertTime.difference(currentTime);
    String formattedAlertTime;
    if (timeTillNextAlert < const Duration(seconds: 1)) {
      formattedAlertTime = "now";
    } else if (timeTillNextAlert < const Duration(minutes: 1)) {
      formattedAlertTime = "in ${timeTillNextAlert.inSeconds} second(s)";
    } else if (timeTillNextAlert < const Duration(hours: 1)) {
      formattedAlertTime = "in ${1 + timeTillNextAlert.inMinutes} minute(s)";
    } else if (timeTillNextAlert < const Duration(days: 1)) {
      formattedAlertTime = "in ${1 + timeTillNextAlert.inHours} hour(s)";
    } else if (timeTillNextAlert < const Duration(days: 30)) {
      formattedAlertTime = "in ${1 + timeTillNextAlert.inDays} day(s)";
    } else {
      formattedAlertTime = "in ${1 + timeTillNextAlert.inDays / 30} month(s)";
    }
    return formattedAlertTime;
  }

  @override
  String toString() {
    String representation = "name: $name\n}";
    if (hint != null) {
      representation += "hint: $hint\n";
    }
    for (int i = 0; i < hidden.length; i++) {
      representation += "#${i + 1}: ${hidden[i]}\n";
    }
    representation += "created: ${created.toString()}\n";
    representation += "alertTime: ${alertTime.toString()}\n";
    representation += "alertOffsetIndex: ${alertOffsetIndex.toString()}";
    return representation;
  }
}

class FlashcardGuess {
  Flashcard flashcard;
  List<String> guessFields;
  bool isHintShown;
  FlashcardGuess({
    required this.flashcard,
    required this.guessFields,
    required this.isHintShown,
  });
}

enum FlashcardAlertState {
  triggered,
  reviewLocked,
  reviewUnlocked,
}
