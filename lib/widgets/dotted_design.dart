part of widgets;

/// A `History of Me` widget implementing a dotted [BookmarkDesign] to be
/// used as a bookmark preview based on the [UserData] provided.
class DottedDesign extends StatefulWidget implements BookmarkDesign {
  /// The bookmark
  final double radius;
  final UserData userData;

  /// Creates a [DottedDesign].
  const DottedDesign({
    Key? key,
    required this.radius,
    required this.userData,
  }) : super(key: key);

  static const animationDuration = Duration(milliseconds: 4000);

  @override
  State<DottedDesign> createState() => _DottedDesignState();
}

class _DottedDesignState extends State<DottedDesign>
    with TickerProviderStateMixin {
  /// The dot animation.
  late AnimationController _animationController;

  /// The bookmark's design primary color.
  Color get _primaryColor => Color(widget.userData.primaryColor);

  /// The bookmark's design accent color.
  Color get _accentColor => Colors.white;

  /// Returns the bookmark's background color.
  ///
  /// Increase the [_primaryColor]'s brightness using the [_accentColor].
  Color? get _backgroundColor => Color.lerp(_primaryColor, _accentColor, 0.6);

  /// Returns a tween animation starting at a fixed begin value to ensure
  /// the dots have a fixed minimun size when being animated.
  Animation<double> get _animation => Tween(begin: 0.4, end: 1.0).animate(
        _animationController,
      );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: DottedDesign.animationDuration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: BookmarkCover.aspectRatio,
                child: Container(
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        widget.radius,
                      ),
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: DottedDesignPainter(
                  userData: widget.userData,
                  animation: _animation,
                ),
                child: Container(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Modified [CustomPainter] to create a grid matrix of
/// dots in alternating colors.
class DottedDesignPainter extends CustomPainter {
  final Animation animation;
  final UserData userData;

  /// Creates a [DottedDesignPainter].
  DottedDesignPainter({
    required this.animation,
    required this.userData,
  });
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // States whether to animate the dot grid
    final bool _shouldAnimate = this.userData.animated;

    // The user's preferred dot size.
    final int _dotSize = this.userData.dotSize;

    // The user's main color.
    final Color _mainColor = Color(this.userData.primaryColor);

    // The accent color applied on the color lerp.
    final Color _accentColor = Colors.white;

    /// The initial offset's x value based on the device width.
    final double initialOffsetX = size.width / _dotSize;

    /// The initial offset's y value based on the device height.
    final double initialOffsetY = size.height / _dotSize;

    /// The total row count based on the device width.
    final int rowCount = size.width ~/ _dotSize;

    /// The total column count based on the device height.
    final int columnCount =
        (size.height ~/ _dotSize) + (_dotSize ~/ initialOffsetY);

    /// Calculates the offset's x value.
    double calcOffsetX(int row) {
      return initialOffsetX + (row * _dotSize * 1.7);
    }

    /// Calculates the offset's y value.
    double calcOffsetY(int column) {
      return initialOffsetY + (_dotSize * column);
    }

    /// Calculates the offset of a circle based on its position on the grid.
    Offset calcOffset(int row, int column) {
      return Offset(calcOffsetX(row), calcOffsetY(column));
    }

    /// Get the doz size. It will either be mutated by the
    /// current [Animation] value or fixed, if the animation
    /// is disabled.
    double calcDotSize() {
      if (_shouldAnimate) {
        return _dotSize * this.animation.value as double;
      }
      return 0.4;
    }

    /// The list of [Paint] objects will vary in their [Color].
    List<Paint> paints = [
      Paint()
        // The provided color.
        ..color = _mainColor
        ..strokeWidth = 4.0
        ..style = PaintingStyle.fill,
      Paint()
        // Brightened provided color.
        ..color = Color.lerp(_mainColor, _accentColor, 0.25)!
        ..strokeWidth = 4.0
        ..style = PaintingStyle.fill,
      Paint()
        // Brightened provided color.
        ..color = Color.lerp(_mainColor, _accentColor, 0.5)!
        ..strokeWidth = 4.0
        ..style = PaintingStyle.fill,
    ];

    /// Returns a [Paint] based on the current position on the grid.
    ///
    /// Every column and row will either have two of the three colors.
    /// Event and uneven row counts will result in differently colored
    /// circles.
    Paint getPaintByGridPosition(int row, int column, int i) {
      // States whether the paint's list has not been exceeded.
      bool inUpperRange = (i + 1) < paints.length;
      // States whether the paint's list index is in range.
      bool inLowerRange = (i - 1) >= 0;

      // Check if the row count is even.
      if (row % 2 == 0) {
        // Toggle between the previous and the current color by checking if
        // the column count is also even.
        if (column % 2 == 0) {
          if (inLowerRange) {
            return paints[i - 1];
          } else {
            return paints[i];
          }
        }
        return paints[i];
      }
      // Check if the row count is even.
      if (column % 2 == 0) {
        if (inUpperRange) {
          return paints[i + 1];
        } else {
          return paints[i];
        }
      } else {
        return paints[0];
      }
    }

    /// Paints the grid of dots using a nested loop.
    void paintCircleGrid() {
      // Create rows.
      for (int i = 0; i < rowCount; i++) {
        // Create column.
        for (int j = 0; j < columnCount; j++) {
          // Iterate through the paint list to paint each dot.
          for (int k = 0; k < paints.length; k++) {
            // Paint the circle
            canvas.drawCircle(
              calcOffset(i, j),
              calcDotSize(),
              getPaintByGridPosition(i, j, k),
            );
          }
        }
      }
    }

    // Paint the circles.
    paintCircleGrid();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Perform the repaint in any case.
    return true;
  }
}
