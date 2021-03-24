// import 'package:flutter/material.dart';
// import 'package:lit_ui_kit/lit_ui_kit.dart';

// class CreateEntryActionButton extends StatelessWidget {
//   final void Function() onPressCallback;

//   const CreateEntryActionButton({
//     Key key,
//     @required this.onPressCallback,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressCallback,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(colors: [
//                 Colors.pink.withOpacity(0.3),
//                 Colors.purple.withOpacity(0.23),
//               ], stops: [
//                 0.2,
//                 0.7
//               ], begin: Alignment.topLeft, end: Alignment.bottomRight),
//               borderRadius: BorderRadius.circular(18.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.pink.withOpacity(0.45),
//                   blurRadius: 12.0,
//                   offset: Offset(
//                     -2,
//                     -2,
//                   ),
//                   spreadRadius: 1.0,
//                 )
//               ]),
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
//             child: Icon(LitIcons.plus, size: 16.0, color: Colors.white70),
//           ),
//         ),
//       ),
//     );
//   }
// }
