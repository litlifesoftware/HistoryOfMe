import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/database/hive_query_controller.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/shared/bookmark_front_preview.dart';
import 'package:history_of_me/view/widgets/diary_screen/create_entry_dialog.dart';
import 'package:history_of_me/view/widgets/diary_screen/diary_list_view.dart';
import 'package:history_of_me/view/widgets/shared/purple_pink_button.dart';
import 'package:hive/hive.dart';
import 'package:lit_localization_service/lit_localization_service.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// A screen widget displaying the user's diary.
///
/// The diary will list all available diary entries and interactive widgets to create additional
/// entires.
class DiaryScreen extends StatefulWidget {
  final AnimationController bookmarkAnimation;

  const DiaryScreen({
    Key? key,
    required this.bookmarkAnimation,
  }) : super(key: key);
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with TickerProviderStateMixin {
  late LitRouteController _routeController;
  late AnimationController _listViewAnimation;
  late ScrollController _scrollController;

  /// States whether to show only the favorite entries.
  bool _showFavoriteEntriesOnly = false;

  /// Shows the 'create entry' dialog.
  void _showCreateEntryDialog() {
    _routeController.showDialogWidget(CreateEntryDialog());
  }

  /// Toggles the [_showFavoriteEntriesOnly] state value while replaying the animation controller
  /// to animate the list view tiles again.
  void toggleShowFavoritesOnly() {
    setState(() {
      _showFavoriteEntriesOnly = !_showFavoriteEntriesOnly;
    });
  }

  /// Sortes the [DiaryEntry]s inside the provided box and returns the sorted objects as a list.
  List<DiaryEntry> _getDiaryEntriesSorted(Box entriesBox) {
    return entriesBox.values.toList() as List<DiaryEntry>
      ..sort(HiveQueryController().sortEntriesByDateAscending);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _listViewAnimation =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _routeController = LitRouteController(context);
    super.initState();
  }

  @override
  void dispose() {
    _listViewAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveDBService().getUserData(),
      builder: (BuildContext context, Box<UserData> userDataBox, Widget? _) {
        final UserData? userData = userDataBox.getAt(0);

        return LitScaffold(
          actionButton: CollapseOnScrollActionButton(
            backgroundColor: Color(userData!.primaryColor),
            onPressed: _showCreateEntryDialog,
            scrollController: _scrollController,
            label: LitLocalizations.of(context)!
                .getLocalizedValue('compose')
                .toUpperCase(),
            icon: LitIcons.plus,
          ),
          body: SafeArea(
            child: ValueListenableBuilder(
              valueListenable: HiveDBService().getDiaryEntries(),
              builder: (BuildContext context, Box<DiaryEntry> entriesBox,
                  Widget? _) {
                return entriesBox.isNotEmpty
                    ? DiaryListView(
                        animationController: _listViewAnimation,
                        bookmarkAnimation: widget.bookmarkAnimation,
                        diaryEntriesListSorted:
                            _getDiaryEntriesSorted(entriesBox),
                        scrollController: _scrollController,
                        showFavoriteEntriesOnly: _showFavoriteEntriesOnly,
                        toggleShowFavoritesOnly: toggleShowFavoritesOnly,
                        userData: userData)
                    : _CreateEntryCallToActionCard(
                        bookmarkAnimation: widget.bookmarkAnimation,
                        userData: userData,
                        showCreateEntryDialog: _showCreateEntryDialog,
                      );
              },
            ),
          ),
        );
      },
    );
  }
}

/// A card containing informations how to create the first diary entry.
class _CreateEntryCallToActionCard extends StatelessWidget {
  final AnimationController bookmarkAnimation;
  final UserData? userData;
  final void Function() showCreateEntryDialog;
  const _CreateEntryCallToActionCard({
    Key? key,
    required this.bookmarkAnimation,
    required this.userData,
    required this.showCreateEntryDialog,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: ScrollableColumn(
        mainAxisSize: MainAxisSize.max,
        children: [
          BookmarkFrontPreview(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
            userData: userData,
            animationController: bookmarkAnimation,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: LitConstrainedSizedBox(
              landscapeWidthFactor: 0.55,
              child: LitGradientCard(
                padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    bottom: isPortraitMode(MediaQuery.of(context).size)
                        ? 16.0
                        : 64.0,
                    top: 16.0),
                margin: EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 24.0,
                ),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HexColor('#FFFBF4'),
                  HexColor('#FFFBFB'),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                child: Column(
                  children: [
                    Text(
                      "No Entries Found",
                      style: LitTextStyles.sansSerifHeader.copyWith(
                        color: HexColor('#8A8A8A'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ExclamationRectangle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "There are no entries available. Do you want to create your first entry?",
                        textAlign: TextAlign.center,
                        style: LitTextStyles.sansSerif.copyWith(
                          color: HexColor('#8A8A8A'),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                    PurplePinkButton(
                      label: "create entry",
                      onPressed: showCreateEntryDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
