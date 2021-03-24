import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class HistoryOfMeAppLogo extends StatelessWidget {
  final double width;
  final double height;
  final bool showKeyImage;
  final Color color;
  const HistoryOfMeAppLogo(
      {Key key,
      this.width = 100.0,
      this.height = 120.0,
      this.showKeyImage = false,
      this.color = const Color(0xFFadadad)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      "History",
                      style: TextStyle(
                        fontFamily: "Playfair Display",
                        color: color,
                        fontSize: 24.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Text(
                    "of",
                    style: TextStyle(
                      fontFamily: "Playfair Display",
                      color: color,
                      fontSize: 20.0,
                      letterSpacing: -0.65,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Transform(
                transform: Matrix4.translationValues(12, 27.5, 0),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "me",
                    style: LitTextStyles.sansSerif.copyWith(
                      color: color,
                      fontSize: 52.0,
                      letterSpacing: -4.75,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              showKeyImage
                  ? Transform(
                      transform: Matrix4.translationValues(58, 57.5, 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                        ),
                        child: Image(
                          image: AssetImage(
                            "assets/images/History_Of_Me_Key_Icon_256px-01.png",
                          ),
                          // fit: BoxFit.fitWidth,
                          color: HexColor('#c9b5b5'),
                          //color: Colors.black,
                          height: 46.0,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
