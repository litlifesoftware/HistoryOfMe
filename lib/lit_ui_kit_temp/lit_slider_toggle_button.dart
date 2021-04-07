// import 'package:flutter/material.dart';
// import 'package:lit_ui_kit/lit_ui_kit.dart';

// class LitSliderToggleButton extends StatefulWidget {
//   final Widget enabledTitle;
//   final Widget disabledTitle;
//   final void Function() onPressed;
//   final bool? enabled;
//   const LitSliderToggleButton({
//     Key? key,
//     required this.enabledTitle,
//     required this.disabledTitle,
//     required this.onPressed,
//     required this.enabled,
//   }) : super(key: key);
//   @override
//   _LitSliderToggleButtonState createState() => _LitSliderToggleButtonState();
// }

// class _LitSliderToggleButtonState extends State<LitSliderToggleButton>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;

//   void _onPressed() {
//     if (widget.enabled!) {
//       _animationController.reverse(from: 1.0);
//     } else {
//       _animationController.forward();
//     }
//     widget.onPressed();
//     print("toggle button");
//     print("enabled: ${widget.enabled}");
//   }

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 190),
//       vsync: this,
//     );

//     if (widget.enabled!) _animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, _) {
//         return LayoutBuilder(builder: (context, constraints) {
//           return InkWell(
//             onTap: _onPressed,
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(
//                     constraints.maxWidth / 4,
//                   ),
//                   child: Container(
//                       width: constraints.maxWidth,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(
//                           constraints.maxWidth / 4,
//                         ),
//                         color: Colors.black26,
//                       ),
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: constraints.maxWidth / 2,
//                           ),
//                           Transform(
//                             transform: Matrix4.translationValues(
//                                 (-constraints.maxWidth / 2) *
//                                     _animationController.value,
//                                 0,
//                                 0),
//                             child: SizedBox(
//                               width: constraints.maxWidth / 2,
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 4.0,
//                                     horizontal: 4.0,
//                                   ),
//                                   child: AnimatedOpacity(
//                                     duration: _animationController.duration!,
//                                     opacity: _animationController.isAnimating
//                                         ? 0.35 +
//                                             (0.65 * _animationController.value)
//                                         : 1.0,
//                                     child: Transform(
//                                       transform: Matrix4.translationValues(
//                                           0,
//                                           _animationController.isAnimating
//                                               ? -10 +
//                                                   (10 *
//                                                       _animationController
//                                                           .value)
//                                               : 0,
//                                           0),
//                                       child: widget.enabled!
//                                           ? widget.disabledTitle
//                                           : widget.enabledTitle,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 ),
//                 Transform(
//                   transform: Matrix4.translationValues(
//                       (constraints.maxWidth / 2) * _animationController.value,
//                       0,
//                       0),
//                   child: Container(
//                     width: constraints.maxWidth / 2,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(
//                           constraints.maxWidth / 4,
//                         ),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             offset: Offset(2, 2),
//                             color: Colors.black26,
//                             spreadRadius: 2.0,
//                             blurRadius: 6.0,
//                           ),
//                         ]),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 4.0,
//                           horizontal: 4.0,
//                         ),
//                         child: AnimatedOpacity(
//                           duration: _animationController.duration!,
//                           opacity: _animationController.isAnimating
//                               ? 0.35 + (0.65 * _animationController.value)
//                               : 1.0,
//                           child: Transform(
//                             transform: Matrix4.translationValues(
//                                 0,
//                                 _animationController.isAnimating
//                                     ? 10 + (-10 * _animationController.value)
//                                     : 0,
//                                 0),
//                             child: widget.enabled!
//                                 ? widget.enabledTitle
//                                 : widget.disabledTitle,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }
// }
