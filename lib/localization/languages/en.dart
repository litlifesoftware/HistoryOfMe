part of localization;

/// The `en` language implementation of the [AppLocalizations].
class EN {
  /// The language code of English-speaking locales.
  static const languageCode = 'en';

  /// The localized values.
  static const values = const {
    AppLocalizationsKeys.createEntryLabel: 'Create Entry',
    AppLocalizationsKeys.usernameLabel: 'Your name',
    AppLocalizationsKeys.emptyDiarySubtitle: 'No entires available',
    AppLocalizationsKeys.emptyDiaryBody:
        "There are no entries available. Do you want to create your first entry now?",
    AppLocalizationsKeys.personalizeLabel: 'Personalize',
    AppLocalizationsKeys.organizeLabel: 'Organize',
    AppLocalizationsKeys.browseDiaryTitle: 'Browse through your diary',
    AppLocalizationsKeys.browseDiaryDesc:
        'History of Me offers you your own personal diary. You can browse through all your diary entries and organize your writings.',
    AppLocalizationsKeys.reliveLabel: 'Relive',
    AppLocalizationsKeys.privateLabel: 'private',
    AppLocalizationsKeys.readDiaryTitle: 'Read your diary entries',
    AppLocalizationsKeys.readDiaryDescr:
        'Tap on one of the entires on your diary in order to read an entry and to relive your memories.',
    AppLocalizationsKeys.privacyDescr:
        'History of Me\'s goal is to provide the most private experience available on mobile devices. Your data will always remain on your device. The creator of the app nor any third party will be able to view your content. There is no connection to the internet, all required data to use the app will be stored offline.',
    AppLocalizationsKeys.customizeBookmarkTitle: 'Customize your bookmark',
    AppLocalizationsKeys.customizeBookmarkDescr:
        'Can you see the bookmark on top of your diary? You can customize it. Go to your profile and tap on the pencil under your bookmark to edit it. Set your favorite color pallet and a nice pattern. Don\'t forget to save your changes!',
    AppLocalizationsKeys.aboutAppDescr: 'Your own personal diary.',
    AppLocalizationsKeys.inspiredByLabel: 'Inspired by',
    AppLocalizationsKeys.noFavoritesAvailLabel: 'No favorites available',
    AppLocalizationsKeys.noFavoritesAvailDescr:
        'Add an entry to your favorites on your diary entry.',
    AppLocalizationsKeys.greetingLabel: 'How are you today?',
    AppLocalizationsKeys.welcomeBackLabel: 'Welcome back',
    AppLocalizationsKeys.changeNameLabel: 'Change name',
    AppLocalizationsKeys.changeYourNameLabel: 'Change your name',
    AppLocalizationsKeys.creatorDescr:
        'What the creator is telling us about this photo',
    AppLocalizationsKeys.detailsLabel: 'Details',
    AppLocalizationsKeys.entrySavedDescr: 'Your diary entry has been saved.',
    AppLocalizationsKeys.untitledLabel: 'Untitled',
    AppLocalizationsKeys.yourMoodLabel: 'your mood',
    AppLocalizationsKeys.noEntriesAvailLabel: 'No entries available',
    AppLocalizationsKeys.statisticsFallbackDescr:
        'In order to show your statistics, you should have atleast one entry created.',
    AppLocalizationsKeys.statisticsFallbackActionLabel:
        'Go back to your diary to create your first entry.',
    AppLocalizationsKeys.diaryFallbackDescr:
        'There are no entries available. Would you like to create your first entry now?',
    AppLocalizationsKeys.diaryEntriesLabel: 'Diary entries',
    AppLocalizationsKeys.avgMoodLabel: 'Average mood',
    AppLocalizationsKeys.wordsWrittenLabel: 'Words written',
    AppLocalizationsKeys.wordsPerEntryLabel: 'Words per entry',
    AppLocalizationsKeys.mostWordsAtOnceLabel: 'Most words at once',
    AppLocalizationsKeys.fewestWordsAtOnceLabel: 'Fewest words at once',
    AppLocalizationsKeys.entriesThisWeekLabel: 'Entries this week',
    AppLocalizationsKeys.entriesThisMonthLabel: 'Entries this month',
    AppLocalizationsKeys.lastestEntryLabel: 'Latest entry',
    AppLocalizationsKeys.firstEntryLabel: 'First entry',
    AppLocalizationsKeys.selectMainColorLabel: 'Select a main color',
    AppLocalizationsKeys.selectAccentColorLabel: 'Select an accent color',
    AppLocalizationsKeys.createLabel: 'create',
    AppLocalizationsKeys.dotsLabel: 'Dots',
    AppLocalizationsKeys.stripesLabel: 'Stripes',
    AppLocalizationsKeys.mainColorLabel: 'main color',
    AppLocalizationsKeys.duplicateColorDescr:
        'This color is already available.',
    AppLocalizationsKeys.entryLabel: 'entry',
    AppLocalizationsKeys.entriesLabel: 'entries',
    AppLocalizationsKeys.favoriteEntryLabel: 'favorite entry',
    AppLocalizationsKeys.favoriteEntriesLabel: 'favorite entries',
    AppLocalizationsKeys.newDiaryTitle: 'New Diary',
    AppLocalizationsKeys.newDiarySubtitle: 'Create new Diary',
    AppLocalizationsKeys.startJourneyTitle: 'Start a new journey',
    AppLocalizationsKeys.diaryOfLabel: 'Diary of',
    AppLocalizationsKeys.restoreDiaryTitle: 'Restore your diary',
    AppLocalizationsKeys.continueJourneyTitle: 'Continue your journey',
    AppLocalizationsKeys.cancelRestoreDescr:
        'Do you want to create a new diary instead of restoring your previous one?',
    AppLocalizationsKeys.backupFileRequiredTitle: 'We need your backup file',
    AppLocalizationsKeys.backupFileRequiredDescr:
        "Please provide your History of Me backup file. Backup files have a unique file name and are usually stored in your 'Download' folder on this location:",
    AppLocalizationsKeys.storagePermissionDeniedTitle: 'Reading backup denied',
    AppLocalizationsKeys.storagePermissionDeniedDescr:
        'History of Me needs additional permissions in order to access your storage. This will be required to read your diary backup',
    AppLocalizationsKeys.requestPermissionLabel: 'Request permissions',
    AppLocalizationsKeys.foundDiaryTitle: 'We found your diary',
    AppLocalizationsKeys.lastEditedLabel: 'Last updated',
    AppLocalizationsKeys.nextLabel: 'next',
    AppLocalizationsKeys.previousLabel: 'previous',
    AppLocalizationsKeys.optionsLabel: 'options',
    AppLocalizationsKeys.firstLabel: 'first',
    AppLocalizationsKeys.emptyEntryTitle: 'Empty entry',
    AppLocalizationsKeys.emptyEntryDescr: 'This diary entry is empty.',
    AppLocalizationsKeys.editLabel: 'edit',
    AppLocalizationsKeys.emptyEntryActionDescr:
        'Edit your diary entry by tapping on the pencil icon.',
    AppLocalizationsKeys.goodLabel: 'good',
    AppLocalizationsKeys.badLabel: 'bad',
    AppLocalizationsKeys.alrightLabel: 'alright',
    AppLocalizationsKeys.quoteLabel: 'quote',
    AppLocalizationsKeys.quoteSubtitle: 'express your favorite quote',
    AppLocalizationsKeys.byLabel: 'by',
    AppLocalizationsKeys.accentColorLabel: 'accent color',
    AppLocalizationsKeys.choosePhotoLabel: 'choose photo',
    AppLocalizationsKeys.alreadyAvailableLabel: 'already available',
    AppLocalizationsKeys.duplicateEntryDescr:
        'There already is a diary entry available for this date.',
    AppLocalizationsKeys.duplicateEntryTodayDescr:
        'There already is a diary entry available for today.',
    AppLocalizationsKeys.continueLabel: 'continue',
    AppLocalizationsKeys.yourNameLabel: 'your name',
    AppLocalizationsKeys.permissionsRequiredDescr:
        'This app requires additional permissions in order to backup your diary on your local device. Without these permissions accessing data on your device will not be possible. You can always remove these permissions on your device settings or by deleting this app. Please keep in mind, that your data is only stored locally.',
    AppLocalizationsKeys.backupInfoDescr:
        'Backups help you to restore your diary after you deleted this app.',
    AppLocalizationsKeys.readingLabel: 'reading',
    AppLocalizationsKeys.noBackupFoundTitle: 'no backup found',
    AppLocalizationsKeys.noBackupFoundDescr:
        'We did not find any backups. Backup your diary to prevent possible data loss.',
    AppLocalizationsKeys.backupLabel: 'backup',
    AppLocalizationsKeys.backupIdLabel: 'Backup-ID',
    AppLocalizationsKeys.lastestBackupLabel: 'Last Backup',
    AppLocalizationsKeys.upToDateBackupDescr: 'Your backup is up to date!',
    AppLocalizationsKeys.deprecatedBackupDescr:
        'Your backup is older than two days. We recommend to backup your diary regularly to prevent data loss.',
    AppLocalizationsKeys.bookmarkSavedDescr: 'Your bookmark has been saved.',
    AppLocalizationsKeys.homeLabel: 'home',
    AppLocalizationsKeys.profileLabel: 'profile',
    AppLocalizationsKeys.mixedLabel: 'mixed',
    AppLocalizationsKeys.futureDateActionDescr:
        'Are you sure to create an entry for this date?',
    AppLocalizationsKeys.futureDateDescr:
        'This date is in the future. It is generally recommended to write about things you already experienced.',
    AppLocalizationsKeys.confirmDateLabel: 'Confirm Date',
    AppLocalizationsKeys.hintText: 'Type something',
    AppLocalizationsKeys.selectAnother: 'Select another',
  };
}
