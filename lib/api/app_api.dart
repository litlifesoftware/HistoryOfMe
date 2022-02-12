part of api;

/// A controller class to access the [Hive] database API.
///
/// It includes methods to fetch data from the local Hive instance and to update or
/// delete a specific entry on the database.
class AppAPI {
  final bool debug;

  /// Creates a [AppAPI].
  ///
  /// * [debug] states whether to show console output to log current activity.
  const AppAPI({this.debug = false});

  /// Initializes the local `Hive` database.
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserDataAdapter());
    Hive.registerAdapter(UserCreatedColorAdapter());
    Hive.registerAdapter(DiaryEntryAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
  }

  /// The default index on a box where single objects are stored (such as the
  /// [AppSettings]).
  static const defaultEntryIndex = 0;

  /// The key to access the [AppSettings] Box.
  ///
  /// This key needed to be renamed to `local_settings` to avoid name
  /// conflicts with the [_userDataKey].
  static const String _appSettingsKey = 'local_settings';

  /// The key to access the [AppSettings] Box.
  ///
  /// This key was mistakenly named `app_settings`. This key was actually
  /// reserved for the [AppSettings] model. `app_settings` must continue to be
  /// used to avoid existing data to be lost after a rename.
  static const String _userDataKey = 'app_settings';

  /// The key to access the [UserCreatedColor] Box.
  static const String _userCreatedColorsKey = 'user_created_colors';

  /// The key to access the [DiaryEntry] Box.
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

  /// Opens all [Box] instances chronologically.
  ///
  /// The boxes must be opened in the correct order as defined on the
  /// `@HiveType` annotion provided by the model class.
  ///
  /// Returns an integer value to state whether the opening was successful.
  Future<int> openBoxes() async {
    try {
      await openUserDataBox();
      await openUserCreatedColorsDataBox();
      await openDiaryEntryDataBox();
      await openAppSettingsBox();
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

  /// Returns the default app settings.
  AppSettings get defaultAppSettings {
    return AppSettings(
      privacyPolicyAgreed: DefaultData.agreedPrivacy,
      darkMode: DefaultData.darkMode,
      tabIndex: DefaultData.tabIndex,
      installationID: generateInstallationID(),
      lastBackup: "",
    );
  }

  /// Returns cleaned app settings. This should be used to transfer backed up
  /// data to the database.
  AppSettings _createClearnAppSettings(AppSettings appSettings) {
    return AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.darkMode,
      tabIndex: 0,
      installationID: generateInstallationID(),
      lastBackup: "",
    );
  }

  /// Creates an initial [AppSettings] instance using the default values.
  void createAppSettings() {
    if (Hive.box<AppSettings>(_appSettingsKey).isEmpty) {
      Hive.box<AppSettings>(_appSettingsKey).add(defaultAppSettings);
    } else {
      print("AppSettings object already created");
    }
  }

  /// Restores the app settings box using the provided object.
  void restoreAppSettings(AppSettings appSettings) {
    if (Hive.box<AppSettings>(_appSettingsKey).isEmpty) {
      Hive.box<AppSettings>(_appSettingsKey)
          .add(_createClearnAppSettings(appSettings));
    } else {
      print("'AppSettings' already existing. Restoring failed.");
    }
  }

  /// Updates the [AppSettings].
  void updateAppSettings(AppSettings appSettings) {
    Hive.box<AppSettings>(_appSettingsKey).putAt(0, appSettings);
  }

  /// Updates the [AppSettings] instance using the provided `tabIndex` value.
  void updateTabIndex(AppSettings appSettings, int tabIndex) {
    AppSettings updatedAppSettings = AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.darkMode,
      tabIndex: tabIndex,
      installationID: appSettings.installationID,
      lastBackup: appSettings.lastBackup,
    );
    updateAppSettings(updatedAppSettings);
  }

  /// Updates the [AppSettings] instance using the provided `lastBackup` value.
  void updateLastBackup(AppSettings appSettings, DateTime lastBackup) {
    AppSettings updatedAppSettings = AppSettings(
      privacyPolicyAgreed: appSettings.privacyPolicyAgreed,
      darkMode: appSettings.darkMode,
      tabIndex: appSettings.tabIndex,
      installationID: appSettings.installationID,
      lastBackup: lastBackup.toIso8601String(),
    );
    updateAppSettings(updatedAppSettings);
  }

  /// Gets the [UserData] from the Hive box as a [ValueListenable].
  ValueListenable<Box<UserData>> getUserData() {
    return Hive.box<UserData>(_userDataKey).listenable();
  }

  /// Stores the initial [UserData] model to the Hive database on the first app
  /// startup.
  ///
  /// The provided username must be obtained by the user.
  void createUserData(String username) {
    final int timeStampNow = DateTime.now().millisecondsSinceEpoch;
    final UserData userData = UserData(
      name: username,
      primaryColor: DefaultData.primaryColor,
      secondaryColor: DefaultData.secondaryColors,
      stripeCount: DefaultData.minStripeCount,
      dotSize: DefaultData.minDotSize,
      animated: true,
      quote: DefaultData.quote,
      designPatternIndex: DefaultData.designPatternIndex,
      quoteAuthor: DefaultData.quoteAuthor,
      lastUpdated: timeStampNow,
      created: timeStampNow,
    );
    if (Hive.box<UserData>(_userDataKey).isEmpty) {
      Hive.box<UserData>(_userDataKey).add(userData);
    } else {
      print("UserData object already created");
    }
  }

  void restoreUserData(UserData userData) {
    if (Hive.box<UserData>(_userDataKey).isEmpty) {
      Hive.box<UserData>(_userDataKey).add(userData);
    } else {
      print("'UserData' already existing. Restoring failed.");
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
      uid: _generateUniqueID(),
      date: date.toIso8601String(),
      created: now.millisecondsSinceEpoch,
      lastUpdated: now.millisecondsSinceEpoch,
      title: DefaultData.diaryEntryTitle,
      content: DefaultData.diaryEntryContent,
      moodScore: DefaultData.diaryEntryMoodScore,
      favorite: false,
      backdropPhotoId: DefaultData.diaryEntryBackdropId,
    );

    Hive.box<DiaryEntry>(_diaryEntriesKey).put(diaryEntry.uid, diaryEntry);
    return diaryEntry;
  }

  /// Restores the diary entry box using the provided diary entry list.
  Future<void> addDiaryEntryBatch({
    required List<DiaryEntry> diaryEntries,
  }) async {
    for (DiaryEntry entry in diaryEntries) {
      Hive.box<DiaryEntry>(_diaryEntriesKey).put(entry.uid, entry);
    }
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

    List<dynamic> list = AppAPI().getDiaryEntries().value.values.toList();
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
      uid: _generateUniqueID(),
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

  Future<void> addUserCreatedColorBatch({
    required List<UserCreatedColor> userCreatedColors,
  }) async {
    for (UserCreatedColor ucc in userCreatedColors) {
      try {
        addUserCreatedColor(ucc.alpha, ucc.red, ucc.green, ucc.blue);
      } catch (e) {
        print("'UserCreatedColor' with provided values already exists.");
      }
    }
  }

  void deleteUserCreatedColor(int index) {
    Hive.box<UserCreatedColor>(_userCreatedColorsKey).deleteAt(index);
  }

  void addInitialColors() {
    if (Hive.box<UserCreatedColor>(_userCreatedColorsKey).isEmpty) {
      for (Color color in DefaultData.userCreatedColorValues) {
        addUserCreatedColor(color.alpha, color.red, color.green, color.blue);
      }
    } else {
      print("Initial colors already existing");
    }
  }

  /// Generates a unique id.
  String _generateUniqueID() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int salt = Random().nextInt(1024);
    String timestampHash = timestamp.toRadixString(16);
    String saltHash = salt.toRadixString(16);
    return "$timestampHash$saltHash";
  }

  /// Generates a installation id.
  static String generateInstallationID() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    return timestamp.toRadixString(16);
  }

  /// Rebuilds the `Hive` database using the provided backup object.
  Future<void> rebuildDatabase(DiaryBackup backup) async {
    restoreAppSettings(backup.appSettings);
    print("'AppSettings' restored from Backup.");
    restoreUserData(backup.userData);
    print("'UserData' restored from Backup.");
    await addDiaryEntryBatch(diaryEntries: backup.diaryEntries);
    print("'DiaryEntry' objects restored from Backup.");
    await addUserCreatedColorBatch(userCreatedColors: backup.userCreatedColors);
    print("'UserCreatedColor' objects restored from Backup.");
    print("Successfully restored database.");
  }
}
