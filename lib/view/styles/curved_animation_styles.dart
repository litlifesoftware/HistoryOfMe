// import 'package:flutter/animation.dart';
// import 'package:flutter/foundation.dart';

// class AvailableCurvedAnimations {
//   final AnimationController animationController;

//   AvailableCurvedAnimations({@required this.animationController});

//   Animation<double> _baseCurved(
//       {@required double begin, @required double end, @required Curve curve}) {
//     return CurvedAnimation(
//       parent: animationController,
//       curve: Interval(
//         begin,
//         end,
//         curve: curve,
//       ),
//     );
//   }

//   Animation<double> fastOutSlowIn(
//       {@required double begin, @required double end}) {
//     return _baseCurved(begin: begin, end: end, curve: Curves.fastOutSlowIn);
//   }
// }
