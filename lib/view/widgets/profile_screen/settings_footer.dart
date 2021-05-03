import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/screens/HistoryOfMeIntroScreen/history_of_me_intro_screen.dart';
import 'package:history_of_me/view/shared/art/history_of_me_launcher_icon_art.dart';
import 'package:history_of_me/view/widgets/profile_screen/delete_data_dialog.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class SettingsFooter extends StatefulWidget {
  final UserData? userData;

  const SettingsFooter({
    Key? key,
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
      AboutAppDialog(
        appName: "History of Me",
        art: HistoryOfMeLauncherIconArt(),
        infoDescription: "Your own personal diary.",
      ),
    );
  }

  void _openPrivacyPolicy() {
    LitRouteController(context).pushCupertinoWidget(LitPrivacyPolicyScreen(
      onAgreeCallback: () => LitRouteController(context).pop(),
      privacyText:
          "History of Me's goal is to provide the most private experience available on mobile devices. Your data will always remain on your device. The creator of the app nor any third party will be able to view your content. There is no connection to the internet, all required data to use the app will be stored locally.",
      agreeLabel: "Okay",
      art: HistoryOfMeLauncherIconArt(),
      privacyTags: [
        PrivacyTag(text: "Private", isConform: true),
        PrivacyTag(
          text: "Offline",
          isConform: true,
        ),
      ],
    ));
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
              art: HistoryOfMeLauncherIconArt(),
              appTitle: "History Of Me",
              subTitle: "Your own personal diary.",
              screenTitle: "Credits",
              credits: [
                CreditData(
                  role: "UX Design",
                  names: [
                    "Michael Grigorenko",
                  ],
                ),
                CreditData(
                  role: "Development",
                  names: [
                    "Michael Grigorenko",
                  ],
                ),
                CreditData(
                  role: "Photography",
                  names: backdropPhotoPhotographers,
                ),
              ],
            ),
          ),
        );
  }

  void _takeTour() {
    LitRouteController(context).pushMaterialWidget(
      HistoryOfMeIntroScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LitFooter(
      title: "Settings",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          LitPlainLabelButton(
            label: "Take the tour",
            onPressed: _takeTour,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: "About this app",
            onPressed: _showAboutThisAppDialog,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: "View Privacy",
            onPressed: _openPrivacyPolicy,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: "Delete all data",
            onPressed: _showDeleteDataDialog,
            textAlign: TextAlign.right,
          ),
          LitPlainLabelButton(
            label: "Credits",
            onPressed: _openCredits,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
