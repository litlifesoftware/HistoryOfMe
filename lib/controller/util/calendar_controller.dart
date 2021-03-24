// import 'dart:ui';

// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';

// class CalendarController {
//   //DateTime selectedDate;
//   DateTime templateDate;
//   final List<DateTime> derivateDates = [];

//   CalendarController() {
//     init();
//   }

//   void init() {
//     templateDate = DateTime.now();
//     setDerivateDates(templateDate);
//     initializeDateFormatting();
//   }

//   static const List<String> weekdays = [
//     "Monday",
//     "Tuesday",
//     "Wednesday",
//     "Thursday",
//     "Friday",
//     "Saturday",
//     "Sunday",
//   ];

//   List<String> getLocalizedWeekdays(Locale locale) {
//     print(locale.languageCode);
//     DateFormat formatter = DateFormat(DateFormat.WEEKDAY, locale.languageCode);

//     return [
//       DateTime(2020, 8, 24),
//       DateTime(2020, 8, 25),
//       DateTime(2020, 8, 26),
//       DateTime(2020, 8, 27),
//       DateTime(2020, 8, 28),
//       DateTime(2020, 8, 29),
//       DateTime(2020, 8, 30)
//     ].map((day) => formatter.format(day)).toList();
//   }

//   /// Decrease the [templateDate] [DateTime] by one month.
//   void decreaseByMonth() {
//     templateDate = DateTime(templateDate.year, templateDate.month, 0);
//     setDerivateDates(templateDate);
//   }

//   /// Increase the [templateDate] [DateTime] by one month.
//   void increaseByMonth() {
//     templateDate = DateTime(templateDate.year, templateDate.month + 2, 0);
//     setDerivateDates(templateDate);
//   }

//   /// Decrease the [templateDate] [DateTime] by one year.
//   void decreaseByYear() {
//     templateDate = DateTime(templateDate.year - 1, templateDate.month + 1, 0);
//     setDerivateDates(templateDate);
//   }

//   /// Increase the [templateDate] [DateTime] by one year.
//   void increaseByYear() {
//     templateDate = DateTime(templateDate.year + 1, templateDate.month + 1, 0);
//     setDerivateDates(templateDate);
//   }

//   void setDerivateDates(DateTime referencedDate) {
//     derivateDates.clear();
//     final DateTime cleanedDate =
//         DateTime(referencedDate.year, referencedDate.month, 0);
//     int previousDay = 0;

//     /// If the weekday is earlier than
//     /// sunday (7).
//     if (cleanedDate.weekday < 7) {
//       /// Copy the weekday value to the [prevDay] counter.
//       previousDay = cleanedDate.weekday;

//       for (int i = 1; i <= previousDay; i++) {
//         derivateDates
//             .add(cleanedDate.subtract(Duration(days: previousDay - i)));
//       }
//     }
//     for (int i = 0; i < (42 - previousDay); i++) {
//       derivateDates.add(cleanedDate.add(Duration(days: i + 1)));
//     }
//   }
// }
