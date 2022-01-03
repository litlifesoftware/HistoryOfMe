import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/model/models.dart';
import 'package:hive/hive.dart';

/// A `provider` widget allowing to pass all data stored on the `Hive` database
/// onto its child Widget using the [builder] method.
///
/// Accessing all data at once is rather expensive on memory but required to
/// e.g. create backupable objects.
///
class AllDataProvider extends StatefulWidget {
  /// `builder` method allowing to access all data available on its child.
  final Widget Function(
      BuildContext context,
      AppSettings appSettings,
      UserData userData,
      List<DiaryEntry> diaryEntries,
      List<UserCreatedColor> userCreatedColors) builder;

  /// Creates an [AllDataProvider] that provides all data stored on the `Hive`
  /// database.
  const AllDataProvider({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _AllDataProviderState createState() => _AllDataProviderState();
}

class _AllDataProviderState extends State<AllDataProvider> {
  final AppAPI _api = AppAPI();

  late DatabaseStateValidator _validator;

  /// Extract the main object used from the [AppSettings]'s `Box`.

  AppSettings _getAppSettings(Box<AppSettings> appSettingsBox) {
    return appSettingsBox.getAt(0)!;
  }

  /// Extract the main object used from the [UserData]'s `Box`.

  UserData _getUserData(Box<UserData> userDataBox) {
    return userDataBox.getAt(0)!;
  }

  /// Extracts the [DiaryEntry]'s `Box` content into a `List`.

  List<DiaryEntry> _getEntries(Box<DiaryEntry> diaryEntryBox) {
    return diaryEntryBox.values.toList();
  }

  /// Extracts the [UserCreatedColor]'s `Box` content into a `List`.

  List<UserCreatedColor> _getCreatedColors(
    Box<UserCreatedColor> userCreatedColorBox,
  ) {
    return userCreatedColorBox.values.toList();
  }

  void _validateAppSettings(Box<AppSettings> appSettingsBox) {
    final appSettings = appSettingsBox.getAt(0);
    if (appSettings != null) {
      _validator.validateAppSettings(appSettings);
    }
  }

  @override
  void initState() {
    _validator = DatabaseStateValidator(api: _api);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _api.getAppSettings(),
      builder: (context, Box<AppSettings> appSettingsBox, _) {
        _validateAppSettings(appSettingsBox);
        return ValueListenableBuilder(
          valueListenable: _api.getUserData(),
          builder: (context, Box<UserData> userDataBox, _) {
            return ValueListenableBuilder(
              valueListenable: _api.getDiaryEntries(),
              builder: (context, Box<DiaryEntry> diaryEntryBox, _) {
                return ValueListenableBuilder(
                  valueListenable: _api.getUserCreatedColors(),
                  builder:
                      (context, Box<UserCreatedColor> userCreatedColorBox, _) {
                    final UserData userData = _getUserData(userDataBox);
                    final appSettings = _getAppSettings(appSettingsBox);
                    final diaryEntries = _getEntries(diaryEntryBox);
                    final userCreatedColors =
                        _getCreatedColors(userCreatedColorBox);

                    return widget.builder(
                      context,
                      appSettings,
                      userData,
                      diaryEntries,
                      userCreatedColors,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
