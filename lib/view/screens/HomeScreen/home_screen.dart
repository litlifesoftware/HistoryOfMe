import 'package:flutter/material.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/model/app_settings.dart';
import 'package:hive/hive.dart';
import 'package:leitmotif/leitmotif.dart';

import '../screens.dart';

/// The app's home screen widget allowing to navigate between multiple tabs.
///
/// Accessing and creating (if required) the [AppSettings] will be handled
/// within the app.
class HomeScreen extends StatefulWidget {
  /// The bookmark animation's [Duration].
  final Duration bookmarkAnimationDuration;

  /// Creates a [HomeScreen].
  ///
  /// * [bookmarkAnimationDuration] will determine the bookmark's animation
  ///   duration on each tab.
  const HomeScreen({
    Key? key,
    this.bookmarkAnimationDuration = const Duration(milliseconds: 5000),
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bookmarkAnimation;

  late HiveDBService _hiveDBService;

  /// Persists the `tabIndex` on the the corresponding [AppSettings] instance.
  void _onTabSwitch(int tabIndex, AppSettings appSettings) {
    _hiveDBService.updateTabIndex(appSettings, tabIndex);
  }

  /// Creates the [AppSettings] instance.
  void _createAppSettings() {
    _hiveDBService.createAppSettings();
  }

  @override
  void initState() {
    super.initState();
    _hiveDBService = HiveDBService();
    _bookmarkAnimation = AnimationController(
      duration: widget.bookmarkAnimationDuration,
      vsync: this,
    );
    _bookmarkAnimation.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bookmarkAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _hiveDBService.getAppSettings(),
      builder: (context, Box<AppSettings> appSettingsBox, _) {
        AppSettings appSettings = AppSettings(
          privacyPolicyAgreed: initialAgreedPrivacy,
          darkMode: initialDarkMode,
          tabIndex: initialTabIndex,
        );
        // Try to retrieve the `AppSettings` instance
        try {
          appSettings = appSettingsBox.getAt(0)!;
          // Ensure to create `AppSettings` instance if it's missing.
        } catch (e) {
          print(e);
          _createAppSettings();
          print('Error while accessing AppSettings object. '
              'Creating backup AppSettings object ...');
        }

        return LitTabView(
          initialTabIndex: appSettings.tabIndex,
          transitionListener: (index) => _onTabSwitch(index, appSettings),
          tabs: [
            LitNavigableTab(
              tabData: LitBottomNavigationTabData(
                index: 0,
                icon: LitIcons.home,
                iconSelected: LitIcons.home_alt,
              ),
              screen: DiaryScreen(
                bookmarkAnimation: _bookmarkAnimation,
              ),
            ),
            LitNavigableTab(
              tabData: LitBottomNavigationTabData(
                index: 1,
                icon: LitIcons.person,
                iconSelected: LitIcons.person_solid,
              ),
              screen: ProfileScreen(
                bookmarkAnimation: _bookmarkAnimation,
              ),
            )
          ],
        );
      },
    );
  }
}
