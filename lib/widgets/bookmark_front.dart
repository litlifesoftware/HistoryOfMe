part of widgets;

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

class _BookmarkFrontArt extends StatelessWidget {
  final UserData userData;
  final double radius;
  const _BookmarkFrontArt({
    Key? key,
    required this.userData,
    required this.radius,
  }) : super(key: key);

  /// Returns the current design type selected by the user.
  DesignType get type => DesignType.values[userData.designPatternIndex];

  /// Returns the appropriate design implementation based on the [type] value.
  Widget get design {
    switch (type) {
      case DesignType.stiped:
        return StripedDesign(
          radius: radius,
          userData: userData,
        );
      case DesignType.dotted:
        return DottedDesign(
          radius: radius,
          userData: userData,
        );
      default:
        return StripedDesign(
          radius: radius,
          userData: userData,
        );
    }
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                radius,
              ),
            ),
          ),
        ),
        design
      ],
    );
  }
}
