// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// /// Compounds a collection of date formats and statement types.
// /// Its values are dependend on the provided [DateTime] object
// /// and the system-provided [Locale] object.
// class DateStatementController {
//   final DateTime dateTime;
//   final Locale local;
//   const DateStatementController(this.dateTime, {@required this.local});

//   String get abbreviatedDate {
//     switch (local.languageCode) {
//       case 'en':
//         if (dateTime.month == 1) {
//           return "Jan ${dateTime.day}";
//         } else if (dateTime.month == 2) {
//           return "Feb ${dateTime.day}";
//         } else if (dateTime.month == 3) {
//           return "Mar ${dateTime.day}";
//         } else if (dateTime.month == 4) {
//           return "Apr ${dateTime.day}";
//         } else if (dateTime.month == 5) {
//           return "May ${dateTime.day}";
//         } else if (dateTime.month == 6) {
//           return "Jun ${dateTime.day}";
//         } else if (dateTime.month == 7) {
//           return "Jul ${dateTime.day}";
//         } else if (dateTime.month == 8) {
//           return "Aug ${dateTime.day}";
//         } else if (dateTime.month == 9) {
//           return "Sep ${dateTime.day}";
//         } else if (dateTime.month == 10) {
//           return "Oct ${dateTime.day}";
//         } else if (dateTime.month == 11) {
//           return "Nov ${dateTime.day}";
//         } else if (dateTime.month == 12) {
//           return "Dec ${dateTime.day}";
//         }
//         break;
//       case 'de':
//         if (dateTime.month == 1) {
//           return "${dateTime.day}. Jan";
//         } else if (dateTime.month == 2) {
//           return "${dateTime.day}. Feb";
//         } else if (dateTime.month == 3) {
//           return "${dateTime.day}. Mar";
//         } else if (dateTime.month == 4) {
//           return "${dateTime.day}. Apr";
//         } else if (dateTime.month == 5) {
//           return "${dateTime.day}. May";
//         } else if (dateTime.month == 6) {
//           return "${dateTime.day}. Jun";
//         } else if (dateTime.month == 7) {
//           return "${dateTime.day}. Jul";
//         } else if (dateTime.month == 8) {
//           return "${dateTime.day}. Aug";
//         } else if (dateTime.month == 9) {
//           return "${dateTime.day}. Sep";
//         } else if (dateTime.month == 10) {
//           return "${dateTime.day}. Oct";
//         } else if (dateTime.month == 11) {
//           return "${dateTime.day}. Nov";
//         } else if (dateTime.month == 12) {
//           return "${dateTime.day}. Dec";
//         }
//         break;
//       default:
//         return "Error";
//     }
//     return "Error";
//   }
// }
