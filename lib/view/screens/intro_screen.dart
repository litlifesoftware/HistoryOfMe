import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/view/widgets/shared/app_artwork.dart';
import 'package:history_of_me/view/widgets/shared/history_of_me_app_logo.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class IntroScreen extends StatefulWidget {
  //final void Function() onStartCallback;

  const IntroScreen({
    Key? key,
    //required this.onStartCallback,
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
                "History of Me offers you your own personal diary. You can browse through all your diary entries and organize your writings.")
      ],
      onExit: () => LitRouteController(context).pop(),
    );
    // LitOnboardingScreen(
    //   cardMargin: const EdgeInsets.only(
    //     top: 0.0,
    //     bottom: 0.0,
    //   ),
    //   artwork: Stack(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(
    //           vertical: 32.0,
    //         ),
    //         child: AppArtwork(),
    //       ),
    //       Align(
    //         alignment: Alignment.topRight,
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(
    //             vertical: 24.0,
    //             horizontal: 40.0,
    //           ),
    //           child: HistoryOfMeAppLogo(
    //             showKeyImage: true,
    //             color: Colors.black45,
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    //   onStartCallback: widget.onStartCallback,
    //   instructionCards: [
    //     InstructionCard(
    //       title: "1",
    //       description:
    //           "Sony Music Entertainment (Japan) Inc. (im Auftrag von (P)2018 Sony Music Records); SOLAR Music Rights Management, NexTone Inc. (Publishing), LatinAutor - SonyATV, UNIAO BRASILEIRA DE EDITORAS DE MUSICA - UBEM, LatinAutorPerf, Sony ATV Publishing und 9 musikalische Verwertungsgesellschaften",
    //       descriptionTextStyle: _descriptionTextStyle,
    //     ),
    //     InstructionCard(
    //       title: "2",
    //       description:
    //           "Sony Music Entertainment (Japan) Inc. (im Auftrag von (P)2018 Sony Music Records); SOLAR Music Rights Management, NexTone Inc. (Publishing), LatinAutor - SonyATV, UNIAO BRASILEIRA DE EDITORAS DE MUSICA - UBEM, LatinAutorPerf, Sony ATV Publishing und 9 musikalische Verwertungsgesellschaften",
    //       descriptionTextStyle: _descriptionTextStyle,
    //     ),
    //   ],
    //   onStartButtonText: "start",
    // );
  }
}
