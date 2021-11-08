import 'package:flutter/material.dart';
import 'package:history_of_me/view/shared/art/history_of_me_app_logo.dart';
import 'package:leitmotif/leitmotif.dart';

/// Creates a [SplashScreen].
///
/// A screen widget to display the HistoryOfMe logo while the application is loading.
///
/// Note that the logo won't show the key image due to the images still being loaded into the
/// app bundle. So this screen should only contain less expensive to render items.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LitStaticLoadingScreen(
      child: HistoryOfMeAppLogo(
        color: Colors.white,
        showKeyImage: false,
      ),
    );
  }
}
