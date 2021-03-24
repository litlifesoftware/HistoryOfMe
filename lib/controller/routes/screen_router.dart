import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/screens/bookmark_editing_screen.dart';
import 'package:history_of_me/view/screens/entry_detail_screen.dart';
import 'package:history_of_me/view/screens/entry_editing_screen.dart';

/// A controller class enabling to navigate through screens by its corresponding
/// member method.
///
/// Pass the [BuildContext] in order to manipulate the widget stack.
class ScreenRouter {
  /// The [BuildContext] instance required to initialize the [LitRouteController.]
  final BuildContext context;

  /// Creates a [ScreenRouter].
  ///
  /// Pass on the [BuildContext] instance.
  ScreenRouter(this.context) {
    _routeController = LitRouteController(context);
  }

  /// The [LitRouteController] will handle the navigation logic.
  LitRouteController _routeController;

  /// Navigates the user to the [EntryDetailScreen].
  ///
  /// Provide the arguments that should be passed to the screen widget.
  void toDiaryEntryDetailScreen({
    @required int listIndex,
    @required String diaryEntryUid,
  }) {
    final pushedWidget = EntryDetailScreen(
      listIndex: listIndex,
      diaryEntryUid: diaryEntryUid,
    );
    _routeController.pushMaterialWidget(pushedWidget);
  }

  /// Navigates the user to the [EntryEditingScreen].
  ///
  /// Provide the arguments that should be passed to the screen widget.
  void toEntryEditingScreen({
    @required DiaryEntry diaryEntry,
  }) {
    Widget pushedWidget = EntryEditingScreen(
      diaryEntry: diaryEntry,
    );
    _routeController.pushCupertinoWidget(pushedWidget);
  }

  /// Navigates the user to the [BookmarkEditingScreen].
  ///
  /// Provide the arguments that should be passed to the screen widget.
  void toBookmarkEditingScreen({
    @required UserData userData,
  }) {
    final pushedWidget = BookmarkEditingScreen(
      initialUserDataModel: userData,
    );
    _routeController.pushMaterialWidget(pushedWidget);
  }
}
