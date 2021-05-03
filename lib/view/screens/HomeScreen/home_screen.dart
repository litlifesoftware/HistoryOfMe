import 'package:flutter/material.dart';
import 'package:history_of_me/view/screens/DiaryScreen/diary_screen.dart';
import 'package:history_of_me/view/screens/ProfileScreen/profile_screen.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// A navigatable screen [Widget].
///
/// Displays the currently user selected tab. The navigation inside the
/// [HomeScreen] will be performed using a [LitBottomNavigation].
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bookmarkAnimation;

  /// All available tab screen [Widget] objects that can be navigated.
  List<Widget> _tabs = [];

  /// All tab data objects providing the meta data for the navigatable tabs.
  final List<LitBottomNavigationTabData> _tabData = [
    LitBottomNavigationTabData(
      index: 0,
      icon: LitIcons.home,
      iconSelected: LitIcons.home_alt,
    ),
    LitBottomNavigationTabData(
      index: 1,
      icon: LitIcons.person,
      iconSelected: LitIcons.person_solid,
    ),
  ];

  /// The currently user selected tab stated as its index value.
  int tabIndex = 0;

  /// Sets the state to change the currently displayed tab.
  void _setTabIndex(int value) {
    setState(() {
      tabIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _bookmarkAnimation = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    );
    _tabs = [
      DiaryScreen(
        bookmarkAnimation: _bookmarkAnimation,
      ),
      ProfileScreen(
        bookmarkAnimation: _bookmarkAnimation,
      ),
    ];
    _bookmarkAnimation.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bookmarkAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              _tabs[tabIndex],
              LitBottomNavigation(
                selectedTabIndex: tabIndex,
                onTabSelect: _setTabIndex,
                tabs: _tabData,
              )
            ],
          );
        },
      ),
    );
  }
}
