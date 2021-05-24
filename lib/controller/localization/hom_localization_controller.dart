import 'package:flutter/material.dart';
import 'package:lit_localization_service/lit_localization_service.dart';

/// A controller class implementing HistoryOfMe's localization.
///
/// It provides an interface to access the [LitLocalizations] using the local
/// JSON asset and implements the required getter to retrieve all available
/// localized strings.
class HOMLocalizationController {
  final BuildContext context;

  /// Creates a [HOMLocalizationController].
  const HOMLocalizationController(this.context);

  LitLocalizations get _localizations {
    return LitLocalizations.of(context)!;
  }

  String getValue(String key) {
    return _localizations.getLocalizedValue(key);
  }

  String get yourName {
    return _localizations.getLocalizedValue("your_name");
  }

  String get okay {
    return _localizations.getLocalizedValue("okay");
  }

  String get thatsMe {
    return _localizations.getLocalizedValue("thats_me");
  }

  String get whatShallWeCallYou {
    return _localizations.getLocalizedValue("what_shall_we_call_you");
  }

  String get yourDataIsSafe {
    return _localizations.getLocalizedValue("your_data_is_safe");
  }

  String get offlineAppDescription {
    return _localizations.getLocalizedValue("offline_app_description");
  }

  String get confirmYourAge {
    return _localizations.getLocalizedValue("confirm_your_age");
  }

  String get confirmYourAgeSubtitle {
    return _localizations.getLocalizedValue("confirm_your_age_subtitle");
  }

  String get yourAge {
    return _localizations.getLocalizedValue("your_age");
  }

  String get setAge {
    return _localizations.getLocalizedValue("set_age");
  }

  String get submit {
    return _localizations.getLocalizedValue("submit");
  }

  String get invalidAgeText {
    return getValue("invalid_age_text");
  }

  String get valid {
    return getValue("valid");
  }

  String get chooseDate {
    return getValue("choose_date");
  }
}
