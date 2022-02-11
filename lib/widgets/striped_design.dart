part of widgets;

/// A `History of Me` widget implementing a striped [BookmarkDesign] to be
/// used as a bookmark preview based on the [UserData] provided.
class StripedDesign extends StatelessWidget implements BookmarkDesign {
  /// The bookmark's radius.
  final double radius;

  /// The user data containing the bookmark configuration.
  final UserData userData;

  /// Creates a [StripedDesign].
  const StripedDesign({
    Key? key,
    required this.radius,
    required this.userData,
  }) : super(key: key);

  /// The total stripes count.
  int get _stripeCount {
    return userData.stripeCount;
  }

  /// The bookmark height.
  double get _height {
    return BookmarkCover.height;
  }

  /// The bookmark width.
  double get _width {
    return BookmarkCover.width;
  }

  /// Returns the stripe's aspect ratio.
  double get _stripeAspectRatio {
    return _width / (_height / _stripeCount);
  }

  Color get _primaryColor => Color(userData.primaryColor);

  Color get _accentColor => Colors.white;

  /// Returns a list of [_Stripe] widgets.
  List<Widget> get stripes {
    List<Widget> stripeList = [];

    for (int i = 0; i < _stripeCount; i++) {
      // Create a two-color pattern by only coloring every second stripe.
      if (i % 2 == 0) {
        /// Add a colored stripe
        stripeList.add(
          _Stripe(
            aspectRatio: _stripeAspectRatio,
            color: _primaryColor,
          ),
        );
      } else {
        /// Add a white stripe
        stripeList.add(
          _Stripe(
            aspectRatio: _stripeAspectRatio,
            color: _accentColor,
          ),
        );
      }
    }

    return stripeList;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(radius),
      ),
      child: Stack(
        children: [
          // Ensure to paint on a solid background.
          Container(color: _accentColor),
          Column(children: stripes),
        ],
      ),
    );
  }
}

/// A stripe on a stripped bookmark design.
class _Stripe extends StatelessWidget {
  final double aspectRatio;
  final Color color;
  const _Stripe({
    Key? key,
    required this.aspectRatio,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
      ),
    );
  }
}
