// import 'package:flutter/material.dart';
// import 'package:history_of_me/model/data/constants.dart';
// import 'package:history_of_me/view/styles/color_styles.dart';

// class DottedDesignController {
//   final Color color;
//   final double dotSize;
//   final int count;
//   const DottedDesignController({
//     @required this.color,
//     @required this.dotSize,
//     @required this.count,
//   });

//   List<Widget> get dots {
//     return List.generate(
//       count,
//       (index) => Padding(
//         padding: EdgeInsets.only(left: dotSize / 4),
//         child: SizedBox(
//           height: dotSize,
//           width: dotSize,
//           child: AspectRatio(
//             aspectRatio: 1,
//             child: Container(
//               decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.circular(
//                     dotSize * 4,
//                   )),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
