// import 'package:flutter/foundation.dart';

// /// Controller class to calculate a [RelativeDateTime] based on two comparable [DateTime] objects.
// ///
// /// If the calculated [RelativeDateTime]'s value is negative, the compared [DateTime] is in the
// /// future.
// class RelativeTimeCalculator {
//   final DateTime dateTime;
//   final DateTime other;

//   /// Creates a [RelativeTimeCalculator].
//   ///
//   /// Ensure to provide two comparable [DateTime] objects.
//   RelativeTimeCalculator({
//     @required this.dateTime,
//     @required this.other,
//   });

//   /// The miliseconds per second.
//   static const double msPerSecond = 1000.0;

//   /// The milliseconds per minute.
//   static const double msPerMinute = 60000.0;

//   /// The milliseconds per hour.
//   static const double msPerHour = 3.6e+6;

//   /// The miliseconds per day.
//   static const double msPerDay = 8.64e+7;

//   /// The miliseconds per year.
//   static const double msPerYear = 3.154e+10;

//   /// Returns the calculated [RelativeDateTime].
//   RelativeDateTime get relativeTimeDate {
//     int differenceInMs = dateTime.difference(other).inMilliseconds;

//     int differenceInMsAbs = differenceInMs.abs();
//     //other.difference(dateTime).inMilliseconds;
//     if ((differenceInMsAbs < msPerMinute)) {
//       return RelativeDateTime(
//         value: (differenceInMs / msPerSecond).floor(),
//         unit: LitTimeUnit.second,
//       );
//     }
//     if ((differenceInMsAbs < msPerHour)) {
//       return RelativeDateTime(
//         value: (differenceInMs / msPerMinute).floor(),
//         unit: LitTimeUnit.minute,
//       );
//     }

//     if ((differenceInMsAbs < msPerDay)) {
//       return RelativeDateTime(
//         value: (differenceInMs / msPerHour).floor(),
//         unit: LitTimeUnit.hour,
//       );
//     }

//     if ((differenceInMsAbs < msPerYear)) {
//       return RelativeDateTime(
//         value: (differenceInMs / msPerDay).floor(),
//         unit: LitTimeUnit.day,
//       );
//     }

//     return RelativeDateTime(
//       value: (differenceInMs / msPerYear).floor(),
//       unit: LitTimeUnit.year,
//     );
//   }
// }

// /// A model class to describe a relative date time based on the largest [TimeUnit]
// /// available and its value in the [TimeUnit].
// class RelativeDateTime {
//   final int value;
//   final LitTimeUnit unit;
//   const RelativeDateTime({
//     @required this.value,
//     @required this.unit,
//   });
// }
