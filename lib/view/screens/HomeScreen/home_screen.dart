import 'package:flutter/material.dart';
import 'package:leitmotif/leitmotif.dart';

import '../screens.dart';

/// A navigatable screen [Widget].
///
/// Displays the currently user selected tab. The navigation inside the
/// [HomeScreen] will be performed using a [LitBottomNavigation].
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

  @override
  void initState() {
    super.initState();
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
    return LitTabView(
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
  }
}
