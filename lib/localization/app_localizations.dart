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

  String get noFavoritesAvailLabel {
    return localizeValue(AppLocalizationsKeys.noFavoritesAvailLabel);
  }

  String get noFavoritesAvailDescr {
    return localizeValue(AppLocalizationsKeys.noFavoritesAvailDescr);
  }

  String get greetingLabel {
    return localizeValue(AppLocalizationsKeys.greetingLabel);
  }

  String get welcomeBackLabel {
    return localizeValue(AppLocalizationsKeys.welcomeBackLabel);
  }

  String get changeNameLabel {
    return localizeValue(AppLocalizationsKeys.changeNameLabel);
  }

  String get changeYourNameLabel {
    return localizeValue(AppLocalizationsKeys.changeYourNameLabel);
  }

  String get creatorLabel {
    return localizeValue(AppLocalizationsKeys.creatorLabel);
  }

  String get creatorDescr {
    return localizeValue(AppLocalizationsKeys.creatorDescr);
  }

  String get detailsLabel {
    return localizeValue(AppLocalizationsKeys.detailsLabel);
  }

  String get locationLabel {
    return localizeValue(AppLocalizationsKeys.locationLabel);
  }

  String get publishedLabel {
    return localizeValue(AppLocalizationsKeys.publishedLabel);
  }

  String get entrySavedDescr {
    return localizeValue(AppLocalizationsKeys.entrySavedDescr);
  }

  String get savedLabel {
    return localizeValue(AppLocalizationsKeys.savedLabel);
  }

  String get untitledLabel {
    return localizeValue(AppLocalizationsKeys.untitledLabel);
  }

  String get yourMoodLabel {
    return localizeValue(AppLocalizationsKeys.yourMoodLabel);
  }

  String get statisticsLabel {
    return localizeValue(AppLocalizationsKeys.statisticsLabel);
  }

  String get noEntriesAvailLabel {
    return localizeValue(AppLocalizationsKeys.noEntriesAvailLabel);
  }

  String get noEntriesAvailDescr {
    return localizeValue(AppLocalizationsKeys.diaryFallbackDescr);
  }

  String get statisticsFallbackDescr {
    return localizeValue(AppLocalizationsKeys.statisticsFallbackDescr);
  }

  String get statisticsFallbackActionLabel {
    return localizeValue(AppLocalizationsKeys.statisticsFallbackActionLabel);
  }

  String get diaryEntriesLabel {
    return localizeValue(AppLocalizationsKeys.diaryEntriesLabel);
  }

  String get avgMoodLabel {
    return localizeValue(AppLocalizationsKeys.avgMoodLabel);
  }

  String get wordsWrittenLabel {
    return localizeValue(AppLocalizationsKeys.wordsWrittenLabel);
  }

  String get wordsPerEntryLabel {
    return localizeValue(AppLocalizationsKeys.wordsPerEntryLabel);
  }

  String get mostWordsAtOnceLabel {
    return localizeValue(AppLocalizationsKeys.mostWordsAtOnceLabel);
  }

  String get fewestWordsAtOnceLabel {
    return localizeValue(AppLocalizationsKeys.fewestWordsAtOnceLabel);
  }

  String get entriesThisWeekLabel {
    return localizeValue(AppLocalizationsKeys.entriesThisWeekLabel);
  }

  String get entriesThisMonthLabel {
    return localizeValue(AppLocalizationsKeys.entriesThisMonthLabel);
  }

  String get lastestEntryLabel {
    return localizeValue(AppLocalizationsKeys.lastestEntryLabel);
  }

  String get firstEntryLabel {
    return localizeValue(AppLocalizationsKeys.firstEntryLabel);
  }

  String get lessLabel {
    return localizeValue(AppLocalizationsKeys.lessLabel);
  }

  String get moreLabel {
    return localizeValue(AppLocalizationsKeys.moreLabel);
  }

  String get selectMainColorLabel {
    return localizeValue(AppLocalizationsKeys.selectMainColorLabel);
  }

  String get selectAccentColorLabel {
    return localizeValue(AppLocalizationsKeys.selectAccentColorLabel);
  }

  String get createLabel {
    return localizeValue(AppLocalizationsKeys.createLabel);
  }

  String get stripesLabel {
    return localizeValue(AppLocalizationsKeys.stripesLabel);
  }

  String get dotsLabel {
    return localizeValue(AppLocalizationsKeys.dotsLabel);
  }

  String get mainColorLabel {
    return localizeValue(AppLocalizationsKeys.mainColorLabel);
  }

  String get duplicateColorDescr {
    return localizeValue(AppLocalizationsKeys.duplicateColorDescr);
  }

  String get entryLabel {
    return localizeValue(AppLocalizationsKeys.entryLabel);
  }

  String get entriesLabel {
    return localizeValue(AppLocalizationsKeys.entriesLabel);
  }

  String get favoriteEntryLabel {
    return localizeValue(AppLocalizationsKeys.favoriteEntryLabel);
  }

  String get favoriteEntriesLabel {
    return localizeValue(AppLocalizationsKeys.favoriteEntriesLabel);
  }

  String get allLabel {
    return localizeValue(AppLocalizationsKeys.allLabel);
  }

  String get latestLabel {
    return localizeValue(AppLocalizationsKeys.latestLabel);
  }

  String get unsavedLabel {
    return localizeValue(AppLocalizationsKeys.unsavedLabel);
  }

  String get newDiaryTitle {
    return localizeValue(AppLocalizationsKeys.newDiaryTitle);
  }

  String get newDiarySubtitle {
    return localizeValue(AppLocalizationsKeys.newDiarySubtitle);
  }

  String get startJourneyTitle {
    return localizeValue(AppLocalizationsKeys.startJourneyTitle);
  }

  String get diaryOfLabel {
    return localizeValue(AppLocalizationsKeys.diaryOfLabel);
  }

  String get restoreDiaryTitle {
    return localizeValue(AppLocalizationsKeys.restoreDiaryTitle);
  }

  String get continueJourneyTitle {
    return localizeValue(AppLocalizationsKeys.continueJourneyTitle);
  }

  String get restoreLabel {
    return localizeValue(AppLocalizationsKeys.restoreLabel);
  }

  String get cancelRestoreDescr {
    return localizeValue(AppLocalizationsKeys.cancelRestoreDescr);
  }

  String get createdOnLabel {
    return localizeValue(AppLocalizationsKeys.createdOnLabel);
  }

  String get selectBackupTitle {
    return localizeValue(AppLocalizationsKeys.selectBackupTitle);
  }

  String get restoreFromBackupTitle {
    return localizeValue(AppLocalizationsKeys.restoreFromBackupTitle);
  }

  String get unsupportedFileTitle {
    return localizeValue(AppLocalizationsKeys.unsupportedFileTitle);
  }

  String get unsupportedFileDescr {
    return localizeValue(AppLocalizationsKeys.unsupportedFileDescr);
  }

  String get backupFileRequiredTitle {
    return localizeValue(AppLocalizationsKeys.backupFileRequiredTitle);
  }

  String get backupFileRequiredDescr {
    return localizeValue(AppLocalizationsKeys.backupFileRequiredDescr);
  }

  String get pickFileLabel {
    return localizeValue(AppLocalizationsKeys.pickFileLabel);
  }

  String get storagePermissionDeniedTitle {
    return localizeValue(AppLocalizationsKeys.storagePermissionDeniedTitle);
  }

  String get storagePermissionDeniedDescr {
    return localizeValue(AppLocalizationsKeys.storagePermissionDeniedDescr);
  }

  String get requestPermissionLabel {
    return localizeValue(AppLocalizationsKeys.requestPermissionLabel);
  }

  String get foundDiaryTitle {
    return localizeValue(AppLocalizationsKeys.foundDiaryTitle);
  }

  String get lastEditedLabel {
    return localizeValue(AppLocalizationsKeys.lastEditedLabel);
  }

  String get nextLabel {
    return localizeValue(AppLocalizationsKeys.nextLabel);
  }

  String get previousLabel {
    return localizeValue(AppLocalizationsKeys.previousLabel);
  }

  String get optionsLabel {
    return localizeValue(AppLocalizationsKeys.optionsLabel);
  }

  String get firstLabel {
    return localizeValue(AppLocalizationsKeys.firstLabel);
  }

  String get emptyEntryTitle {
    return localizeValue(AppLocalizationsKeys.emptyEntryTitle);
  }

  String get emptyEntryDescr {
    return localizeValue(AppLocalizationsKeys.emptyEntryDescr);
  }

  String get editLabel {
    return localizeValue(AppLocalizationsKeys.editLabel);
  }

  String get emptyEntryActionDescr {
    return localizeValue(AppLocalizationsKeys.emptyEntryActionDescr);
  }

  String get badLabel {
    return localizeValue(AppLocalizationsKeys.badLabel);
  }

  String get goodLabel {
    return localizeValue(AppLocalizationsKeys.goodLabel);
  }

  String get alrightLabel {
    return localizeValue(AppLocalizationsKeys.alrightLabel);
  }

  String get quoteLabel {
    return localizeValue(AppLocalizationsKeys.quoteLabel);
  }

  String get quoteSubtitle {
    return localizeValue(AppLocalizationsKeys.quoteSubtitle);
  }

  String get byLabel {
    return localizeValue(AppLocalizationsKeys.byLabel);
  }

  String get accentColorLabel {
    return localizeValue(AppLocalizationsKeys.accentColorLabel);
  }

  String get choosePhotoLabel {
    return localizeValue(AppLocalizationsKeys.choosePhotoLabel);
  }

  String get selectedLabel {
    return localizeValue(AppLocalizationsKeys.selectedLabel);
  }
}
