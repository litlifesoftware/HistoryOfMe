import 'package:flutter/material.dart';
import 'package:history_of_me/data/constants.dart';

class BookmarkFittedBox extends StatelessWidget {
  final double maxWidth;
  final Widget child;
  const BookmarkFittedBox({
    Key key,
    @required this.maxWidth,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: AspectRatio(
        aspectRatio: BookmarkConstants.bookmarkDimensions.aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(-2, -2),
                blurRadius: 12.0,
                spreadRadius: 2.0,
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
