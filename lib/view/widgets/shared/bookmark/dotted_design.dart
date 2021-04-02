import 'package:flutter/material.dart';
import 'package:history_of_me/data/constants.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/shared/bookmark/bookmark_design.dart';
import 'dart:ui' as ui;

/// Part of the [BookmarkDesign] classes.
/// A grid matrix filled with dots in varying colors
/// which will either be animated or static, dependend
/// on the provided [userData] property values.
class DottedDesign extends StatelessWidget implements BookmarkDesign {
  final double radius;
  final AnimationController? animationController;
  final UserData? userData;
  const DottedDesign({
    Key? key,
    required this.radius,
    required this.animationController,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (context, child) {
          return Stack(children: [
            AspectRatio(
              aspectRatio: BookmarkConstants.bookmarkDimensions.aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  /// Increase the provided color's brightness and set it
                  /// to be the background color of the design.
                  color: Color.lerp(
                      Color(userData!.primaryColor), Colors.white, 0.6),
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
            ),
            CustomPaint(
              painter: DottedDesignPainter(
                userData: userData,
                animation:
                    Tween(begin: 0.4, end: 1.0).animate(animationController!),
              ),

              /// Set an empty [Container] as the child to ensure the painting
              /// will be displayed.
              child: Container(),
            ),
          ]);
        },
      ),
    );
  }
}

/// Modified [CustomPainter] to create a grid matrix of
/// dots in alternating colors.
class DottedDesignPainter extends CustomPainter {
  final Animation animation;
  final UserData? userData;
  DottedDesignPainter({
    required this.animation,
    required this.userData,
  });
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    /// The inital vertical offset value relative
    /// to the widgets, which will be painted on.
    final double initalHorizontalOffset =
        (size.height / this.userData!.dotSize);

    /// Get the vertical offset, which will be depended
    /// on the dot size and the current grid's column
    /// count (provided by the iterator [i]'s value).
    double getHorizontalOffset(int i) {
      return initalHorizontalOffset + (i * (this.userData!.dotSize * 1.7));
    }

    /// The inital horizontal offset value relative
    /// to the widgets, which will be painted on.
    final double initalVerticalOffset = (size.height / this.userData!.dotSize);

    /// Get the horizontal offset, which will be depended
    /// on the dot size and the current grid's row
    /// count (provided by the iterator [j]'s value).
    double getVerticalOffset(int j) {
      return initalVerticalOffset + (this.userData!.dotSize * j);
    }

    /// Get the doz size. It will either be mutated by the
    /// current [Animation] value or fixed, if the animation
    /// is disabled.
    double getDotSize() {
      return this.userData!.dotSize *
          (this.userData!.animated ? this.animation.value : 0.4) as double;
    }

    final int getRowCount = size.width ~/ this.userData!.dotSize;

    final int getColumnCount = (size.height ~/ this.userData!.dotSize) +
        (this.userData!.dotSize ~/ initalVerticalOffset);

    /// The list of [Paint] objects will vary in their [Color].
    List<Paint> paints = [
      Paint()
        // The provided color.
        ..color = Color(this.userData!.primaryColor)
        ..strokeWidth = 4.0
        ..style = PaintingStyle.fill,
      Paint()
        // Brightened provided color.
        ..color =
            Color.lerp(Color(this.userData!.primaryColor), Colors.white, 0.3)!
        ..strokeWidth = 4.0
        ..style = PaintingStyle.fill,
      Paint()
        // Brightened provided color.
        ..color =
            Color.lerp(Color(this.userData!.primaryColor), Colors.white, 0.5)!
        ..strokeWidth = 4.0
        ..style = PaintingStyle.fill,
    ];

    /// Paint the grid matrix of dots using a nested loop.
    void paintCircles() {
      // Create the rows fields of the grid using the utmost loop.
      for (int i = 0; i < getRowCount; i++) {
        // Create the columns fields of the grid using the
        // mid-level loop.
        for (int j = 0; j < getColumnCount; j++) {
          // Paint the alternating colored dots in the fields
          // by varying the used Paint objects inside the list.
          for (int k = 0; k < paints.length; k++) {
            // Paint the circle
            canvas.drawCircle(
              // Calculate the vertical and horizontal offset
              // using the corresponding iterator values.
              Offset(getHorizontalOffset(i), getVerticalOffset(j)),
              // Set the dot size.
              getDotSize(),

              /// Every column and row will either have two
              /// of the three colors.
              /// Check if the row count is even
              i % 2 == 0
                  // If so, toggle between the previous and the
                  // current color by checking if the column
                  // count is also even.
                  ? paints[j % 2 == 0
                      ? ((k - 1) > 0)
                          ? k - 1
                          : k
                      : k]
                  // else the row count is uneven
                  : paints[
                      // Toggle beween the next and the current
                      // color by checking if the column count
                      // even. If the last Paint is reached,
                      // start all over again.
                      j % 2 == 0
                          ? (k + 1) != paints.length
                              ? (k + 1)
                              : k
                          : 0],
            );
          }
        }
      }
    }

    // Draw the circles.
    paintCircles();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Perform the repaint in any case.
    return true;
  }
}
