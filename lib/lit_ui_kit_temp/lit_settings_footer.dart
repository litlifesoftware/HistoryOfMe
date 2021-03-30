import 'package:flutter/material.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_plain_label_button.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitSettingsFooter extends StatelessWidget {
  final String title;
  final Widget child;

  const LitSettingsFooter({
    Key? key,
    this.title = "Settings",
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor('#C4C4C4').withOpacity(0.4),
                Colors.white,
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 82.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: ClippedText(
                    title,
                    textAlign: TextAlign.start,
                    style: LitTextStyles.sansSerif.copyWith(
                      fontSize: 22.0,
                      color: HexColor('#878787'),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
