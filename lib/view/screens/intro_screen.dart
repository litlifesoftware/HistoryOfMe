import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/view/widgets/shared/app_artwork.dart';
import 'package:history_of_me/view/widgets/shared/history_of_me_app_logo.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    Key? key,
  }) : super(key: key);
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  TextStyle get _descriptionTextStyle {
    return LitTextStyles.sansSerif.copyWith(
      color: Colors.white,
      fontSize: 15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LitOnboardingScreen(
      title: "Introducation",
      art: SizedBox(
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
      textItems: [
        OnboardingText(
          subtitle: "Organize",
          title: "Browse through your diary",
          text:
              "History of Me offers you your own personal diary. You can browse through all your diary entries and organize your writings.",
        ),
        OnboardingText(
          subtitle: "Relive",
          title: "Read your diary entries",
          text:
              "Click on one of the entires on your diary in order to read an entry and to relive your memories.",
        ),
        OnboardingText(
          subtitle: "Personalize",
          title: "Customize your bookmark",
          text:
              "Can you see the bookmark on top of your diary? You can customize it. Go to your profile and tap on the pencil under your bookmark to edit it. Set your favorite color pallet and a nice pattern. Don't forget to save your changes!",
        ),
      ],
      onExit: () => LitRouteController(context).pop(),
    );
  }
}
