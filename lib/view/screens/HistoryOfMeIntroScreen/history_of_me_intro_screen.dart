import 'package:flutter/material.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';

/// A screen widget displaying a modified version of the [LitOnboardingScreen].
///
/// The screen will display all main features of `History of Me` on a card
/// view.
class HistoryOfMeIntroScreen extends StatefulWidget {
  const HistoryOfMeIntroScreen({
    Key? key,
  }) : super(key: key);
  @override
  _HistoryOfMeIntroScreenState createState() => _HistoryOfMeIntroScreenState();
}

class _HistoryOfMeIntroScreenState extends State<HistoryOfMeIntroScreen> {
  void _onExit() {
    LitRouteController(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return LitOnboardingScreen(
      //title: HOMLocalizations(context).introduction,
      //nextButtonLabel: HOMLocalizations(context).next,

      art: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HistoryOfMeAppLogo(
                    width: constraints.maxWidth * 0.25,
                    showKeyImage: true,
                    color: Colors.white,
                  ),
                  AppArtwork(
                    width: constraints.maxWidth * 0.65,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      textItems: [
        TextPageContent(
          subtitle: HOMLocalizations(context).private,
          title: HOMLocalizations(context).privacy,
          text: HOMLocalizations(context).privacyDescr,
        ),
        TextPageContent(
          subtitle: HOMLocalizations(context).organize,
          title: HOMLocalizations(context).browseDiaryTitle,
          text: HOMLocalizations(context).browseDiaryDescr,
        ),
        TextPageContent(
          subtitle: HOMLocalizations(context).relive,
          title: HOMLocalizations(context).readYourDiaryEntriesTitle,
          text: HOMLocalizations(context).readYourDiaryEntriesDescr,
        ),
        TextPageContent(
          subtitle: HOMLocalizations(context).personalize,
          title: HOMLocalizations(context).customizeBookmarkTitle,
          text: HOMLocalizations(context).customizeBookmarkDescr,
        ),
      ],
      onDismiss: _onExit,
    );
  }
}
