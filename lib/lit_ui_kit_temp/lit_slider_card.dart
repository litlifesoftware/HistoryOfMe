// import 'package:flutter/material.dart';
// import 'package:lit_ui_kit/lit_ui_kit.dart';

// import 'lit_slider.dart';

// class LitSliderCard extends StatefulWidget {
//   final double? value;
//   final void Function(double) onChanged;
//   final EdgeInsets padding;
//   final EdgeInsets margin;
//   final bool showValueLabel;
//   final String valueTitleText;
//   final Color? activeTrackColor;
//   final double min;
//   final double max;
//   final BoxDecoration cardDecoration;
//   final Color badgeBackgroundColor;
//   final Color badgeTextColor;
//   final bool displayRangeBadges;
//   final bool displayValue;
//   const LitSliderCard({
//     Key? key,
//     required this.value,
//     required this.onChanged,
//     this.padding = const EdgeInsets.all(
//       16.0,
//     ),
//     this.margin = const EdgeInsets.symmetric(
//       vertical: 8.0,
//       horizontal: 4.0,
//     ),
//     this.showValueLabel = true,
//     this.valueTitleText = "",
//     this.activeTrackColor = LitColors.mediumGrey,
//     required this.min,
//     required this.max,
//     this.cardDecoration = const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(
//             30.0,
//           ),
//         ),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 8.0,
//             color: Colors.black26,
//             offset: Offset(-4, 3),
//             spreadRadius: -2.0,
//           ),
//         ]),
//     this.badgeBackgroundColor = Colors.black38,
//     this.badgeTextColor = Colors.white,
//     this.displayRangeBadges = false,
//     this.displayValue = false,
//   }) : super(key: key);

//   @override
//   _LitSliderCardState createState() => _LitSliderCardState();
// }

// class _LitSliderCardState extends State<LitSliderCard>
//     with TickerProviderStateMixin {
//   AnimationController? _animationController;
//   bool _delayInProgress = false;
//   void _onChanged(double changedValue) {
//     widget.onChanged(changedValue);

//     if (widget.showValueLabel) _animate();
//   }

//   void _animate() {
//     if (!_animationController!.isAnimating) {
//       _animationController!.forward().then(
//         (_) {
//           if (!_delayInProgress) {
//             print("not in progress");
//             _delayInProgress = !_delayInProgress;
//             return Future.delayed(
//               Duration(
//                 milliseconds: 2700,
//               ),
//             ).then(
//               (__) {
//                 setState(
//                   () => _delayInProgress = !_delayInProgress,
//                 );
//                 return _animationController!.reverse(from: 1.0);
//               },
//             );
//           }
//         },
//       );
//     } else {
//       _animationController!.animateTo(1.0, duration: Duration(milliseconds: 0));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     if (widget.showValueLabel) {
//       _animationController = AnimationController(
//         duration: Duration(
//           milliseconds: 240,
//         ),
//         vsync: this,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     if (widget.showValueLabel) _animationController!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: widget.padding,
//       child: Stack(
//         children: [
//           _ValueLabel(
//             animationController: _animationController,
//             badgeBackgroundColor: widget.badgeBackgroundColor,
//             badgeTextColor: widget.badgeTextColor,
//             valueTitle: widget.valueTitleText,
//             value: widget.value,
//           ),
//           Container(
//             decoration: widget.cardDecoration,
//             child: Padding(
//               padding: widget.margin,
//               child: LitSlider(
//                 displayRangeBadges: widget.displayRangeBadges,
//                 displayValue: widget.displayValue,
//                 activeTrackColor: widget.activeTrackColor,
//                 max: widget.max,
//                 min: widget.min,
//                 onChanged: _onChanged,
//                 value: widget.value,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class _ValueLabel extends StatelessWidget {
//   final AnimationController? animationController;
//   final String valueTitle;
//   final double? value;
//   final Color badgeTextColor;
//   final Color badgeBackgroundColor;
//   const _ValueLabel({
//     Key? key,
//     required this.animationController,
//     required this.valueTitle,
//     required this.value,
//     required this.badgeTextColor,
//     required this.badgeBackgroundColor,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animationController!,
//       builder: (context, _) {
//         return Align(
//           alignment: Alignment.topRight,
//           child: AnimatedOpacity(
//             duration: animationController!.duration!,
//             opacity: animationController!.value,
//             child: Transform(
//               transform: Matrix4.translationValues(
//                 -16.0,
//                 animationController!.value * -32.0,
//                 0.0,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: badgeBackgroundColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16.0),
//                     topRight: Radius.circular(16.0),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 4.0,
//                     bottom: 8.0,
//                     left: 16.0,
//                     right: 16.0,
//                   ),
//                   child: Text(
//                     valueTitle != ""
//                         ? valueTitle
//                         : "${value!.toStringAsFixed(2)}",
//                     textAlign: TextAlign.right,
//                     style: LitTextStyles.sansSerif.copyWith(
//                       fontSize: 13.5,
//                       letterSpacing: 0.19,
//                       fontWeight: FontWeight.w600,
//                       height: 1.8,
//                       color: badgeTextColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
