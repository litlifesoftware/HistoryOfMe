import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/shared/bookmark/bookmark_container.dart';
import 'package:history_of_me/view/widgets/shared/bookmark/bookmark_cover.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class BookmarkBack extends StatefulWidget implements BookmarkCover {
  final UserData? userData;
  final double maxWidth;
  final double radius;
  const BookmarkBack({
    Key? key,
    required this.userData,
    this.maxWidth = 400.0,
    this.radius = 5.0,
  }) : super(key: key);

  @override
  _BookmarkBackState createState() => _BookmarkBackState();
}

class _BookmarkBackState extends State<BookmarkBack> {
  @override
  Widget build(BuildContext context) {
    return BookmarkFittedBox(
      maxWidth: widget.maxWidth,
      child: Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.radius),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      //    width: (constraints.maxWidth * ((3 / 3.86))),
                      width: (constraints.maxWidth - 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(widget.radius),
                            topLeft: Radius.circular(widget.radius),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.lerp(
                                        Colors.white,
                                        Color(widget.userData!.primaryColor),
                                        0.3)!
                                    .withOpacity(0.4),
                                Color.lerp(
                                        Colors.white,
                                        Color(widget.userData!.primaryColor),
                                        0.5)!
                                    .withOpacity(0.4),
                              ])),
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: ClippedText(
                                      "${widget.userData!.quote}",
                                      maxLines: 4,
                                      style: LitTextStyles.sansSerif.copyWith(
                                          height: 1.27,
                                          backgroundColor: HexColor('#fff2b0'),
                                          fontSize: 12.0,
                                          color: HexColor('#444444'),
                                          letterSpacing: -0.3),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Container(
                                          height: 2.0,
                                          width: constraints.maxWidth * (1 / 3),
                                          decoration: BoxDecoration(
                                            color: HexColor('#b5b5b5'),
                                            borderRadius: BorderRadius.circular(
                                              2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClippedText(
                                        "${widget.userData!.quoteAuthor}",
                                        style: LitTextStyles.sansSerif.copyWith(
                                          fontSize: 11.0,
                                          letterSpacing: 0.2,
                                          fontWeight: FontWeight.w700,
                                          color: HexColor('#7c7b7b'),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal: 6.0,
                                ),
                                child: Icon(
                                  LitIcons.quote_left,
                                  color: HexColor('#727272'),
                                  size: 10.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3.0,
                                  horizontal: 6.0,
                                ),
                                child: Icon(
                                  LitIcons.quote_right,
                                  color: HexColor('#727272'),
                                  size: 10.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    _BookmarkBackDecor(
                      constraints: constraints,
                      radius: widget.radius,
                    ),
                    // BookmarkTitle(
                    //   userData: widget.userData,
                    //   borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(widget.radius),
                    //     bottomRight: Radius.circular(widget.radius),
                    //   ),
                    // ),
                  ],
                )
              ],
            );
          }),
        ],
      ),
    );
  }
}

// 8.5

// 2.5

// 3/4

class _BookmarkBackDecor extends StatelessWidget {
  final BoxConstraints constraints;
  final double radius;
  const _BookmarkBackDecor(
      {Key? key, required this.constraints, required this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: constraints.maxHeight,
      decoration: BoxDecoration(
          color: HexColor('#7c7b7b'),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2.0,
        ),
        child: Image(
          image: AssetImage(
            "assets/images/History_Of_Me_Key_64px-01.png",
          ),
          fit: BoxFit.fitWidth,
          color: HexColor('#afafaf'),
          //color: Colors.black,
          height: 14.0,
        ),
      ),
    );
  }
}
