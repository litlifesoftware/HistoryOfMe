import 'dart:math';

import 'package:flutter/material.dart';
import 'package:history_of_me/view/widgets/shared/bookmark/bookmark_cover.dart';

class BookmarkPreviewContainer extends StatefulWidget {
  final bool transformed;
  final EdgeInsets padding;
  final BookmarkCover child;
  const BookmarkPreviewContainer({
    Key key,
    @required this.transformed,
    @required this.padding,
    @required this.child,
  }) : super(key: key);
  @override
  _BookmarkPreviewContainerState createState() =>
      _BookmarkPreviewContainerState();
}

class _BookmarkPreviewContainerState extends State<BookmarkPreviewContainer>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    );
    if (widget.transformed) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Transform.rotate(
              angle: (2 * pi / 360) * 3 * _animationController.value,
              child: Transform(
                transform: widget.transformed
                    ? Matrix4.translationValues(
                        -20 + (20 * _animationController.value),
                        -20 + (20 * _animationController.value),
                        0)
                    : Matrix4.translationValues(0, 0, 0),
                child: Stack(
                    alignment: Alignment.center, children: [widget.child]),
                //UserBookmark(userData: ud)
              ),
            );
          }),
    );
  }
}
