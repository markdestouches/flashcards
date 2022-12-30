import 'package:flashcards/models/user.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class UserOperationException implements Exception {
  String cause;
  UserOperationException(this.cause);
}

int _genUserId(String username, int passHash) {
  return "$username$passHash".hashCode;
}

class UserManager extends ChangeNotifier {
  Isar isarInstance;
  User? currentUser;
  late int _userCount;
  int get length => _userCount;

  UserManager({required this.isarInstance}) {
    _userCount = isarInstance.collection<PersistentUserData>().countSync();
  }

  void create(String username, int passHash) {
    PersistentUserData persistentUserData =
        PersistentUserData(name: username, id: _genUserId(username, passHash));
    isarInstance.writeTxnSync(() {
      return isarInstance.persistentUserDatas.putSync(persistentUserData);
    });
    User newUser = User(
      persistentUserData: persistentUserData,
      isarInstance: isarInstance,
    );
    currentUser = newUser;
    _userCount += 1;
    notifyListeners();
  }

  void login(String username, int passHash) {
    PersistentUserData? persistentUserData = isarInstance
        .collection<PersistentUserData>()
        .getSync(_genUserId(username, passHash));
    if (persistentUserData == null) {
      throw UserOperationException("User $username not found.");
    }
    User user = User(
      persistentUserData: persistentUserData,
      isarInstance: isarInstance,
    );
    currentUser = user;
    notifyListeners();
  }

  void delete(String username, int passHash) {
    final bool txResult = isarInstance.writeTxnSync(() {
      return isarInstance
          .collection<User>()
          .deleteSync(_genUserId(username, passHash));
    });
    if (txResult == false) {
      throw UserOperationException(
          "User $username could not be deleted. Possibly, this user does not exist");
    }
    _userCount -= 1;
    notifyListeners();
  }

  void save(User user) {
    isarInstance.writeTxnSync(() {
      return isarInstance
          .collection<PersistentUserData>()
          .putSync(user.persistentUserData);
    });
  }

  void saveCurrentUser() {
    return save(currentUser!);
  }
}
