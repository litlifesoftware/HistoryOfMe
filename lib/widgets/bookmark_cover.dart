part of widgets;

abstract class BookmarkCover extends Widget {
  static const Size dimensions = const Size(8.5, 2.5);
  static double get aspectRatio => dimensions.aspectRatio;
  static double get height => dimensions.height;
  static double get width => dimensions.width;
}
