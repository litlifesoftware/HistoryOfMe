import 'package:flutter/material.dart';
import 'package:history_of_me/data/constants.dart';

class StripedDesignController {
  final Color? color;
  final List<Color>? colors;
  final int? count;
  final double radius;
  const StripedDesignController({
    this.color,
    this.colors,
    this.count,
    required this.radius,
  }) : assert(
          /// If colors are provided
          colors != null
              ?

              /// The color and count must
              /// be not provided
              color == null && count == null

                  /// Otherwise
                  ||

                  /// The colors must be not
                  /// provided
                  colors == null

              /// Set to default (true)

              : true,
        );

  /// The total amount of required stripes.
  /// It will either be the [count] value or
  /// the [colors] list length.
  int get _stripeCount {
    return count ?? colors!.length;
  }

  /// The bookmark dimensions.
  Size get _bookmarkDimensions {
    return BookmarkConstants.bookmarkDimensions;
  }

  /// The bookmark height.
  double get _bookmarkHeight {
    return _bookmarkDimensions.height;
  }

  /// The bookmark width.
  double get _bookmarkWidth {
    return _bookmarkDimensions.width;
  }

  double get _stripeAspectRatio {
    return _bookmarkWidth / (_bookmarkHeight / _stripeCount);
  }

  List<Widget> get stripes {
    List<Widget> stripeList = [];

    /// If the count is initalized, set its value
    /// to the local counter, otherwise it's not
    /// provided and the color's list length will be
    /// used.
    for (int i = 0; i < _stripeCount; i++) {
      /// If a semi colored stripe design
      /// is requested.
      if (color != null) {
        if (i % 2 == 0) {
          /// Add a colored stripe
          stripeList.add(AspectRatio(
            aspectRatio: _stripeAspectRatio,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:

                    /// If it's the only stripe in the list,
                    /// round all corners.
                    _stripeCount == 1
                        ? BorderRadius.all(
                            Radius.circular(radius),
                          )
                        :

                        /// If it't the first stripe,
                        /// round the corners.
                        i == 0
                            ? BorderRadius.only(
                                topLeft: Radius.circular(radius),
                                topRight: Radius.circular(radius),
                              )
                            :

                            /// If it's the last stripe,
                            /// also round the corners.
                            i == _stripeCount - 1
                                ? BorderRadius.only(
                                    bottomLeft: Radius.circular(radius),
                                    bottomRight: Radius.circular(radius),
                                  )

                                /// Otherwise remain the corners
                                /// angular.
                                : null,
                color: color,
              ),
            ),
          ));

          /// Add a white stripe
        } else {
          stripeList.add(AspectRatio(
            aspectRatio: _stripeAspectRatio,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:

                    /// If it't the first stripe,
                    /// round the corners.
                    i == 0
                        ? BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                          )
                        :

                        /// If it's the last stripe,
                        /// also round the corners.
                        i == _stripeCount - 1
                            ? BorderRadius.only(
                                bottomLeft: Radius.circular(radius),
                                bottomRight: Radius.circular(radius),
                              )

                            /// Otherwise remain the corners
                            /// angular.
                            : null,
                color: Colors.white,
              ),
            ),
          ));
        }
      } else {
        /// Else a color list is provided
        stripeList.add(AspectRatio(
          aspectRatio: _stripeAspectRatio,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:

                  /// If it't the first stripe,
                  /// round the corners.
                  i == 0 || _stripeCount == 1
                      ? BorderRadius.only(
                          topLeft: Radius.circular(radius),
                          topRight: Radius.circular(radius),
                        )
                      :

                      /// If it's the last stripe,
                      /// also round the corners.
                      i == _stripeCount - 1
                          ? BorderRadius.only(
                              bottomLeft: Radius.circular(radius),
                              bottomRight: Radius.circular(radius),
                            )

                          /// Otherwise remain the corners
                          /// angular.
                          : null,
              color: colors![i],
            ),
          ),
        ));
      }
    }
    return stripeList;
  }
}
