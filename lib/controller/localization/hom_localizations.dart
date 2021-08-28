import 'package:flutter/material.dart';
import 'package:lit_localization_service/lit_localization_service.dart';

/// A controller class implementing HistoryOfMe's localization.
///
/// It provides an interface to access the [LitLocalizations] using the local
/// JSON asset and implements the required getter to retrieve all available
/// localized strings.
class HOMLocalizations {
  final BuildContext context;

  /// Creates a [HOMLocalizations].
  const HOMLocalizations(this.context);

  LitLocalizations get _localizations {
    return LitLocalizations.of(context)!;
  }

  String getValue(String key) {
    return _localizations.getLocalizedValue(key);
  }

  String get yourName {
    return getValue("your_name");
  }

  String get okay {
    return getValue("okay");
  }

  String get compose {
    return getValue("compose");
  }

  String get thatsMe {
    return getValue("thats_me");
  }

  String get whatShallWeCallYou {
    return getValue("what_shall_we_call_you");
  }

  String get yourDataIsSafe {
    return getValue("your_data_is_safe");
  }

  String get offlineAppDescription {
    return getValue("offline_app_description");
  }

  String get confirmYourAge {
    return getValue("confirm_your_age");
  }

  String get confirmYourAgeSubtitle {
    return getValue("confirm_your_age_subtitle");
  }

  String get yourAge {
    return getValue("your_age");
  }

  String get setAge {
    return getValue("set_age");
  }

  String get submit {
    return getValue("submit");
  }

  String get invalidAgeText {
    return getValue("invalid_age_text");
  }

  String get valid {
    return getValue("valid");
  }

  String get chooseDate {
    return getValue("choose_date");
  }

  String get createFirstEntryDescr {
    return getValue("create_first_entry_descr");
  }

  String get createEntry {
    return getValue("create_entry");
  }

  String get create {
    return getValue("create");
  }

  String get existingEntryTodayDescr {
    return getValue("existing_entry_today_descr");
  }

  String get existingEntrySelectedDayDescr {
    return getValue("existing_entry_selected_day_descr");
  }

  String get forToday {
    return getValue("for_today");
  }

  String get forPreviousDay {
    return getValue("for_previous_day");
  }

  String get addDiaryEntry {
    return getValue("add_diary_entry");
  }

  String get futureDaysNotAllowedDescr {
    return getValue("future_days_not_allowed_descr");
  }

  String get dateNotIncludedDescr {
    return getValue("date_not_included_descr");
  }

  String get untitled {
    return getValue("untitled");
  }

  String get entry {
    return getValue("entry");
  }

  String get entires {
    return getValue("entires");
  }

  String get favorite {
    return getValue("favorite");
  }

  String get latest {
    return getValue("latest");
  }

  String get first {
    return getValue("first");
  }

  String get edit {
    return getValue("edit");
  }

  String get yourMoodWas {
    return getValue("your_mood_was");
  }

  String get entryIsEmpty {
    return getValue("entry_is_empty");
  }

  String get entryIsEmptyDescr {
    return getValue("entry_is_empty_descr");
  }

  String get options {
    return getValue("options");
  }

  String get delete {
    return getValue("delete");
  }

  String get bad {
    return getValue("bad");
  }

  String get good {
    return getValue("good");
  }

  String get alright {
    return getValue("alright");
  }

  String get noFavoritesAvailable {
    return getValue("no_favorites_available");
  }

  String get noFavoritesAvailableDescr {
    return getValue("no_favorites_available_descr");
  }

  String get all {
    return getValue("all");
  }

  String get previous {
    return getValue("previous");
  }

  String get next {
    return getValue("next");
  }

  String get choosePhoto {
    return getValue("choose_photo");
  }

  String get selected {
    return getValue("selected");
  }

  String get details {
    return getValue("details");
  }

  String get creator {
    return getValue("creator");
  }

  String get location {
    return getValue("location");
  }

  String get published {
    return getValue("published");
  }

  String get backdropPhotoDesc {
    return getValue("backdrop_photo_descr");
  }

  String get howAreYouToday {
    return getValue("how_are_you_today");
  }

  String get welcomeBack {
    return getValue("welcome_back");
  }

  String get diaryCreated {
    return getValue("diary_created");
  }

  String get changeName {
    return getValue("change_name");
  }

  String get changeYourName {
    return getValue("change_your_name");
  }

  String get statistics {
    return getValue("statistics");
  }

  String get diaryEntries {
    return getValue("diary_entires");
  }

  String get wordsWritten {
    return getValue("words_written");
  }

  String get wordsPerEntry {
    return getValue("words_per_entry");
  }

  String get mostWordsWrittenAtOnce {
    return getValue("most_words_at_once");
  }

  String get fewestWordsAtOnce {
    return getValue("fewest_words_at_once");
  }

  String get entriesThisWeek {
    return getValue("entries_this_week");
  }

  String get entriesThisMonth {
    return getValue("enties_this_month");
  }

  String get latestEntry {
    return getValue("latest_entry");
  }

  String get firstEntry {
    return getValue("first_entry");
  }

  String get settings {
    return getValue("settings");
  }

  String get takeTheTour {
    return getValue("take_the_tour");
  }

  String get aboutThisApp {
    return getValue("about_this_app");
  }

  String get yourOwnPersonalDiary {
    return getValue("your_own_personal_diary");
  }

  String get viewPrivacy {
    return getValue("view_privacy");
  }

  String get deleteAllData {
    return getValue("delete_all_data");
  }

  String get deleteAllDataDescr {
    return getValue("delete_all_data_descr");
  }

  String get credits {
    return getValue("credits");
  }

  String get cancel {
    return getValue("cancel");
  }

  String get apply {
    return getValue("apply");
  }

  String get unsavedBookmarkDescr {
    return getValue("unsaved_bookmark_descr");
  }

  String get unsavedEntryDescr {
    return getValue("unsaved_entry_descr");
  }

  String get unsaved {
    return getValue("unsaved");
  }

  String get discardChanges {
    return getValue("discard_changes");
  }

  String get discard {
    return getValue("discard");
  }

  String get colorAlreadyExists {
    return getValue("color_already_exists");
  }

  String get dotted {
    return getValue("dotted");
  }

  String get striped {
    return getValue("striped");
  }

  String get mainColor {
    return getValue("main_color");
  }

  String get accentColor {
    return getValue("accent_color");
  }

  String get quote {
    return getValue("quote");
  }

  String get by {
    return getValue("by");
  }

  String get more {
    return getValue("more");
  }

  String get less {
    return getValue("less");
  }

  String get reset {
    return getValue("reset");
  }

  String get introduction {
    return getValue("introduction");
  }

  String get organize {
    return getValue("organize");
  }

  String get browseDiaryTitle {
    return getValue("browse_diary_title");
  }

  String get browseDiaryDescr {
    return getValue("browse_diary_descr");
  }

  String get relive {
    return getValue("relive");
  }

  String get readYourDiaryEntriesTitle {
    return getValue("read_your_diary_entries_title");
  }

  String get readYourDiaryEntriesDescr {
    return getValue("read_your_diary_entries_descr");
  }

  String get personalize {
    return getValue("personalize");
  }

  String get customizeBookmarkTitle {
    return getValue("customize_bookmark_title");
  }

  String get customizeBookmarkDescr {
    return getValue("customize_bookmark_descr");
  }

  String get privacy {
    return getValue("privacy");
  }

  String get privacyDescr {
    return getValue("privacy_descr");
  }

  String get private {
    return getValue("private");
  }

  String get offline {
    return getValue("offline");
  }

  String get uxDesign {
    return getValue("ux_design");
  }

  String get development {
    return getValue("development");
  }

  String get photos {
    return getValue("photos");
  }

  String get inspiredBy {
    return getValue("inspired_by");
  }

  String get statisticsFallbackDescr {
    return getValue("statistics_fallback_descr");
  }

  String get statisticsFallbackAdv {
    return getValue("statistics_fallback_adv");
  }

  String get deleteEntry {
    return getValue("delete_entry");
  }

  String get deleteEntryDescr {
    return getValue("delete_entry_descr");
  }

  String get pickAColor {
    return getValue("pick_a_color");
  }

  String get colorIsTransparent {
    return getValue("color_is_transparent");
  }

  String get averageMood {
    return getValue("average_mood");
  }

  String get manageBackup {
    return getValue("manage_backup");
  }

  String get loadingBackup {
    return getValue("loading_backup");
  }

  String get noBackupFound {
    return getValue("no_backup_found");
  }

  String get backupNow {
    return getValue("backup_now");
  }

  String get backupNowShort {
    return getValue("backup_now_short");
  }

  String get noBackupTitle {
    return getValue("no_backup_title");
  }

  String get noBackupDescr {
    return getValue("no_backup_descr");
  }

  String get generalBackupDescr {
    return getValue("general_backup_descr");
  }

  String get lastBackup {
    return getValue("last_backup");
  }

  String get upToDate {
    return getValue("up_to_date");
  }

  String get upToDateDescr {
    return getValue("up_to_date_descr");
  }

  String get notUpToDateDescr {
    return getValue("not_up_to_date_descr");
  }

  String get backupYourDiary {
    return getValue("backup_your_diary");
  }
}
