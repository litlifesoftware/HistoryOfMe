import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/database/hive_query_controller.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/controller/routes/hom_navigator.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/shared/bookmark/bookmark_front_preview.dart';
import 'package:history_of_me/view/shared/purple_pink_button.dart';
import 'package:hive/hive.dart';
import 'package:leitmotif/leitmotif.dart';
import 'diary_list_view.dart';

/// A screen widget displaying the user's diary on a vertical listview.
class DiaryScreen extends StatefulWidget {
  /// The bookmark's [AnimationController]
  final AnimationController bookmarkAnimation;
  final Duration listViewAnimationDuration;

  /// Creates a [DiaryScreen].
  const DiaryScreen({
    Key? key,
    required this.bookmarkAnimation,
    this.listViewAnimationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with TickerProviderStateMixin {
  late HOMNavigator _navigator;
  late AnimationController _listViewAnimation;
  late ScrollController _scrollController;

  /// States whether to show only the favorite entries.
  bool _showFavoriteEntriesOnly = false;

  /// Shows the 'create entry' dialog.
  void _showCreateEntryDialog() {
    _navigator.showCreateEntryDialog();
  }

  /// Toggles the [_showFavoriteEntriesOnly] state value while replaying the
  /// animation controller to animate the list view tiles again.
  void toggleShowFavoritesOnly() {
    setState(() {
      _showFavoriteEntriesOnly = !_showFavoriteEntriesOnly;
    });
  }

  /// Sortes the [DiaryEntry]s inside the provided box and returns the sorted
  /// objects as a list.
  List<DiaryEntry> _getDiaryEntriesSorted(Box entriesBox) {
    return entriesBox.values.toList() as List<DiaryEntry>
      ..sort(
        HiveQueryController().sortEntriesByDateAscending,
      );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _listViewAnimation = AnimationController(
      duration: widget.listViewAnimationDuration,
      vsync: this,
    );
    _navigator = HOMNavigator(context);
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
            label: HOMLocalizations(context).compose.toUpperCase(),
            icon: LitIcons.plus,
            blurred: false,
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
                        userData: userData,
                      )
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
            padding: const EdgeInsets.all(16),
            userData: userData,
            animationController: bookmarkAnimation,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 108.0,
            ),
            child: LitConstrainedSizedBox(
              landscapeWidthFactor: 0.55,
              child: LitGradientCard(
                padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    bottom: isPortraitMode(
                      MediaQuery.of(context).size,
                    )
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
                      HOMLocalizations(context).createEntry,
                      style: LitTextStyles.sansSerifHeader.copyWith(
                        color: HexColor('#8A8A8A'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: ExclamationRectangle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 16.0,
                      ),
                      child: Text(
                        HOMLocalizations(context).createFirstEntryDescr,
                        textAlign: TextAlign.center,
                        style: LitSansSerifStyles.body2,
                      ),
                    ),
                    PurplePinkButton(
                      label: HOMLocalizations(context).createEntry,
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
