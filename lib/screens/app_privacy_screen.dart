import 'package:flutter/material.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

class AppPrivacyScreen extends StatelessWidget {
  const AppPrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitPrivacyPolicyScreen(
      onAgreeCallback: () => LitRouteController(context).pop(),
      privacyBody: AppLocalizations.of(context).privacyDescr,
      art: AppLauncherIconArt(),
    );
  }
}
