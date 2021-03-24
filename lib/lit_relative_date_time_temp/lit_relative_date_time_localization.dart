// import 'package:flutter/cupertino.dart';
// import 'package:history_of_me/lit_relative_date_time_temp/relative_date_time.dart';

// import 'lit_time_unit.dart';

// /// Controller class to localize relative time stamps using the provided [Locale] and
// /// [RelativeDateTime].
// ///
// /// Following languages are supported at the moment:
// /// * English
// /// * German
// /// * Russian
// ///
// /// If the passed [Locale] can not be applied to the supported localized strings, the
// /// English localization will be returned instead.
// class LitRelativeDateTimeFormat {
//   /// The device [Locale] on which the localized string will be based on.
//   final Locale locale;

//   /// The relative date information.
//   final RelativeDateTime relativeDateTime;

//   /// Creates a [LitRelativeDateTimeFormat].
//   ///
//   /// Provide a [RelativeDateTime] and a [Locale] to return a localized description of the [RelativeDateTime]
//   /// in human-readable form using the [localizedString] property.
//   const LitRelativeDateTimeFormat(
//     this.locale,
//     this.relativeDateTime,
//   );

//   /// States whether to localized the corresponding [RelativeDateTime]'s time unit in singular form.
//   bool get _singular {
//     return relativeDateTime.value == 1;
//   }

//   /// States whether the provided date is in the past.
//   bool get _isPast {
//     return relativeDateTime.value >= 0;
//   }

//   /// Stores all localized time units in singular form.
//   static final Map<Locale, List<String>> _localizedTimeUnitsSingular = {
//     Locale('en', ''): ['second', 'minute', 'hour', 'day', 'year'],
//     Locale('de', ''): ['Sekunde', 'Minute', 'Stunde', 'Tag', 'Jahr'],
//     Locale('ru', ''): ['секунду', 'минуту', 'час', 'день', 'год']
//   };

//   /// Stores all localized time units in the plural.
//   static final Map<Locale, List<String>> _localizedTimeUnitsPlural = {
//     Locale('en', ''): ['seconds', 'minutes', 'hours', 'days', 'years'],
//     Locale('de', ''): ['Sekunden', 'Minuten', 'Stunden', 'Tagen', 'Jahren'],
//     Locale('ru', ''): ['секунды', 'минуты', 'часа', 'дня', 'года']
//   };

//   static final Map<Locale, String> _localizedPrepositionsPast = {
//     Locale('en', ''): 'ago',
//     Locale('de', ''): 'vor',
//     Locale('ru', ''): 'назад'
//   };

//   static final Map<Locale, String> _localizedPrepositionsFuture = {
//     Locale('en', ''): 'in',
//     Locale('de', ''): 'in',
//     Locale('ru', ''): 'через'
//   };

//   /// Returns the localized time unit based on the [Locale] parameter value.
//   String _getLocalizedTimeUnit(Locale locale) {
//     List<String> _timeUnitsSingular = _localizedTimeUnitsSingular[locale];
//     List<String> _timeUnitsPlural = _localizedTimeUnitsPlural[locale];

//     switch (relativeDateTime.unit) {
//       case LitTimeUnit.second:
//         return _singular ? _timeUnitsSingular[0] : _timeUnitsPlural[0];

//         break;
//       case LitTimeUnit.minute:
//         return _singular ? _timeUnitsSingular[1] : _timeUnitsPlural[1];

//         break;
//       case LitTimeUnit.hour:
//         return _singular ? _timeUnitsSingular[2] : _timeUnitsPlural[2];

//         break;
//       case LitTimeUnit.day:
//         return _singular ? _timeUnitsSingular[3] : _timeUnitsPlural[3];

//         break;
//       default:
//         return _singular ? _timeUnitsSingular[4] : _timeUnitsPlural[4];

//         break;
//     }
//   }

//   /// Returns a localized [String] describing the [RelativeDateTime] in human-readable
//   /// form.
//   ///
//   /// Providing a [RelativeDateTime] whose time unit is 'second' and its value is 3 might
//   /// return **3 seconds ago** on default.
//   ///
//   /// Following units can be display for the decription
//   /// * Seconds
//   /// * Minutes
//   /// * Hours
//   /// * Years
//   String get localizedString {
//     String _prepositionPast = _localizedPrepositionsPast[locale];
//     String _prepositionFuture = _localizedPrepositionsFuture[locale];

//     // German localization
//     if (locale == Locale('de', '')) {
//       if (_isPast) {
//         return "$_prepositionPast ${relativeDateTime.value} ${_getLocalizedTimeUnit(locale)}";
//       } else {
//         return "$_prepositionFuture ${relativeDateTime.value.abs()} ${_getLocalizedTimeUnit(locale)}";
//       }
//     }

//     // Russian localization
//     if (locale == Locale('ru', '')) {
//       if (_isPast) {
//         return "${relativeDateTime.value} ${_getLocalizedTimeUnit(locale)} $_prepositionPast";
//       } else {
//         return " $_prepositionFuture ${relativeDateTime.value.abs()} ${_getLocalizedTimeUnit(locale)}";
//       }
//     }

//     // Returns the default localization (EN/US)

//     if (_isPast) {
//       return "${relativeDateTime.value} ${_getLocalizedTimeUnit(Locale('en', ''))} $_prepositionPast";
//     } else {
//       return "$_prepositionFuture ${relativeDateTime.value.abs()} ${_getLocalizedTimeUnit(Locale('en', ''))}";
//     }
//   }
// }
