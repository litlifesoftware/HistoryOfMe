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

  /// Returns the currently implemented languages as their two-letter code.
  static List<String> languages() => _localizedValues.keys.toList();

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
}
