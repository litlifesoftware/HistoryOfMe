import 'package:flutter/material.dart';

import '../localization.dart';

/// A History of Me `localization` class providing localized strings to
/// widgets.
class AppLocalizations {
  /// Creates a [AppLocalizations] object using the provided `locale`.
  AppLocalizations(this.locale);

  /// The device's locale.
  final Locale locale;

  /// Return the [AppLocalizations]'s delegate.
  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  /// Returns the closest [AppLocalizations] object inside the current
  /// `BuildContext`.
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// A list of localized labels, titles and body text elements.
  ///
  /// Currently implemented and supported languages:
  /// * `English`
  /// * `German`
  static const _localizedValues = <String, Map<String, String>>{
    // 'English' localization
    AppLocalizationsEn.languageCode: AppLocalizationsEn.values,
    // 'German' localization
    AppLocalizationsDe.languageCode: AppLocalizationsDe.values,
  };

  /// Returns the currently implemented languages inside the localization map
  /// as their key.
  static List<String> get languages => _localizedValues.keys.toList();

  /// Returns a list of all supported locales.
  ///
  /// This list can be provided to the root [MaterialApp] as `supportedLocales`
  /// member value.
  static const supportedLocales = const [
    // English (no contry code)
    const Locale(AppLocalizationsEn.languageCode),
    // German (no contry code)
    const Locale(AppLocalizationsDe.languageCode),
  ];

  String localizeValue(String localizationKey) {
    return _localizedValues[locale.languageCode]![localizationKey]!;
  }

  String get usernameLabel {
    return localizeValue(AppLocalizationsKeys.usernameLabel);
  }

  String get composeButtonLabel {
    return localizeValue(AppLocalizationsKeys.composeButtonLabel);
  }

  String get createEntryButtonLabel {
    return localizeValue(AppLocalizationsKeys.createEntryButtonLabel);
  }

  String get emptyDiaryBody {
    return localizeValue(AppLocalizationsKeys.emptyDiaryBody);
  }

  String get emptyDiarySubtitle {
    return localizeValue(AppLocalizationsKeys.emptyDiarySubtitle);
  }

  String get personalizeLabel {
    return localizeValue(AppLocalizationsKeys.personalizeLabel);
  }

  String get organizeLabel {
    return localizeValue(AppLocalizationsKeys.organizeLabel);
  }

  String get browseDiaryTitle {
    return localizeValue(AppLocalizationsKeys.browseDiaryTitle);
  }

  String get browseDiaryDescr {
    return localizeValue(AppLocalizationsKeys.browseDiaryDesc);
  }

  String get reliveLabel {
    return localizeValue(AppLocalizationsKeys.reliveLabel);
  }

  String get privateLabel {
    return localizeValue(AppLocalizationsKeys.privateLabel);
  }

  String get readDiaryTitle {
    return localizeValue(AppLocalizationsKeys.readDiaryTitle);
  }

  String get readDiaryDescr {
    return localizeValue(AppLocalizationsKeys.readDiaryDescr);
  }

  String get privacyLabel {
    return localizeValue(AppLocalizationsKeys.privacyLabel);
  }

  String get privacyDescr {
    return localizeValue(AppLocalizationsKeys.privacyDescr);
  }

  String get customizeBookmarkDescr {
    return localizeValue(AppLocalizationsKeys.customizeBookmarkDescr);
  }

  String get customizeBookmarkTitle {
    return localizeValue(AppLocalizationsKeys.customizeBookmarkTitle);
  }

  String get aboutAppLabel {
    return localizeValue(AppLocalizationsKeys.aboutAppLabel);
  }

  String get aboutAppDescr {
    return localizeValue(AppLocalizationsKeys.aboutAppDescr);
  }

  String get userExpericenceDesignLabel {
    return localizeValue(AppLocalizationsKeys.userExpericenceDesignLabel);
  }

  String get developmentLabel {
    return localizeValue(AppLocalizationsKeys.developmentLabel);
  }

  String get photographyLabel {
    return localizeValue(AppLocalizationsKeys.photographyLabel);
  }

  String get inspiredByLabel {
    return localizeValue(AppLocalizationsKeys.inspiredByLabel);
  }

  String get manageBackupLabel {
    return localizeValue(AppLocalizationsKeys.manageBackupLabel);
  }

  String get startTourLabel {
    return localizeValue(AppLocalizationsKeys.startTourLabel);
  }

  String get creditsLabel {
    return localizeValue(AppLocalizationsKeys.creditsLabel);
  }
}
