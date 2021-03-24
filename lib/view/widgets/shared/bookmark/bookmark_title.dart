import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class BookmarkTitle extends StatelessWidget {
  final UserData userData;
  final BorderRadiusGeometry borderRadius;
  final Alignment alignment;
  const BookmarkTitle({
    Key key,
    @required this.userData,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
    ),
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor('#eae8e8'),
            borderRadius: borderRadius,
          ),
          child: RotatedBox(
            quarterTurns: 1,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image(
                      image: AssetImage(
                        "assets/images/History_Of_Me_Key_64px-01.png",
                      ),
                      fit: BoxFit.fitHeight,
                      //color: Colors.black,
                      height: 26.0,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RotatedBox(
                              quarterTurns: 3,
                              child: ScaledDownText(
                                "of",
                                style: LitTextStyles.serif.copyWith(
                                    fontSize: 8.0, color: HexColor('#9b9b9b')),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ScaledDownText(
                              "History",
                              style: LitTextStyles.serif.copyWith(
                                  fontSize: 10.0, color: HexColor('#9b9b9b')),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClippedText(
                            "${userData.name}",
                            style: LitTextStyles.serif.copyWith(
                              fontSize: 13.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: FittedBox(
                //     fit: BoxFit.scaleDown,
                //     child: Text(
                //       "Isabella",
                //       style: LitTextStyles.sansSerif,
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
