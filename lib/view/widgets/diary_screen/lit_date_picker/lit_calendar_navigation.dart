// import 'package:flutter/material.dart';
// import 'package:lit_ui_kit/lit_ui_kit.dart';

// class LitCalendarNavigation extends StatelessWidget {
//   final void Function() decreaseByMonth;
//   final void Function() increaseByMonth;
//   final void Function() onMonthLabelPress;
//   final void Function() onYearLabelPress;
//   final String yearLabel;
//   final String monthLabel;
//   const LitCalendarNavigation({
//     Key? key,
//     required this.decreaseByMonth,
//     required this.increaseByMonth,
//     required this.onMonthLabelPress,
//     required this.onYearLabelPress,
//     required this.yearLabel,
//     required this.monthLabel,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: LayoutBuilder(builder: (context, constraints) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: constraints.maxWidth / 4,
//               //decreaseByMonth
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: LitPushedThroughButton(
//                   onPressed: decreaseByMonth,
//                   child: Icon(
//                     LitIcons.chevron_left_solid,
//                     size: 16.0,
//                     color: LitColors.mediumGrey,
//                   ),
//                   accentColor: HexColor('#919191'),
//                   backgroundColor: HexColor('#eeeeee'),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: constraints.maxWidth / 4,
//               child: LitPlainLabelButton(
//                 fontSize: 18.0,
//                 onPressed: onMonthLabelPress,
//                 label: monthLabel,
//               ),
//             ),
//             SizedBox(
//               width: constraints.maxWidth / 4,
//               child: LitPlainLabelButton(
//                 fontSize: 18.0,
//                 onPressed: onYearLabelPress,
//                 label: yearLabel,
//               ),
//             ),
//             SizedBox(
//               width: constraints.maxWidth / 4,
//               //decreaseByMonth
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: LitPushedThroughButton(
//                   onPressed: increaseByMonth,
//                   child: Icon(
//                     LitIcons.chevron_right_solid,
//                     size: 16.0,
//                     color: LitColors.mediumGrey,
//                   ),
//                   accentColor: HexColor('#919191'),
//                   backgroundColor: HexColor('#eeeeee'),
//                 ),
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
