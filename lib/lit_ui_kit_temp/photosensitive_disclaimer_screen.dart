import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class PhotosensitiveDisclaimerScreen extends StatelessWidget {
  final void Function() onAccept;
  final String title;
  final String text;
  final String buttonText;
  const PhotosensitiveDisclaimerScreen({
    Key? key,
    required this.onAccept,
    this.title = "Photosensitive Warning",
    this.text =
        "This app contains animations that might trigger an epileptic seizure in some circumstances.",
    this.buttonText = "Okay",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#eaeaea'),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 64.0,
                  ),
                  child: ScrollableColumn(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _BoltIconContainer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32.0,
                              horizontal: 30.0,
                            ),
                            child: Text(
                              title,
                              textAlign: TextAlign.left,
                              style: LitTextStyles.sansSerif.copyWith(
                                color: HexColor('#444444'),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 40.0,
                        ),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: LitTextStyles.sansSerif.copyWith(
                            color: HexColor('#444444'),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: LitRoundedElevatedButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 10.0,
                      ),
                      color: Colors.white,
                      child: Text(
                        buttonText,
                        textAlign: TextAlign.left,
                        style: LitTextStyles.sansSerif.copyWith(
                          color: HexColor('#444444'),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: onAccept),
                ),
              ),
            ],
          ),
        ));
  }
}

class _BoltIconContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140.0,
        width: 160.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 16.0,
              color: Colors.black26,
              offset: Offset(2.0, 2.0),
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: _FigureSide(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  child: _FigureSide(
                    mirrored: true,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 3.0,
              ),
              child: Icon(
                LitIcons.bolt,
                size: 50.0,
                color: HexColor('#444444').withOpacity(0.8),
              ),
            )
          ],
        ));
  }
}

class _FigureSide extends StatelessWidget {
  final bool mirrored;
  final Color color;
  const _FigureSide({
    Key? key,
    this.mirrored = false,
    this.color = const Color(0xFFeaeaea),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: 45,
      child: Transform(
        alignment: Alignment.center,
        transform: mirrored
            ? Matrix4.rotationY(pi)
            : Matrix4.translationValues(0, 0, 0),
        child: Container(
          decoration: BoxDecoration(
              color: color,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8.0,
                  color: Colors.black26,
                  offset: Offset(
                    2,
                    2,
                  ),
                  spreadRadius: 1.0,
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(6.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(10.0),
              )),
        ),
      ),
    );
  }
}
