import 'package:flashcards/models/flashcard.dart';
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
    if (isarInstance.persistentUserDatas.getSync(persistentUserData.id) !=
        null) {
      throw UserOperationException(
          "User \"${persistentUserData.name}\" already exists."
          "\nChange the password if you want to create another user with the same name.");
    }
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
      throw UserOperationException("User \"$username\" not found.");
    }
    User user = User(
      persistentUserData: persistentUserData,
      isarInstance: isarInstance,
    );
    currentUser = user;
    notifyListeners();
  }

  // Hic sunt bugs [probably]
  void delete(String username, int passHash) {
    final PersistentUserData? persistentUserDataToDelete =
        isarInstance.writeTxnSync(() {
      return isarInstance
          .collection<PersistentUserData>()
          .getSync(_genUserId(username, passHash));
    });

    if (persistentUserDataToDelete == null) {
      throw UserOperationException("User \"$username\" not found.");
    }

    // This assumes only logged in users can delete users
    if (persistentUserDataToDelete.id == currentUser!.persistentUserData.id) {
      currentUser = null;
    }

    final bool isDeleted = isarInstance.writeTxnSync(
      () {
        for (Flashcard f in persistentUserDataToDelete.flashcardLinks) {
          if (isarInstance.collection<Flashcard>().deleteSync(f.id) != true) {
            return false;
          }
        }
        persistentUserDataToDelete.flashcardLinks.resetSync();
        if (isarInstance
                .collection<PersistentUserData>()
                .deleteSync(persistentUserDataToDelete.id) !=
            true) {
          return false;
        }
        return true;
      },
    );

    if (!isDeleted) {
      throw UserOperationException(
          "Deletion failed: User \"$username\" could not be deleted. Perhaps some of this user's flashcards failed to delete");
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

  void clearFlashcards() {
    throw UnimplementedError();
  }

  void saveCurrentUser() {
    return save(currentUser!);
  }
}
