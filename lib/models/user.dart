import 'package:flashcards/models/flashcard_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flutter/material.dart';

final User anonymousUser = User(name: "Anonymous User");

class User {
  final String id;
  final String name;
  User({required this.name}) : id = const Uuid().v4();
}
