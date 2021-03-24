import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/model/app_settings.dart';
import 'package:history_of_me/data/constants.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDBService {
  Future<void> initDB() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(UserDataAdapter());
    Hive.registerAdapter(UserCreatedColorAdapter());
    Hive.registerAdapter(DiaryEntryAdapter());
  }

  static const String _appSettingsKey = 'app_settings';
  static const String _userDataKey = 'app_settings';
  static const String _userCreatedColorsKey = 'user_created_colors';
  static const String _diaryEntriesKey = 'diary_entries';

  Future<Box<dynamic>> openAppSettingsBox() {
    if (!Hive.isBoxOpen(_appSettingsKey)) {
      return Hive.openBox(_appSettingsKey);
    } else {
      return Future(() {
        return Hive.box(_appSettingsKey);
      });
    }
  }

  Future<Box<dynamic>> openUserDataBox() {
    if (!Hive.isBoxOpen(_userDataKey)) {
      return Hive.openBox(_userDataKey);
    } else {
      return Future(() {
        return Hive.box(_userDataKey);
      });
    }
  }

  Future<Box<dynamic>> openUserCreatedColorsDataBox() {
    if (!Hive.isBoxOpen(_userCreatedColorsKey)) {
      return Hive.openBox(_userCreatedColorsKey);
    } else {
      return Future(() {
        return Hive.box(_userCreatedColorsKey);
      });
    }
  }

  Future<Box<dynamic>> openDiaryEntryDataBox() {
    if (!Hive.isBoxOpen(_diaryEntriesKey)) {
      return Hive.openBox(_diaryEntriesKey);
    } else {
      return Future(() {
        return Hive.box(_diaryEntriesKey);
      });
    }
  }

  Future<int> openBoxes() async {
    try {
      await openAppSettingsBox();
      await openUserDataBox();
      await openUserCreatedColorsDataBox();
      await openDiaryEntryDataBox();
      print("Opened Boxes");
      return 0;
    } catch (e) {
      print("Error while opening the boxes");
      print(e);
      return 1;
    }
  }

  ValueListenable<Box<dynamic>> getAppSettings() {
    return Hive.box(_appSettingsKey).listenable();
  }

  void updateAppSettings(AppSettings appSettings) {
    Hive.box(_appSettingsKey).putAt(0, appSettings);
  }

  ValueListenable<Box<dynamic>> getUserData() {
    return Hive.box(_userDataKey).listenable();
  }

  /// Stores the initial [UserData] model to the Hive database on the first app startup.
  ///
  /// The provided username must be obtained by the user.
  void createUserData(String username) {
    final UserData userData = UserData(
      name: username,
      bookmarkColor: BookmarkConstants.initialColor,
      stripeCount: BookmarkConstants.minStripeCount,
      dotSize: BookmarkConstants.minDotSize,
      animated: true,
      quote: BookmarkConstants.initialQuote,
      designPatternIndex: BookmarkConstants.initialDesignPatternIndex,
      quoteAuthor: BookmarkConstants.initialQuoteAuthor,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
    if (Hive.box(_userDataKey).isEmpty) {
      Hive.box(_userDataKey).add(userData);
    } else {
      print("UserData object already created");
    }
  }

  /// Updates the [UserData] model in the database using the provided [UserData].
  ///
  /// Note that all existing value will be overridden on excecution, so the provided
  /// [UserData] should hold non-null values.
  void updateUserData(UserData userData) {
    Hive.box(_userDataKey).putAt(0, userData);
  }

  void updateUsername(UserData initialUserData, String updatedName) {
    UserData updatedUserData = UserData(
      name: updatedName,
      bookmarkColor: initialUserData.bookmarkColor,
      stripeCount: initialUserData.stripeCount,
      dotSize: initialUserData.dotSize,
      animated: initialUserData.animated,
      quote: initialUserData.quote,
      designPatternIndex: initialUserData.designPatternIndex,
      quoteAuthor: initialUserData.quoteAuthor,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
    updateUserData(updatedUserData);
  }

  // ValueListenable<Box<dynamic>> getUserCreatedColors() {
  //   return Hive.box(_userCreatedColorsKey).listenable();
  // }

  // void addUserCreatedColor(UserCreatedColor userCreatedColor) {
  //   Hive.box(_userCreatedColorsKey).add(userCreatedColor);
  // }

  // void deleteUserCreatedColor(int index) {
  //   Hive.box(_userCreatedColorsKey).deleteAt(index);
  // }

  ValueListenable<Box<dynamic>> getDiaryEntries() {
    return Hive.box(_diaryEntriesKey).listenable();
  }

  DiaryEntry addDiaryEntry({
    @required DateTime date,
  }) {
    final DateTime now = DateTime.now();
    final DiaryEntry diaryEntry = DiaryEntry(
      uid: _createUniqueID(),
      date: date.toIso8601String(),
      created: now.millisecondsSinceEpoch,
      lastUpdated: now.millisecondsSinceEpoch,
      title: initialDiaryEntryTitle,
      content: initialDiaryEntryContent,
      moodScore: initialDiaryEntryMoodScore,
      favorite: false,
      backdropPhotoId: initalDiaryEntryBackdropId,
    );

    Hive.box(_diaryEntriesKey).put(diaryEntry.uid, diaryEntry);
    return diaryEntry;
  }

  void updateDiaryEntry(DiaryEntry diaryEntry) {
    Hive.box(_diaryEntriesKey).put(diaryEntry.uid, diaryEntry);
  }

  void updateDiaryEntryBackdrop(DiaryEntry diaryEntry, int newBackdropPhotoId) {
    /// Updated Hive entry
    final DiaryEntry updatedDiaryEntry = DiaryEntry(
      uid: diaryEntry.uid,
      date: diaryEntry.date,
      created: diaryEntry.created,
      lastUpdated: diaryEntry.lastUpdated,
      title: diaryEntry.title,
      content: diaryEntry.content,
      moodScore: diaryEntry.moodScore,
      favorite: diaryEntry.favorite,
      backdropPhotoId: newBackdropPhotoId,
    );

    updateDiaryEntry(updatedDiaryEntry);
  }

  void deleteDiaryEntry(String diaryEntryUid) {
    Hive.box(_diaryEntriesKey).delete(diaryEntryUid);
  }

  bool entryWithDateDoesExist(DateTime date) {
    bool doesExist = false;

    List<dynamic> list =
        HiveDBService().getDiaryEntries().value.values.toList();
    for (dynamic elem in list) {
      // if (convertDateTimeDisplay(elem.date) ==
      //     convertDateTimeDisplay(DateTime.now().toIso8601String())) {
      //   print("found for today");
      // }
      if (elem.date ==
          DateTime(date.year, date.month, date.day).toIso8601String()) {
        doesExist = true;
      }
    }
    return doesExist;
  }

  ValueListenable<Box<dynamic>> getUserCreatedColors() {
    return Hive.box(_userCreatedColorsKey).listenable();
  }

  bool addUserCreatedColor(int alpha, int red, int green, int blue) {
    UserCreatedColor userCreatedColor = UserCreatedColor(
      uid: _createUniqueID(),
      alpha: alpha,
      red: red,
      green: green,
      blue: blue,
    );
    for (UserCreatedColor ucc in Hive.box(_userCreatedColorsKey).values) {
      if (ucc.alpha == alpha &&
          ucc.green == green &&
          ucc.red == red &&
          ucc.blue == blue) {
        return false;
      }
    }
    Hive.box(_userCreatedColorsKey).add(userCreatedColor);
    return true;
  }

  void deleteUserCreatedColor(int index) {
    Hive.box(_userCreatedColorsKey).deleteAt(index);
  }

  void addInitialColors() {
    if (Hive.box(_userCreatedColorsKey).isEmpty) {
      for (Color color in initialColors) {
        addUserCreatedColor(color.alpha, color.red, color.green, color.blue);
      }
    } else {
      print("Initial colors already existing");
    }
  }

  String _createUniqueID() {
    return DateTime.now().millisecondsSinceEpoch.toRadixString(16);
  }
}
