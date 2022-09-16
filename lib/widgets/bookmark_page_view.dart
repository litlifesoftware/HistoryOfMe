part of widgets;

/// A History of Me widget displaying the bookmark's front and back on a page
/// view.
class BookmarkPageView extends StatelessWidget {
  /// The data containing the bookmark configuration.
  final UserData userData;

  /// The bookmark's animation.
  final AnimationController animationController;

  /// The page view's total height.
  final double height;

  final EdgeInsets padding;

  /// Creates a [BookmarkPageView].
  const BookmarkPageView({
    Key? key,
    required this.userData,
    required this.animationController,
    this.height = 180.0,
    this.padding = LitEdgeInsets.screen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IndexedPageView(
      height: height,
      indicatorSpacingTop: 0.0,
      tapToNavigate: true,
      children: [
        BookmarkFrontPreview(
          userData: userData,
          animationController: animationController,
          padding: padding,
        ),
        BookmarkBackPreview(
          userData: userData,
          animationController: animationController,
          padding: padding,
        ),
      ],
      indicatorColor: LitColors.grey400,
    );
  }
}
