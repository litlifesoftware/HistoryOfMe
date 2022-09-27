import 'package:flutter/material.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

class AppCreditsScreen extends StatelessWidget {
  const AppCreditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitCreditsScreen(
      art: AppLauncherIconArt(
        boxShadow: LitBoxShadows.sm,
      ),
      appName: App.appName,
      appDescription: AppLocalizations.of(context).aboutAppDescr,
      credits: [
        CreditData(
          role: LeitmotifLocalizations.of(context).creatorLabel,
          names: [
            App.appDeveloper,
          ],
        ),
        CreditData(
          role: LeitmotifLocalizations.of(context).userExpericenceDesignLabel,
          names: [
            AppLocalizations.of(context).creatorName,
          ],
        ),
        CreditData(
          role: LeitmotifLocalizations.of(context).developmentLabel,
          names: [
            AppLocalizations.of(context).creatorName,
          ],
        ),
        CreditData(
          role: AppLocalizations.of(context).inspiredByLabel,
          names: [
            AppLocalizations.of(context).inspiredByMovieTitle,
          ],
        ),
      ],
    );
  }
}
