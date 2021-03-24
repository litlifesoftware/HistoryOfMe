import 'package:flutter/material.dart';
import 'package:history_of_me/view/screens/diary_screen.dart';
import 'package:history_of_me/view/screens/profile_screen.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_bottom_navigation.dart';

/// A navigatable screen [Widget].
///
/// Displays the currently user selected tab. The navigation inside the
/// [HomeScreen] will be performed using a [LitBottomNavigation].
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  /// All available tab [Widget] objects that can be navigated.
  final List<Widget> tabs = [
    DiaryScreen(),
    ProfileScreen(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              tabs[tabIndex],
              LitBottomNavigation(
                axis: Axis.vertical,
                currentTabIndex: tabIndex,
                onPressed: _setTabIndex,
              )
            ],
          );
        },
      ),
    );
  }
}
