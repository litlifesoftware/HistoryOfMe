import 'package:flutter/material.dart';
import 'package:history_of_me/view/shared/art/history_of_me_app_logo.dart';
import 'package:leitmotif/leitmotif.dart';

/// A screen widget to display a minimalist HistoryOfMe logo while the
/// application being loaded.
class SplashScreen extends StatelessWidget {
  /// Creates a [SplashScreen].
  ///
  const SplashScreen();
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
