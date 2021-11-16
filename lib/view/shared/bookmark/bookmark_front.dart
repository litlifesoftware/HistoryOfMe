import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_data.dart';

import 'bookmark_container.dart';
import 'bookmark_cover.dart';
import 'bookmark_design.dart';
import 'bookmark_title.dart';
import 'dotted_design.dart';
import 'striped_design.dart';

class BookmarkFront extends StatelessWidget implements BookmarkCover {
  final UserData userData;
  final double maxWidth;
  final double radius;
  const BookmarkFront({
    Key? key,
    required this.userData,
    this.maxWidth = 400.0,
    this.radius = 6.0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BookmarkFittedBox(
      maxWidth: maxWidth,
      child: Stack(
        children: [
          _BookmarkFrontArt(
            userData: userData,
            radius: radius,
          ),
          BookmarkTitle(userData: userData),
        ],
      ),
    );
  }
}

class _BookmarkFrontArt extends StatefulWidget {
  final UserData userData;
  final double radius;
  const _BookmarkFrontArt({
    Key? key,
    required this.userData,
    required this.radius,
  }) : super(key: key);

  @override
  __BookmarkFrontArtState createState() => __BookmarkFrontArtState();
}

class __BookmarkFrontArtState extends State<_BookmarkFrontArt>
    with TickerProviderStateMixin {
  AnimationController? _patternAnimationController;

  @override
  void initState() {
    super.initState();
    _patternAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );
    _patternAnimationController!.forward();
    _patternAnimationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _patternAnimationController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _patternAnimationController!.forward();
      }
    });
  }

  @override
  void dispose() {
    _patternAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(
            widget.radius,
          ))),
        ),
        DesignType.values[widget.userData.designPatternIndex] ==
                DesignType.stiped
            ? StripedDesign(
                radius: widget.radius,
                userData: widget.userData,
              )
            : DottedDesign(
                radius: widget.radius,
                animationController: _patternAnimationController,
                userData: widget.userData,
              )
      ],
    );
  }
}
