import 'package:flashcards/models/user.dart';
import 'package:flashcards/models/flashcard.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

enum CreateUserResult {
  success,
  userAlreadyExists,
}

enum LoginUserResult {
  success,
  wrongUserKey,
}

enum DeleteUserResult {
  success,
  userDoesNotExist,
}

class UserKey {
  final String _key;
  UserKey(String username, int passHash) : _key = "$username$passHash";
  @override
  bool operator ==(covariant other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode => _key.hashCode;
}

class UserManager extends ChangeNotifier {
  final Map<UserKey, User> _userMap;
  User currentUser;

  UserManager()
      : _userMap = {},
        currentUser = anonymousUser;

  int get length => _userMap.length;

  CreateUserResult create(String username, int passHash,
      {List<Flashcard>? flashcards}) {
    final key = UserKey(username, passHash);
    if (_userMap.containsKey(key)) {
      return CreateUserResult.userAlreadyExists;
    }
    final user = User(name: username);
    _userMap.addAll({key: user});
    currentUser = user;
    notifyListeners();
    return CreateUserResult.success;
  }

  LoginUserResult login(String username, int passHash) {
    final key = UserKey(username, passHash);
    final user = _userMap[key];
    if (user == null) {
      return LoginUserResult.wrongUserKey;
    }
    currentUser = user;
    notifyListeners();
    return LoginUserResult.success;
  }

  DeleteUserResult delete(String username, int passHash) {
    final key = UserKey(username, passHash);
    if (!_userMap.containsKey(key)) {
      return DeleteUserResult.userDoesNotExist;
    }
    final user = _userMap[key];
    if (currentUser == user) {
      currentUser = _userMap.values
          .firstWhere((value) => value != user, orElse: () => anonymousUser);
    }
    _userMap.remove(key);
    notifyListeners();
    return DeleteUserResult.success;
  }

  // bool storeCurrent(Iterable<Flashcard> currentUserFlashcards) {
  // }

  // Iterable<Flashcard>? loadCurrent() {return null;}
}
