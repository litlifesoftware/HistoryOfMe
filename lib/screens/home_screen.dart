import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/screens.dart';
import 'package:history_of_me/widgets.dart';

import 'package:leitmotif/leitmotif.dart';

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

  late AppAPI _api;

  /// Persists the `tabIndex` on the the corresponding [AppSettings] instance.
  void _onTabSwitch(int tabIndex, AppSettings appSettings) {
    _api.updateTabIndex(appSettings, tabIndex);
  }

  @override
  void initState() {
    super.initState();
    _api = AppAPI();
    _bookmarkAnimation = AnimationController(
      duration: widget.bookmarkAnimationDuration,
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bookmarkAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsProvider(
      api: _api,
      validator: DatabaseStateValidator(api: _api),
      builder: (BuildContext context, AppSettings appSettings) {
        return LitTabView(
          materialAppBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context).greetingLabel,
              textAlign: TextAlign.center,
              style: LitSansSerifStyles.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          materialDrawer: HomeScreenDrawer(appSettings: appSettings),
          initialTabIndex: appSettings.tabIndex,
          transitionListener: (index) => _onTabSwitch(index, appSettings),
          tabs: [
            LitNavigableTab(
              tabData: LitBottomNavigationItemData(
                index: 0,
                icon: LitIcons.home_alt,
                iconAlt: LitIcons.home,
                title: AppLocalizations.of(context).homeLabel,
              ),
              screen: DiaryScreen(
                bookmarkAnimation: _bookmarkAnimation,
                appSettings: appSettings,
              ),
            ),
            LitNavigableTab(
              tabData: LitBottomNavigationItemData(
                index: 1,
                icon: LitIcons.person,
                iconAlt: LitIcons.person_solid,
                title: AppLocalizations.of(context).profileLabel,
              ),
              screen: ProfileScreen(
                bookmarkAnimation: _bookmarkAnimation,
              ),
            ),
          ],
        );
      },
    );
  }
}
