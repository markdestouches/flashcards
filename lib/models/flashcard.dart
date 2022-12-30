import 'package:flashcards/models/user.dart';
import 'package:isar/isar.dart';

part 'flashcard.g.dart';

const List<Duration> _alertOffsets = [
  Duration(seconds: 5),
  Duration(seconds: 10),
  Duration(seconds: 30),
  Duration(seconds: 60),
  Duration(seconds: 360),
];

@collection
class Flashcard {
  Id id = Isar.autoIncrement;
  // must never be null; isar compatibility
  String name = "";
  // must never be null; isar compatibility
  final List<String> hidden;
  final String? hint;
  final DateTime created;
  DateTime alertTime;
  int alertOffsetIndex;

  Flashcard({user, this.name = "", this.hidden = const [], this.hint})
      : created = DateTime.now(),
        alertTime = DateTime.now().add(_alertOffsets[0]),
        alertOffsetIndex = 0;

  void adjustAlertTime(bool isCorrectGuess) {
    if (isCorrectGuess == true) {
      if (alertOffsetIndex < _alertOffsets.length) {
        alertOffsetIndex += 1;
      }
    } else {
      if (alertOffsetIndex > 0) {
        alertOffsetIndex -= 1;
      }
    }
    alertTime = DateTime.now().add(_alertOffsets[alertOffsetIndex]);
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
