import 'package:history_of_me/localization.dart';

/// The `de` language implementation of the [AppLocalizations].
class AppLocalizationsDe {
  /// The language code of German-speaking locales.
  static const languageCode = 'de';

  /// The localized values.
  static const values = const {
    AppLocalizationsKeys.composeButtonLabel: 'Erstellen',
    AppLocalizationsKeys.createEntryButtonLabel: 'Eintrag erstellen',
    AppLocalizationsKeys.usernameLabel: 'Dein Name',
    AppLocalizationsKeys.emptyDiarySubtitle: 'Keine Einträge',
    AppLocalizationsKeys.emptyDiaryBody:
        "Es sind keine Einträge verfügbar. Möchtest du jetzt deinen ersten Eintrag erstellen?",
    AppLocalizationsKeys.personalizeLabel: 'Personalisiere',
    AppLocalizationsKeys.organizeLabel: 'Ordne',
    AppLocalizationsKeys.browseDiaryTitle: 'Überblicke dein Tagebuch',
    AppLocalizationsKeys.browseDiaryDesc:
        'History Of Me bietet dir dein eigenes, persönliches Tagebuch. Überblicke und stöbere durch deine Einträge.',
    AppLocalizationsKeys.reliveLabel: 'Wiedererlebe',
    AppLocalizationsKeys.privateLabel: 'privat',
    AppLocalizationsKeys.readDiaryTitle: 'Lies deine Einträge',
    AppLocalizationsKeys.readDiaryDescr:
        'Tippe auf einen deiner Einträge in der Tagebuch-List, um einen Eintrag zu lesen und um deine Erinnerungen wiederzuerwecken.',
    AppLocalizationsKeys.privacyLabel: 'Privatsphäre',
    AppLocalizationsKeys.privacyDescr:
        'History of Me möchte dir die höchste Datenschutzsicherheit bieten. Deine Daten verbleiben nur auf deinem Gerät. Weder der Ersteller der App noch eine andere Person können auf deine Inhalte zugreifen. Es wird keine Übertragung über das Internet stattfinden, alle Daten bleiben offline.',
    AppLocalizationsKeys.customizeBookmarkTitle: 'Passe dein Lesezeichen an',
    AppLocalizationsKeys.customizeBookmarkDescr:
        'Kannst du das Lesezeichen oben über deinem Tagebuch sehen? Diesen kannst du anpassen. Gehe hierfür zu deinem Profil und tippe auf das Stift-Symbol unter dem Lesezeichen. Bei der Bearbeitung kann du deine Lieblingsfarben auswählen und auch das Muster festlegen. Aber vergiss bitte nicht die Änderungen zu speichern!',
    AppLocalizationsKeys.aboutAppLabel: 'Über diese App',
    AppLocalizationsKeys.aboutAppDescr: 'Dein eigenes, persönliches Tagebuch.',
    AppLocalizationsKeys.userExpericenceDesignLabel: 'User Experience Design',
    AppLocalizationsKeys.developmentLabel: 'Entwicklung',
    AppLocalizationsKeys.photographyLabel: 'Fotos',
    AppLocalizationsKeys.inspiredByLabel: 'Inspired by',
    AppLocalizationsKeys.manageBackupLabel: 'Sicherung verwalten',
    AppLocalizationsKeys.startTourLabel: 'Rundgang starten',
    AppLocalizationsKeys.creditsLabel: 'Mitwirkende',
    AppLocalizationsKeys.noFavoritesAvailLabel: 'Keine Favoriten verfügbar',
    AppLocalizationsKeys.noFavoritesAvailDescr:
        'Auf der Lese-Ansicht kannst du Tagebucheinträge zu deinen Lieblingseinträge hinzufügen.',
    AppLocalizationsKeys.greetingLabel: 'Wie geht es dir heute?',
    AppLocalizationsKeys.welcomeBackLabel: 'Willkommen zurück',
    AppLocalizationsKeys.changeNameLabel: 'Namen ändern',
    AppLocalizationsKeys.changeYourNameLabel: 'Deinen Namen ändern',
    AppLocalizationsKeys.creatorLabel: 'Ersteller',
    AppLocalizationsKeys.creatorDescr:
        'Was der Ersteller uns über das Foto erzählt',
    AppLocalizationsKeys.detailsLabel: 'Details',
    AppLocalizationsKeys.locationLabel: 'Ort',
    AppLocalizationsKeys.publishedLabel: 'Veröffentlicht',
    AppLocalizationsKeys.entrySavedDescr:
        'Dein Tagebucheintrag wurde gespeichert.',
    AppLocalizationsKeys.savedLabel: 'Gespeichert',
    AppLocalizationsKeys.untitledLabel: 'Ohne Titel',
    AppLocalizationsKeys.yourMoodLabel: 'Deine Stimmung',
    AppLocalizationsKeys.statisticsLabel: 'Statistiken',
    AppLocalizationsKeys.noEntriesAvailLabel:
        'Keine Tagebucheinträge verfügbar.',
    AppLocalizationsKeys.diaryFallbackDescr:
        'Es sind keine Einträge verfügbar. Möchtest du deinen ersten Tagebucheintrag erstellen?',
    AppLocalizationsKeys.statisticsFallbackDescr:
        'Um deine Statistiken zu sehen, solltest du mindestens einen Eintrag erstellen.',
    AppLocalizationsKeys.statisticsFallbackActionLabel:
        'Gehe zurück zu deinem Tagebuch, um deinen ersten Eintrag zu erstellen.',
    AppLocalizationsKeys.diaryEntriesLabel: 'Tagebucheinträge',
    AppLocalizationsKeys.avgMoodLabel: 'Durchschnittliche Stimmung',
    AppLocalizationsKeys.wordsWrittenLabel: 'Verfasste Wörter',
    AppLocalizationsKeys.wordsPerEntryLabel: 'Wörter pro Eintrag',
    AppLocalizationsKeys.mostWordsAtOnceLabel: 'Meiste Wörter zugleich',
    AppLocalizationsKeys.fewestWordsAtOnceLabel: 'Wenigste Wörter zugleich',
    AppLocalizationsKeys.entriesThisWeekLabel: 'Enträge diese Woche',
    AppLocalizationsKeys.entriesThisMonthLabel: 'Enträge diesen Monat',
    AppLocalizationsKeys.lastestEntryLabel: 'Aktuellster Eintrag',
    AppLocalizationsKeys.firstEntryLabel: 'Erster Eintrag',
    AppLocalizationsKeys.lessLabel: 'Weniger',
    AppLocalizationsKeys.moreLabel: 'Mehr',
    AppLocalizationsKeys.selectMainColorLabel: 'Wähle eine Hauptfarbe',
    AppLocalizationsKeys.selectAccentColorLabel: 'Wähle eine Akzentfarbe',
    AppLocalizationsKeys.createLabel: 'Erstellen',
    AppLocalizationsKeys.stripesLabel: 'Streifen',
    AppLocalizationsKeys.dotsLabel: 'Punkte',
    AppLocalizationsKeys.mainColorLabel: 'Hauptfarbe',
    AppLocalizationsKeys.duplicateColorDescr:
        'Diese Farbe ist bereits vorhanden.',
    AppLocalizationsKeys.entryLabel: 'Eintrag',
    AppLocalizationsKeys.entriesLabel: 'Einträge',
    AppLocalizationsKeys.favoriteEntryLabel: 'Lieblingseintrag',
    AppLocalizationsKeys.favoriteEntriesLabel: 'Lieblingseinträge',
    AppLocalizationsKeys.allLabel: 'alle',
    AppLocalizationsKeys.latestLabel: 'aktuell',
    AppLocalizationsKeys.unsavedLabel: 'ungespeichert',
    AppLocalizationsKeys.newDiaryTitle: 'Neues Tagebuch',
    AppLocalizationsKeys.newDiarySubtitle: 'Neues Tagebuch erstellen',
    AppLocalizationsKeys.startJourneyTitle: 'Beginne eine neue Reise',
    AppLocalizationsKeys.diaryOfLabel: 'Tagebuch von',
    AppLocalizationsKeys.restoreDiaryTitle: 'Stelle dein Tagebuch wieder her',
    AppLocalizationsKeys.continueJourneyTitle: 'Führe deine Reise fort',
    AppLocalizationsKeys.restoreLabel: 'Wiederherstellen',
    AppLocalizationsKeys.cancelRestoreDescr:
        'Möchtest du ein neues Tagebuch erstellen, anstelle dein vorheriges Tagebuch wiederherzustellen?',
    AppLocalizationsKeys.createdLabel: 'Erstellt',
    AppLocalizationsKeys.selectBackupTitle: 'Backup auswählen',
    AppLocalizationsKeys.restoreFromBackupTitle: 'Sicherung wiederherstellen',
    AppLocalizationsKeys.unsupportedFileTitle: 'Nicht unterstützt',
    AppLocalizationsKeys.unsupportedFileDescr:
        'Diese Datei wird nicht unterstützt.',
    AppLocalizationsKeys.backupFileRequiredTitle:
        "Wir benötigen deine Backup Datei",
    AppLocalizationsKeys.backupFileRequiredDescr:
        "Bitte stelle deine 'History of Me'-Backupdatei zur Verfügung. Backup-Datein haben einen eindeutigen Dateinamen und befinden sich üblicherweise in deinem 'Download'-Ordner unter folgendem Pfad:",
    AppLocalizationsKeys.pickFileLabel: 'Auswählen',
    AppLocalizationsKeys.storagePermissionDeniedTitle: 'Auslesen verweigert',
    AppLocalizationsKeys.storagePermissionDeniedDescr:
        'History of Me benötigt zusätzliche Rechte, um auf deinen Speicher zuzugreifen. Dies ist notwendig, damit Backup-Datein ausgelesen werden können.',
    AppLocalizationsKeys.requestPermissionLabel: 'Zulassen',
  };
}
