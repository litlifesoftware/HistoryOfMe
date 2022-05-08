part of localization;

/// The `de` language implementation of the [AppLocalizations].
class DE {
  /// The language code of German-speaking locales.
  static const languageCode = 'de';

  /// The localized values.
  static const values = const {
    AppLocalizationsKeys.createEntryLabel: 'Eintrag erstellen',
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
    AppLocalizationsKeys.privacyDescr:
        'History of Me möchte dir die höchste Datenschutzsicherheit bieten. Deine Daten verbleiben nur auf deinem Gerät. Weder der Ersteller der App noch eine andere Person können auf deine Inhalte zugreifen. Es wird keine Übertragung über das Internet stattfinden, alle Daten bleiben offline.',
    AppLocalizationsKeys.customizeBookmarkTitle: 'Passe dein Lesezeichen an',
    AppLocalizationsKeys.customizeBookmarkDescr:
        'Kannst du das Lesezeichen oben über deinem Tagebuch sehen? Diesen kannst du anpassen. Gehe hierfür zu deinem Profil und tippe auf das Stift-Symbol unter dem Lesezeichen. Bei der Bearbeitung kann du deine Lieblingsfarben auswählen und auch das Muster festlegen. Aber vergiss bitte nicht die Änderungen zu speichern!',
    AppLocalizationsKeys.aboutAppDescr: 'Dein eigenes, persönliches Tagebuch.',
    AppLocalizationsKeys.inspiredByLabel: 'Inspiriert durch',
    AppLocalizationsKeys.noFavoritesAvailLabel: 'Keine Favoriten verfügbar',
    AppLocalizationsKeys.noFavoritesAvailDescr:
        'Auf der Lese-Ansicht kannst du Tagebucheinträge zu deinen Lieblingseinträge hinzufügen.',
    AppLocalizationsKeys.greetingLabel: 'Wie geht es dir heute?',
    AppLocalizationsKeys.welcomeBackLabel: 'Willkommen zurück',
    AppLocalizationsKeys.changeNameLabel: 'Namen ändern',
    AppLocalizationsKeys.changeYourNameLabel: 'Deinen Namen ändern',
    AppLocalizationsKeys.creatorDescr:
        'Was der Ersteller uns über das Foto erzählt',
    AppLocalizationsKeys.detailsLabel: 'Details',
    AppLocalizationsKeys.entrySavedDescr:
        'Dein Tagebucheintrag wurde gespeichert.',
    AppLocalizationsKeys.untitledLabel: 'Ohne Titel',
    AppLocalizationsKeys.yourMoodLabel: 'Deine Stimmung',
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
    AppLocalizationsKeys.newDiaryTitle: 'Neues Tagebuch',
    AppLocalizationsKeys.newDiarySubtitle: 'Neues Tagebuch erstellen',
    AppLocalizationsKeys.startJourneyTitle: 'Beginne eine neue Reise',
    AppLocalizationsKeys.diaryOfLabel: 'Tagebuch von',
    AppLocalizationsKeys.restoreDiaryTitle: 'Stelle dein Tagebuch wieder her',
    AppLocalizationsKeys.continueJourneyTitle: 'Führe deine Reise fort',
    AppLocalizationsKeys.cancelRestoreDescr:
        'Möchtest du ein neues Tagebuch erstellen, anstelle dein vorheriges Tagebuch wiederherzustellen?',
    AppLocalizationsKeys.backupFileRequiredTitle:
        "Wir benötigen deine Backup Datei",
    AppLocalizationsKeys.backupFileRequiredDescr:
        "Bitte stelle deine 'History of Me'-Backupdatei zur Verfügung. Backup-Datein haben einen eindeutigen Dateinamen und befinden sich üblicherweise in deinem 'Download'-Ordner unter folgendem Pfad:",
    AppLocalizationsKeys.storagePermissionDeniedTitle: 'Auslesen verweigert',
    AppLocalizationsKeys.storagePermissionDeniedDescr:
        'History of Me benötigt zusätzliche Rechte, um auf deinen Speicher zuzugreifen. Dies ist notwendig, damit Backup-Datein ausgelesen werden können.',
    AppLocalizationsKeys.requestPermissionLabel: 'Zulassen',
    AppLocalizationsKeys.foundDiaryTitle: 'Wir haben dein Tagebuch gefunden',
    AppLocalizationsKeys.lastEditedLabel: 'Zuletzt geändert',
    AppLocalizationsKeys.nextLabel: 'nächste',
    AppLocalizationsKeys.previousLabel: 'vorherige',
    AppLocalizationsKeys.optionsLabel: 'Optionen',
    AppLocalizationsKeys.firstLabel: 'erster',
    AppLocalizationsKeys.emptyEntryTitle: 'Leerer Eintrag',
    AppLocalizationsKeys.emptyEntryDescr: 'Dieser Tagebucheintrag ist leer.',
    AppLocalizationsKeys.editLabel: 'bearbeiten',
    AppLocalizationsKeys.emptyEntryActionDescr:
        'Bearbeite deinen Tagebucheintrag durch Drücken auf den Bearbeiten-Knopf oben rechts.',
    AppLocalizationsKeys.goodLabel: 'gut',
    AppLocalizationsKeys.badLabel: 'schlecht',
    AppLocalizationsKeys.alrightLabel: 'in Ordnung',
    AppLocalizationsKeys.quoteLabel: 'Zitat',
    AppLocalizationsKeys.quoteSubtitle: 'zeige uns dein Lieblingszitat',
    AppLocalizationsKeys.byLabel: 'von',
    AppLocalizationsKeys.accentColorLabel: 'Akzentfarbe',
    AppLocalizationsKeys.choosePhotoLabel: 'Foto auswählen',
    AppLocalizationsKeys.alreadyAvailableLabel: 'bereits vorhanden',
    AppLocalizationsKeys.duplicateEntryDescr:
        'Für diesen Tag ist bereits ein Tagebucheintrag verfügbar.',
    AppLocalizationsKeys.duplicateEntryTodayDescr:
        'Für heute ist bereits ein Tagebucheintrag verfügbar.',
    AppLocalizationsKeys.continueLabel: 'fortfahren',
    AppLocalizationsKeys.yourNameLabel: 'dein Name',
    AppLocalizationsKeys.permissionsRequiredDescr:
        'Diese App benötigt zusätzliche Berechtigungen, um Backups deines Tagebuchs zu erstellen. Ohne diese Berechtigungen ist das Auslesen der Datein auf deinem Gerät nicht möglich. Du kannst jederzeit die Berechtigungen widerrufen. Hierfür kannst du die Berechtigungs-Verwaltung in deinen Geräte-Einstellungen aufrufen oder diese App deinstallieren. Bitte beachte, dass deine Daten nur lokal gespeichert werden.',
    AppLocalizationsKeys.backupInfoDescr:
        'Backups ermöglichen das Wiederherstellen deines Tagebuchs, auch nachdem du diese App entfernt hast.',
    AppLocalizationsKeys.readingLabel: 'lesen',
    AppLocalizationsKeys.noBackupFoundTitle: 'keine Sicherung gefunden',
    AppLocalizationsKeys.noBackupFoundDescr:
        'Wir haben keine Sicherungen gefunden. Sichere dein Tagebuch, um einen Datenverlust zu vermeiden.',
    AppLocalizationsKeys.backupLabel: 'sichern',
    AppLocalizationsKeys.backupIdLabel: 'Sicherungs-ID',
    AppLocalizationsKeys.lastestBackupLabel: 'Letzte Sicherung',
    AppLocalizationsKeys.upToDateBackupDescr: 'Deine Sicherung ist aktuell!',
    AppLocalizationsKeys.deprecatedBackupDescr:
        'Dein Backup ist älter als zwei Tage. Wir empfehlen dein Tagebuch regelmäßig zu sichern, um einen Datenverlust zu vermeiden.',
    AppLocalizationsKeys.bookmarkSavedDescr:
        'Dein Lesezeichen wurde gespeichert.',
    AppLocalizationsKeys.homeLabel: 'Home',
    AppLocalizationsKeys.profileLabel: 'Profil',
    AppLocalizationsKeys.mixedLabel: 'gemischt',
    AppLocalizationsKeys.futureDateActionDescr:
        'Möchtest du einen Eintrag für diesen Tag erstellen?',
    AppLocalizationsKeys.futureDateDescr:
        'Dieser Tag liegt in der Zukunft. Es wird generell empfohlen nur über Dinge zu schreiben, welche du bereits erlebt hast.',
    AppLocalizationsKeys.confirmDateLabel: 'Tag bestätigen',
    AppLocalizationsKeys.hintText: 'Schreibe etwas',
    AppLocalizationsKeys.selectAnother: 'Anderes auswählen',
    AppLocalizationsKeys.noPhotosAvailableText:
        "Für diesen Tagebucheintrag sind keine Fotos verfügbar."
            " "
            "Drücke den Knopf oben rechts, um Fotos auszuwählen.",
    AppLocalizationsKeys.pickPhotoLabel: 'auswählen',
    AppLocalizationsKeys.photosMissingLabel: 'Fotos fehlen',
    AppLocalizationsKeys.photosMissingDescr:
        "Wir können nicht alle Fotos deines Tagebuchs finden."
            " "
            "Jedoch kannst du diese später in deine Tagebucheinträge importieren,"
            " "
            "wenn du die Fotos noch auf deinem Gerät hast.",
    AppLocalizationsKeys.noPhotosSelectedLabel: "Keine Fotos ausgewählt",
    AppLocalizationsKeys.deletePhotosDescr: "Du hast keine Fotos ausgewählt."
        " "
        "Deine Fotos zu entfernen kann nicht rückgängig gemacht werden.",
    AppLocalizationsKeys.deletePhotosActionLabel:
        "Möchtest du alle Fotos löschen.",
    AppLocalizationsKeys.somePhotosMissingLabel: 'Einige Fotos fehlen!',
    AppLocalizationsKeys.allPhotosRestorableLabel:
        'Alle Fotos können wiederhergestellt werden',
    AppLocalizationsKeys.photosLabel: 'Fotos',
    AppLocalizationsKeys.photoCopiedLabel: 'Foto kopiert',
    AppLocalizationsKeys.photosCopiedLabel: 'Fotos kopiert',
    AppLocalizationsKeys.photosTotalLabel: 'Fotos insgesamt',
    AppLocalizationsKeys.photosFoundLabel: 'Fotos gefunden',
    AppLocalizationsKeys.includePhotosLabel: 'Fotos einbeziehen',
    AppLocalizationsKeys.includePhotosDescr:
        'Sichert die Fotos deines Tagebuchs.'
            ' '
            'Dies wird mehr freien Speicherplatz auf deinem Gerät erfordern.',
    AppLocalizationsKeys.duplicatePhotoRemovedLabel: 'doppeltes Foto entfernt',
    AppLocalizationsKeys.duplicatePhotosRemovedLabel: 'doppelte Fotos entfernt',
  };
}
