// import 'package:flutter/material.dart';
// import 'package:lit_ui_kit/lit_ui_kit.dart';

// class LitCalendarWeekdayLabel extends StatelessWidget {
//   final BoxConstraints constraints;
//   final String label;
//   const LitCalendarWeekdayLabel({
//     Key? key,
//     required this.constraints,
//     required this.label,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: constraints.maxWidth / 7,
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             vertical: 4.0,
//           ),
//           child: Text(
//             label.substring(0, 1),
//             style: LitTextStyles.sansSerif.copyWith(fontSize: 14.0),
//           ),
//         ),
//       ),
//     );
//   }
// }
