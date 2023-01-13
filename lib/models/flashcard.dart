import 'package:flashcards/models/user.dart';
import 'package:isar/isar.dart';

part 'flashcard.g.dart';

const List<Duration> _reviewDelays = _properReviewDelays;

const List<Duration> _shortReviewDelays = [
  Duration(seconds: 5),
  Duration(seconds: 10),
  Duration(seconds: 30),
  Duration(seconds: 60),
  Duration(seconds: 360),
];

const List<Duration> _properReviewDelays = [
  Duration(seconds: 5),
  Duration(minutes: 2),
  Duration(minutes: 10),
  Duration(hours: 1),
  Duration(hours: 5),
  Duration(days: 1),
  Duration(days: 25),
  Duration(days: 120),
];

abstract class ReviewState {
  String timeTillReview = "";
  String get timeTillReviewPrefixed => timeTillReview;
}

class ReviewIsDue extends ReviewState {
  ReviewIsDue() {
    timeTillReview = "now";
  }
}

abstract class ReviewIsNotDue extends ReviewState {
  ReviewIsNotDue({required Duration timeTillReview}) {
    String formattedTimeTillReview;
    if (timeTillReview.inSeconds <= const Duration(seconds: 1).inSeconds) {
      formattedTimeTillReview = "1 second";
    } else if (timeTillReview < const Duration(minutes: 1)) {
      formattedTimeTillReview = "${timeTillReview.inSeconds} seconds";
    } else if (timeTillReview < const Duration(hours: 1)) {
      formattedTimeTillReview = "${1 + timeTillReview.inMinutes} minutes";
    } else if (timeTillReview < const Duration(days: 1)) {
      formattedTimeTillReview = "${1 + timeTillReview.inHours} hours";
    } else if (timeTillReview < const Duration(days: 30)) {
      formattedTimeTillReview = "${1 + timeTillReview.inDays} days";
    } else {
      formattedTimeTillReview = "${1 + timeTillReview.inDays / 30} months";
    }
    this.timeTillReview = formattedTimeTillReview;
  }

  @override
  String get timeTillReviewPrefixed => "in $timeTillReview";
}

class ReviewIsLocked extends ReviewIsNotDue {
  ReviewIsLocked({required timeTillReview})
      : super(timeTillReview: timeTillReview);
}

class ReviewIsUnlocked extends ReviewIsNotDue {
  ReviewIsUnlocked({required timeTillReview})
      : super(timeTillReview: timeTillReview);
}

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
  DateTime reviewTime;
  int reviewDelayIndex;

  Flashcard({user, this.name = "", this.hidden = const [], this.hint})
      : created = DateTime.now(),
        reviewTime = DateTime.now().add(_reviewDelays[0]),
        reviewDelayIndex = 0;

  void adjustReviewTime(bool isCorrectGuess, bool isHintShown) {
    if (isCorrectGuess == false) {
      if (reviewDelayIndex > 0) {
        reviewDelayIndex -= 1;
      }
    } else {
      if (reviewDelayIndex < _reviewDelays.length && isHintShown == false) {
        reviewDelayIndex += 1;
      }
    }
    reviewTime = DateTime.now().add(_reviewDelays[reviewDelayIndex]);
  }

  Duration getFullReviewDelayDuration() {
    return _reviewDelays[reviewDelayIndex];
  }

  ReviewState getReviewState(DateTime currentTime) {
    final timeTillReview = reviewTime.difference(currentTime);
    if (timeTillReview.inSeconds <= 0) {
      return ReviewIsDue();
    } else if (timeTillReview.inSeconds /
            getFullReviewDelayDuration().inSeconds <
        _reviewLockFactor) {
      return ReviewIsUnlocked(timeTillReview: timeTillReview);
    } else {
      return ReviewIsLocked(timeTillReview: timeTillReview);
    }
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
    representation += "alertTime: ${reviewTime.toString()}\n";
    representation += "alertOffsetIndex: ${reviewDelayIndex.toString()}";
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
