part of widgets;

class BookmarkPreviewContainer extends StatefulWidget {
  final bool transformed;
  final bool reveredAnimation;
  final EdgeInsets padding;
  final BookmarkCover child;
  final AnimationController? animationController;
  const BookmarkPreviewContainer({
    Key? key,
    required this.transformed,
    this.reveredAnimation = false,
    required this.padding,
    required this.child,
    this.animationController,
  }) : super(key: key);
  @override
  _BookmarkPreviewContainerState createState() =>
      _BookmarkPreviewContainerState();
}

class _BookmarkPreviewContainerState extends State<BookmarkPreviewContainer>
    with TickerProviderStateMixin {
  //late AnimationController _animationController;

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     duration: Duration(milliseconds: 5000),
  //     vsync: this,
  //   );
  //   if (widget.transformed) {
  //     _animationController.repeat(reverse: true);
  //   }
  // }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }
  //
  //

  double get _animationValue {
    return widget.reveredAnimation
        ? (1.0 - widget.animationController!.value)
        : (widget.animationController!.value);
  }

  double get _rotation {
    return (2 * pi / 360) * 3 * (_animationValue);
  }

  Matrix4 get _transform {
    return Matrix4.translationValues(
        -20 + (20 * _animationValue), -20 + (20 * _animationValue), 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: widget.animationController != null
          ? AnimatedBuilder(
              animation: widget.animationController!,
              builder: (context, _) {
                return Transform.rotate(
                  angle: _rotation,
                  child: Transform(
                    transform: widget.transformed
                        ? _transform
                        : Matrix4.translationValues(0, 0, 0),
                    child: _Bookmark(
                      child: widget.child,
                    ),
                    //UserBookmark(userData: ud)
                  ),
                );
              })
          : _Bookmark(
              child: widget.child,
            ),
    );
  }
}

class _Bookmark extends StatelessWidget {
  final Widget child;

  const _Bookmark({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [child]);
  }
}
