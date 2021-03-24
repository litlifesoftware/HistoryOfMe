import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 3)
class AppSettings {
  @HiveField(0)
  final bool privacyPolicyAgreed;
  @HiveField(1)
  final bool darkMode;
  @HiveField(2)
  final int tabIndex;
  const AppSettings({
    @required this.privacyPolicyAgreed,
    @required this.darkMode,
    @required this.tabIndex,
  });
}
