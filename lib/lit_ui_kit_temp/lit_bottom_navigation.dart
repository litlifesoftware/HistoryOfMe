import 'package:flutter/material.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_bottom_navigation_item.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitBottomNavigation extends StatefulWidget {
  final int currentTabIndex;
  final void Function(int) onPressed;
  final double landscapeWidthFactor;
  final Axis axis;
  const LitBottomNavigation({
    Key key,
    @required this.currentTabIndex,
    @required this.onPressed,
    this.landscapeWidthFactor = 0.65,
    this.axis = Axis.horizontal,
  }) : super(key: key);
  @override
  _LitBottomNavigationState createState() => _LitBottomNavigationState();
}

class _LitBottomNavigationState extends State<LitBottomNavigation>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  void switchTab(int value) {
    widget.onPressed(value);
    if (_animationController.isCompleted) {
      _animationController.reverse().then(
            (value) => _animationController.forward(),
          );
    }
  }

  bool get _showAlternativeOnLandscape {
    return widget.axis == Axis.vertical;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(
        milliseconds: 150,
      ),
      vsync: this,
    );
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Transform(
            transform: Matrix4.translationValues(
              0,
              100 - (100 * _animationController.value),
              0,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    child: LitConstrainedSizedBox(
                      landscapeWidthFactor: 0.55,
                      child: BluredBackgroundContainer(
                        blurRadius: 2.0,
                        child: Container(
                            height: 56.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: LitColors.lightGrey.withOpacity(0.6),
                            ),
                            child: Builder(builder: (context) {
                              final List<Widget> children = [
                                LitBottomNavigationItem(
                                  index: 0,
                                  icon: LitIcons.home,
                                  iconSelected: LitIcons.home_alt,
                                  selected: widget.currentTabIndex == 0,
                                  setSelectedTab: switchTab,
                                  animationController: _animationController,
                                ),
                                LitBottomNavigationItem(
                                  index: 1,
                                  icon: LitIcons.person,
                                  iconSelected: LitIcons.person_solid,
                                  selected: widget.currentTabIndex == 1,
                                  setSelectedTab: switchTab,
                                  animationController: _animationController,
                                ),
                              ];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: children,
                                ),
                              );
                            })),
                      ),
                    ),
                  ),
                ),
              );
              // final Size deviceSize = MediaQuery.of(context).size;
              // const double portraitBarHeight = 76.0;

              // /// The height in landscape mode will be adjusted for vertical padding.
              // final double landscapeBarHeight = _showAlternativeOnLandscape
              //     ? (MediaQuery.of(context).size.height - 42.0)
              //     : portraitBarHeight;
              // final double portraitBarWidth = MediaQuery.of(context).size.width;
              // final double landscapeBarWidth = _showAlternativeOnLandscape
              //     ? 96.0
              //     : (portraitBarWidth * widget.landscapeWidthFactor);
              // final Alignment portraitAlignment = Alignment.bottomCenter;
              // final Alignment landscapeAlignment = _showAlternativeOnLandscape
              //     ? Alignment.centerLeft
              //     : portraitAlignment;
              // return Align(
              //   alignment: alternativeAlignment(
              //     deviceSize,
              //     portraitAlignment: portraitAlignment,
              //     landscapeAlignment: landscapeAlignment,
              //   ),
              //   child: SizedBox(
              //     height: alternativeHeight(
              //       deviceSize,
              //       portraitHeight: portraitBarHeight,
              //       landscapeHeight: landscapeBarHeight,
              //     ),
              //     width: alternativeWidth(
              //       deviceSize,
              //       portraitWidth: portraitBarWidth,
              //       landscapeWidth: landscapeBarWidth,
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(
              //         vertical: isPortraitMode(deviceSize) ? 8.0 : 16.0,
              //         horizontal: 8.0,
              //       ),
              //       child: BluredBackgroundContainer(
              //         blurRadius: 2.0,
              //         child: Container(
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(15.0),
              //               color: LitColors.lightGrey.withOpacity(0.6),
              //             ),
              //             child: Builder(builder: (context) {
              //               final List<Widget> children = [
              //                 LitBottomNavigationItem(
              //                   index: 0,
              //                   icon: LitIcons.home,
              //                   iconSelected: LitIcons.home_alt,
              //                   selected: widget.currentTabIndex == 0,
              //                   setSelectedTab: switchTab,
              //                   animationController: _animationController,
              //                 ),
              //                 LitBottomNavigationItem(
              //                   index: 1,
              //                   icon: LitIcons.person,
              //                   iconSelected: LitIcons.person_solid,
              //                   selected: widget.currentTabIndex == 1,
              //                   setSelectedTab: switchTab,
              //                   animationController: _animationController,
              //                 ),
              //               ];
              //               return (isPortraitMode(deviceSize) ||
              //                       !_showAlternativeOnLandscape)
              //                   ? Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceEvenly,
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.center,
              //                       children: children,
              //                     )
              //                   : Column(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceEvenly,
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.center,
              //                       children: children,
              //                     );
              //             })),
              //       ),
              //     ),
              //   ),
              // );
            }),
          );
        });
  }
}

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:history_of_me/lit_ui_kit_temp/lit_bottom_navigation_item.dart';
// import 'package:history_of_me/lit_ui_kit_temp/lit_orientation_detector.dart';
// import 'package:lit_ui_kit/lit_ui_kit.dart';

// class LitBottomNavigation extends StatefulWidget {
//   final int currentTabIndex;
//   final void Function(int) onPressed;
//   final double landscapeWidthFactor;
//   final bool showAlternativeOnLandscape;
//   const LitBottomNavigation({
//     Key key,
//     @required this.currentTabIndex,
//     @required this.onPressed,
//     this.landscapeWidthFactor = 0.65,
//     this.showAlternativeOnLandscape = true,
//   }) : super(key: key);
//   @override
//   _LitBottomNavigationState createState() => _LitBottomNavigationState();
// }

// class _LitBottomNavigationState extends State<LitBottomNavigation>
//     with TickerProviderStateMixin {
//   AnimationController _animationController;

//   void switchTab(int value) {
//     widget.onPressed(value);
//     if (_animationController.isCompleted) {
//       _animationController.reverse().then(
//             (value) => _animationController.forward(),
//           );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(
//         milliseconds: 150,
//       ),
//       vsync: this,
//     );
//     _animationController.forward(from: 0.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       const double portraitBarHeight = 76.0;
//       final double landscapeBarHeight = widget.showAlternativeOnLandscape
//           ? MediaQuery.of(context).size.height
//           : portraitBarHeight;
//       final double portraitBarWidth = MediaQuery.of(context).size.width;
//       final double landscapeBarWidth = widget.showAlternativeOnLandscape
//           ? 112.0
//           : (MediaQuery.of(context).size.width * widget.landscapeWidthFactor);
//       final Alignment portraitAlignment = Alignment.bottomCenter;
//       final Alignment landscapeAlignment = widget.showAlternativeOnLandscape
//           ? Alignment.centerLeft
//           : portraitAlignment;
//       final Matrix4 portraitTransform = Matrix4.translationValues(
//         0,
//         100 - (100 * _animationController.value),
//         0,
//       );
//       final Matrix4 landscapeTransform = widget.showAlternativeOnLandscape
//           ? Matrix4.translationValues(
//               100 - (100 * _animationController.value),
//               0,
//               0,
//             )
//           : portraitTransform;
//       return AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, _) {
//             return Transform(
//                 transform: portraitTransform,
//                 child: Align(
//                   alignment: alternativeAlignment(constraints,
//                       portraitAlignment: portraitAlignment,
//                       landscapeAlignment: landscapeAlignment),
//                   child: SizedBox(
//                     height: alternativeHeight(
//                       constraints,
//                       portraitHeight: portraitBarHeight,
//                       landscapeHeight: landscapeBarHeight,
//                     ),
//                     width: alternativeWidth(
//                       constraints,
//                       portraitWidth: portraitBarWidth,
//                       landscapeWidth: landscapeBarWidth,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 8.0,
//                         horizontal: 8.0,
//                       ),
//                       child: BluredBackgroundContainer(
//                         blurRadius: 2.0,
//                         child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15.0),
//                               color: LitColors.lightGrey.withOpacity(0.6),
//                             ),
//                             child: Builder(builder: (context) {
//                               final List<Widget> children = [
//                                 LitBottomNavigationItem(
//                                   index: 0,
//                                   icon: LitIcons.home,
//                                   iconSelected: LitIcons.home_alt,
//                                   selected: widget.currentTabIndex == 0,
//                                   setSelectedTab: switchTab,
//                                   animationController: _animationController,
//                                 ),
//                                 LitBottomNavigationItem(
//                                   index: 1,
//                                   icon: LitIcons.person,
//                                   iconSelected: LitIcons.person_solid,
//                                   selected: widget.currentTabIndex == 1,
//                                   setSelectedTab: switchTab,
//                                   animationController: _animationController,
//                                 ),
//                               ];
//                               return isPortraitMode(constraints) ||
//                                       !widget.showAlternativeOnLandscape
//                                   ? Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: children,
//                                     )
//                                   : Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: children,
//                                     );
//                             })),
//                       ),
//                     ),
//                   ),
//                 ));
//           });
//     });
//   }
// }
