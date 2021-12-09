import 'package:history_of_me/localization.dart';

/// The `en` language implementation of the [AppLocalizations].
class AppLocalizationsEn {
  /// The language code of English-speaking locales.
  static const languageCode = 'en';

  /// The localized values.
  static const values = const {
    AppLocalizationsKeys.composeButtonLabel: 'Compose',
    AppLocalizationsKeys.createEntryButtonLabel: 'Create Entry',
    AppLocalizationsKeys.usernameLabel: 'Your name',
    AppLocalizationsKeys.emptyDiarySubtitle: 'No entires available',
    AppLocalizationsKeys.emptyDiaryBody:
        "There are no entries available. Do you want to create your first entry now?",
  };
}
