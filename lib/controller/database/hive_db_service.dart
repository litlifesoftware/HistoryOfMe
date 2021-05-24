import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/model/app_settings.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A controller class to access the [Hive] database API.
///
/// It includes methods to fetch data from the local Hive instance and to update or
/// delete a specific entry on the database.
class HiveDBService {
  final bool debug;

  /// Creates a [HiveDBService].
  ///
  /// * [debug] states whether to show console output to log current activity.
  const HiveDBService({this.debug = false});
  Future<void> initHiveDB() async {
    await Hive.initFlutter();
    //Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(UserDataAdapter());
    Hive.registerAdapter(UserCreatedColorAdapter());
    Hive.registerAdapter(DiaryEntryAdapter());
  }

  /// The key to access the [AppSettings] Box.
  static const String _appSettingsKey = 'app_settings';
  static const String _userDataKey = 'app_settings';
  static const String _userCreatedColorsKey = 'user_created_colors';
  static const String _diaryEntriesKey = 'diary_entries';

  /// Opens the [AppSettings] Box.
  Future<Box<AppSettings>> openAppSettingsBox() {
    if (!Hive.isBoxOpen(_appSettingsKey)) {
      return Hive.openBox<AppSettings>(_appSettingsKey);
    } else {
      return Future(() {
        return Hive.box<AppSettings>(_appSettingsKey);
      });
    }
  }

  /// Opens the [UserData] Box.
  Future<Box<UserData>> openUserDataBox() {
    if (!Hive.isBoxOpen(_userDataKey)) {
      return Hive.openBox<UserData>(_userDataKey);
    } else {
      return Future(() {
        return Hive.box<UserData>(_userDataKey);
      });
    }
  }

  /// Opens the [DiaryEntry] Box.
  Future<Box<DiaryEntry>> openDiaryEntryDataBox() {
    if (!Hive.isBoxOpen(_diaryEntriesKey)) {
      return Hive.openBox<DiaryEntry>(_diaryEntriesKey);
    } else {
      return Future(() {
        return Hive.box<DiaryEntry>(_diaryEntriesKey);
      });
    }
  }

  /// Opens the [UserCreatedColor].
  Future<Box<UserCreatedColor>> openUserCreatedColorsDataBox() {
    if (!Hive.isBoxOpen(_userCreatedColorsKey)) {
      return Hive.openBox<UserCreatedColor>(_userCreatedColorsKey);
    } else {
      return Future(() {
        return Hive.box<UserCreatedColor>(_userCreatedColorsKey);
      });
    }
  }

  /// Opens all [Box]es used across the app.
  ///
  /// Returns an integer value to state whether opening the [Box]es was successful.
  Future<int> openBoxes() async {
    try {
      //await openAppSettingsBox();
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

  /// Gets the [AppSettings] from the Hive box as a [ValueListenable].
  ValueListenable<Box<AppSettings>> getAppSettings() {
    return Hive.box<AppSettings>(_appSettingsKey).listenable();
  }

  /// Updates the [AppSettings].
  void updateAppSettings(AppSettings appSettings) {
    Hive.box<AppSettings>(_appSettingsKey).putAt(0, appSettings);
  }

  /// Gets the [UserData] from the Hive box as a [ValueListenable].
  ValueListenable<Box<UserData>> getUserData() {
    return Hive.box<UserData>(_userDataKey).listenable();
  }

  /// Stores the initial [UserData] model to the Hive database on the first app startup.
  ///
  /// The provided username must be obtained by the user.
  void createUserData(String username) {
    final int timeStampNow = DateTime.now().millisecondsSinceEpoch;
    final UserData userData = UserData(
      name: username,
      primaryColor: initialPrimaryColor,
      secondaryColor: initialSecondayColor,
      stripeCount: minStripeCount,
      dotSize: minDotSize,
      animated: true,
      quote: initialQuote,
      designPatternIndex: initialDesignPatternIndex,
      quoteAuthor: initialQuoteAuthor,
      lastUpdated: timeStampNow,
      created: timeStampNow,
    );
    if (Hive.box<UserData>(_userDataKey).isEmpty) {
      Hive.box<UserData>(_userDataKey).add(userData);
    } else {
      print("UserData object already created");
    }
  }

  /// Updates the [UserData] model in the database using the provided [UserData].
  ///
  /// Note that all existing value will be overridden on excecution, so the provided
  /// [UserData] should hold non-null values.
  void updateUserData(UserData userData) {
    Hive.box<UserData>(_userDataKey).putAt(0, userData);
  }

  /// Updates the [UserData]'s username property value on the Hive database.
  ///
  /// * [userData] is required in order to retain the existing values on the
  ///   Hive database in order to only update the username.
  ///
  /// * [updatedName] is the new username that should be stored on the database.
  void updateUsername(UserData userData, String updatedName) {
    UserData updatedUserData = UserData(
      name: updatedName,
      primaryColor: userData.primaryColor,
      secondaryColor: userData.secondaryColor,
      stripeCount: userData.stripeCount,
      dotSize: userData.dotSize,
      animated: userData.animated,
      quote: userData.quote,
      designPatternIndex: userData.designPatternIndex,
      quoteAuthor: userData.quoteAuthor,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
      created: userData.created,
    );
    updateUserData(updatedUserData);
  }

  /// Gets the [DiaryEntry]s from the Hive box as a [ValueListenable].
  ///
  /// The [Box] is structured like a list, each [DiaryEntry] available should be able
  /// to be extracted from the box itself.
  ValueListenable<Box<DiaryEntry>> getDiaryEntries() {
    return Hive.box<DiaryEntry>(_diaryEntriesKey).listenable();
  }

  /// Adds a new diary entry to the Hive database.
  ///
  /// * [date] is the date of the dairy entry, that should be set as the entry's actual
  ///   date.
  DiaryEntry addDiaryEntry({
    required DateTime date,
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

    Hive.box<DiaryEntry>(_diaryEntriesKey).put(diaryEntry.uid, diaryEntry);
    return diaryEntry;
  }

  /// Updates an existing diary entry on the Hive database using the provided updated
  /// [diaryEntry].
  ///
  /// The Hive entry will be determine using the [DiaryEntry]'s uid
  void updateDiaryEntry(DiaryEntry diaryEntry) {
    Hive.box<DiaryEntry>(_diaryEntriesKey).put(diaryEntry.uid, diaryEntry);
  }

  /// Updates the background on the provided [DiaryEntry] by updating the database entry.
  ///
  /// * [newBackdropPhotoId] is the new backdrop id value.
  /// * [diaryEntry] is entry on which the change will be applied. It will also provided
  ///   the entrie's id.
  void updateDiaryEntryBackdrop(DiaryEntry diaryEntry, int newBackdropPhotoId) {
    /// Updated diary entry
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

  /// Toggles the 'favorite' value on the provided [DiaryEntry].
  void toggleDiaryEntryFavorite(DiaryEntry diaryEntry) {
    /// Updated diary entry
    DiaryEntry updatedDiaryEntry = DiaryEntry(
      uid: diaryEntry.uid,
      date: diaryEntry.date,
      created: diaryEntry.created,
      lastUpdated: diaryEntry.lastUpdated,
      title: diaryEntry.title,
      content: diaryEntry.content,
      moodScore: diaryEntry.moodScore,
      favorite: !(diaryEntry.favorite),
      backdropPhotoId: diaryEntry.backdropPhotoId,
    );

    updateDiaryEntry(updatedDiaryEntry);
  }

  /// Deletes an existing [DiaryEntry].
  ///
  /// * [diaryEntryUid] is the [DiaryEntry]'s uid value which will act like an key.
  void deleteDiaryEntry(String? diaryEntryUid) {
    Hive.box<DiaryEntry>(_diaryEntriesKey).delete(diaryEntryUid);
  }

  /// States whether a [DiaryEntry] for a specified date already exists.
  bool entryWithDateDoesExist(DateTime? date) {
    bool doesExist = false;

    List<dynamic> list =
        HiveDBService().getDiaryEntries().value.values.toList();
    for (dynamic elem in list) {
      // if (convertDateTimeDisplay(elem.date) ==
      //     convertDateTimeDisplay(DateTime.now().toIso8601String())) {
      //   print("found for today");
      // }
      if (elem.date ==
          DateTime(date!.year, date.month, date.day).toIso8601String()) {
        doesExist = true;
      }
    }
    return doesExist;
  }

  /// Gets the [UserCreatedColor] from the Hive box as a [ValueListenable].
  ValueListenable<Box<UserCreatedColor>> getUserCreatedColors() {
    return Hive.box<UserCreatedColor>(_userCreatedColorsKey).listenable();
  }

  /// Adds an [UserCreatedColor] to the database.
  ///
  /// The validation will include a check to ensure only non-existing colors
  /// will be added to the database. If the provided colors do match with an
  /// existing entry, the color will not be added and an Exception is thrown.
  void addUserCreatedColor(int alpha, int red, int green, int blue) {
    UserCreatedColor userCreatedColor = UserCreatedColor(
      uid: _createUniqueID(),
      alpha: alpha,
      red: red,
      green: green,
      blue: blue,
    );
    for (UserCreatedColor ucc
        in Hive.box<UserCreatedColor>(_userCreatedColorsKey).values) {
      bool alphaMatch = ucc.alpha == alpha;
      bool gMatch = ucc.green == green;
      bool rMatch = ucc.red == red;
      bool bMatch = ucc.blue == blue;
      if (alphaMatch && gMatch && rMatch && bMatch) {
        if (debug)
          print("'UserCreatedColor' with provided values already exists.");
        throw Exception("Color does already exist.");
      }
    }
    Hive.box<UserCreatedColor>(_userCreatedColorsKey).add(userCreatedColor);
  }

  void deleteUserCreatedColor(int index) {
    Hive.box<UserCreatedColor>(_userCreatedColorsKey).deleteAt(index);
  }

  void addInitialColors() {
    if (Hive.box<UserCreatedColor>(_userCreatedColorsKey).isEmpty) {
      for (Color color in initialColors) {
        addUserCreatedColor(color.alpha, color.red, color.green, color.blue);
      }
    } else {
      print("Initial colors already existing");
    }
  }

  String _createUniqueID() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int salt = Random().nextInt(1024);
    String timestampHash = timestamp.toRadixString(16);
    String saltHash = salt.toRadixString(16);
    return "$timestampHash$saltHash";
  }
}
