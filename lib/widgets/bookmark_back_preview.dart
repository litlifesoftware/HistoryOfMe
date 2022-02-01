part of widgets;

class BookmarkBackPreview extends StatelessWidget {
  final EdgeInsets padding;
  final bool transformed;
  final UserData? userData;
  final AnimationController? animationController;
  const BookmarkBackPreview({
    Key? key,
    required this.userData,
    this.padding = const EdgeInsets.only(
      left: 16.0,
      right: 16.0,
      top: 30.0,
      bottom: 30.0,
    ),
    this.transformed = true,
    this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BookmarkPreviewContainer(
      transformed: transformed,
      reveredAnimation: true,
      animationController: animationController,
      padding: padding,
      child: BookmarkBack(
        userData: userData,
      ),
    );
  }
}
