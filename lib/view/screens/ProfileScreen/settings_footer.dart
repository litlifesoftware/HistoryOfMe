import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/model/app_settings.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/screens/screens.dart';
import 'package:history_of_me/view/screens/ProfileScreen/diary_backup_dialog.dart';
import 'package:history_of_me/view/shared/art/history_of_me_launcher_icon_art.dart';
import 'package:leitmotif/leitmotif.dart';

import 'delete_data_dialog.dart';

class SettingsFooter extends StatefulWidget {
  final AppSettings appSettings;
  final UserData? userData;

  const SettingsFooter({
    Key? key,
    required this.appSettings,
    required this.userData,
  }) : super(key: key);
  @override
  _SettingsFooterState createState() => _SettingsFooterState();
}

class _SettingsFooterState extends State<SettingsFooter> {
  bool loading = false;

  //late LitRouteController _routeController;
  void _showAboutThisAppDialog() {
    LitRouteController(context).showDialogWidget(
      LitAboutDialog(
        title: HOMLocalizations(context).aboutThisApp,
        appName: "History of Me",
        art: HistoryOfMeLauncherIconArt(),
        infoDescription: HOMLocalizations(context).yourOwnPersonalDiary,
      ),
    );
  }

  void _showBackupDialog() {
    LitRouteController(context).showDialogWidget(
      DiaryBackupDialog(
        installationID: widget.appSettings.installationID ?? "",
      ),
    );
  }

  void _openPrivacyPolicy() {
    LitRouteController(context).pushCupertinoWidget(LitPrivacyPolicyScreen(
      //title: HOMLocalizations(context).privacy,
      onAgreeCallback: () => LitRouteController(context).pop(),
      privacyBody: HOMLocalizations(context).privacyDescr,
      //agreeLabel: HOMLocalizations(context).okay,
      art: HistoryOfMeLauncherIconArt(),
      // privacyTags: [
      //   PrivacyTag(
      //     text: HOMLocalizations(context).private,
      //     isConform: true,
      //   ),
      //   PrivacyTag(
      //     text: HOMLocalizations(context).offline,
      //     isConform: true,
      //   ),
      // ],
    ));
  }

  void _openLicenses() {
    LitRouteController(context)
        .pushCupertinoWidget(ApplicationLicensesScreen());
  }

  void _showDeleteDataDialog() {
    LitRouteController(context).showDialogWidget(
      DeleteDataDialog(),
    );
  }

  void _openCredits() async {
    dynamic parsed;
    List<String> backdropPhotoPhotographers = [];
    await rootBundle
        .loadString('assets/json/image_collection_data.json')
        .then(
          (value) => parsed = jsonDecode(value).cast<Map<String, dynamic>>(),
        )
        .then(
          (_) => parsed.forEach(
            (json) => backdropPhotoPhotographers
                .add(BackdropPhoto.fromJson(json).photographer!),
          ),
        )
        .then(
          (value) => LitRouteController(context).pushMaterialWidget(
            LitCreditsScreen(
              art: HistoryOfMeLauncherIconArt(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3.0,
                    color: Colors.black12,
                    offset: Offset(
                      -2,
                      2,
                    ),
                    spreadRadius: -1,
                  )
                ],
              ),
              appName: "History Of Me",
              appDescription: HOMLocalizations(context).yourOwnPersonalDiary,
              //screenTitle: HOMLocalizations(context).credits,
              credits: [
                //TODO:Localize
                CreditData(
                  role: "made by",
                  names: [
                    "LitLifeSoftware",
                  ],
                ),
                CreditData(
                  role: HOMLocalizations(context).uxDesign,
                  names: [
                    "Michael Grigorenko",
                  ],
                ),
                CreditData(
                  role: HOMLocalizations(context).development,
                  names: [
                    "Michael Grigorenko",
                  ],
                ),
                CreditData(
                  role: HOMLocalizations(context).photos,
                  names: backdropPhotoPhotographers,
                ),
                CreditData(
                  role: HOMLocalizations(context).inspiredBy,
                  names: ["Your Name. (2016)"],
                ),
              ],
            ),
          ),
        );
  }

  /// Show the app's onboarding screen.
  void _showOnboardingScreen() {
    LitRouteController(context).pushMaterialWidget(
      AppOnboardingScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitFooter(
      title: HOMLocalizations(context).settings,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LitPlainLabelButton(
            label: HOMLocalizations(context).manageBackup,
            onPressed: _showBackupDialog,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: HOMLocalizations(context).showOnboardingButtonLabel,
            onPressed: _showOnboardingScreen,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: HOMLocalizations(context).aboutThisApp,
            onPressed: _showAboutThisAppDialog,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: HOMLocalizations(context).viewPrivacy,
            onPressed: _openPrivacyPolicy,
            textAlign: TextAlign.right,
          ),
          // LitPlainLabelButton(
          //   label: HOMLocalizations(context).deleteAllData,
          //   onPressed: _showDeleteDataDialog,
          //   textAlign: TextAlign.right,
          // ),
          LitPlainLabelButton(
            label: HOMLocalizations(context).credits,
            onPressed: _openCredits,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: LeitmotifLocalizations.of(context).licensesLabel,
            onPressed: _openLicenses,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
