import 'dart:convert';

import 'package:history_of_me/models.dart';
import 'package:lit_backup_service/lit_backup_service.dart';

/// A `model` class including all required data to create and read backups of
/// the user's diary.
///
/// It implements the [BackupModel] in order to be compatible to the
/// `lit_backup_service` package.
class DiaryBackup implements BackupModel {
  final String appVersion;
  final String backupDate;
  final AppSettings appSettings;
  final List<DiaryEntry> diaryEntries;
  final List<UserCreatedColor> userCreatedColors;
  final UserData userData;

  /// Creates a [DiaryBackup].
  const DiaryBackup({
    required this.appVersion,
    required this.backupDate,
    required this.appSettings,
    required this.diaryEntries,
    required this.userCreatedColors,
    required this.userData,
  });

  /// Creates a [DiaryBackup] based on the provided `Map`.
  factory DiaryBackup.fromJson(Map<String, dynamic> json) {
    /// Extracts all `DiaryEntry` objects into a list.
    final diaryEntries = List<DiaryEntry>.from(
      jsonDecode(json['diaryEntries']).map(
        (item) => DiaryEntry.fromJson(item),
      ),
    );

    /// Extracts all `UserCreatedColor` objects into a list.
    final userCreatedColors = List<UserCreatedColor>.from(
      jsonDecode(json['userCreatedColors']).map(
        (item) => UserCreatedColor.fromJson(item),
      ),
    );

    return DiaryBackup(
      appVersion: json['appVersion'] as String,
      backupDate: json['backupDate'] as String,
      appSettings: AppSettings.fromJson(json['appSettings']),
      diaryEntries: diaryEntries,
      userCreatedColors: userCreatedColors,
      userData: UserData.fromJson(json['userData']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final diaryEntriesMap =
        jsonEncode(diaryEntries.map((item) => item.toJson()).toList());
    final userCreatedColorsMap =
        jsonEncode(userCreatedColors.map((item) => item.toJson()).toList());
    return {
      'appVersion': appVersion,
      'backupDate': backupDate,
      'appSettings': appSettings.toJson(),
      'diaryEntries': diaryEntriesMap,
      'userCreatedColors': userCreatedColorsMap,
      'userData': userData.toJson(),
    };
  }
}
