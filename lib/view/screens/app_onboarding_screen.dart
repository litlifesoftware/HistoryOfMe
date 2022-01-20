import 'package:flutter/material.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';

/// A `screen` widget returning a customized [LitOnboardingScreen].
///
/// The screen will display all main features of `History of Me` on a card
/// view.
class AppOnboardingScreen extends StatefulWidget {
  final void Function()? onDismiss;
  const AppOnboardingScreen({
    Key? key,
    this.onDismiss,
  }) : super(key: key);
  @override
  _AppOnboardingScreenState createState() => _AppOnboardingScreenState();
}

class _AppOnboardingScreenState extends State<AppOnboardingScreen> {
  /// Returns customized localizations for the onboarding screen.
  LitOnboardingScreenLocalization get localizations =>
      LitOnboardingScreenLocalization(
        title: LeitmotifLocalizations.of(context).onboardingLabel,
        nextLabel: LeitmotifLocalizations.of(context).nextLabel,
        dismissLabel: AppLocalizations.of(context).continueLabel,
      );

  /// Handles the `dismiss` action.
  void _onDismiss() {
    if (widget.onDismiss != null) {
      widget.onDismiss!();
    } else {
      LitRouteController(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LitOnboardingScreen(
      localization: localizations,
      showButtonIcon: false,
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
          subtitle: AppLocalizations.of(context).organizeLabel,
          title: AppLocalizations.of(context).browseDiaryTitle,
          text: AppLocalizations.of(context).browseDiaryDescr,
        ),
        TextPageContent(
          subtitle: AppLocalizations.of(context).reliveLabel,
          title: AppLocalizations.of(context).readDiaryTitle,
          text: AppLocalizations.of(context).readDiaryDescr,
        ),
        TextPageContent(
          subtitle: AppLocalizations.of(context).personalizeLabel,
          title: AppLocalizations.of(context).customizeBookmarkTitle,
          text: AppLocalizations.of(context).customizeBookmarkDescr,
        ),
        TextPageContent(
          subtitle: AppLocalizations.of(context).privateLabel,
          title: LeitmotifLocalizations.of(context).privacyLabel,
          text: AppLocalizations.of(context).privacyDescr,
        ),
      ],
      onDismiss: _onDismiss,
    );
  }
}
