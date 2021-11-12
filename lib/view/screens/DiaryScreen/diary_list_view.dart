import 'package:flutter/material.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';

import 'diary_bookmark_header.dart';
import 'diary_list_tile.dart';
import 'diary_filter_header.dart';
import 'greetings_bar.dart';

class DiaryListView extends StatelessWidget {
  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController bookmarkAnimation;
  final UserData? userData;
  final List<dynamic> diaryEntriesListSorted;
  final bool? showFavoriteEntriesOnly;
  final void Function() toggleShowFavoritesOnly;
  const DiaryListView({
    Key? key,
    required this.scrollController,
    required this.bookmarkAnimation,
    required this.animationController,
    required this.userData,
    required this.diaryEntriesListSorted,
    required this.showFavoriteEntriesOnly,
    required this.toggleShowFavoritesOnly,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CleanInkWell(
      onTap: LitRouteController(context).closeDialog,
      child: LitScrollbar(
        child: Column(
          children: <Widget>[
            GreetingsBar(),
            Expanded(
              child: NestedScrollView(
                //physics: AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    DiaryBookmarkHeader(
                      userData: userData,
                      bookmarkAnimation: bookmarkAnimation,
                    ),
                    DiaryFilterHeader(
                      filteredLength: showFavoriteEntriesOnly!
                          ? diaryEntriesListSorted
                              .where((entry) {
                                return entry.favorite;
                              })
                              .toList()
                              .length
                          : diaryEntriesListSorted.length,
                      showFavoritesOnly: showFavoriteEntriesOnly,
                      toggleShowFavoritesOnly: toggleShowFavoritesOnly,
                      accentTextStyle: LitSansSerifStyles.subtitle2.copyWith(
                        color: LitColors.grey380,
                      ),
                      textStyle: LitSansSerifStyles.subtitle2,
                    ),
                  ];
                },
                body: _DiaryListViewContent(
                  diaryEntriesListSorted: diaryEntriesListSorted,
                  showFavoritesOnly: showFavoriteEntriesOnly,
                  animationController: animationController,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _DiaryListViewContent extends StatefulWidget {
  final AnimationController? animationController;
  final List<dynamic> diaryEntriesListSorted;
  final bool? showFavoritesOnly;
  const _DiaryListViewContent({
    Key? key,
    required this.animationController,
    required this.diaryEntriesListSorted,
    required this.showFavoritesOnly,
  }) : super(key: key);

  @override
  _DiaryListViewContentState createState() => _DiaryListViewContentState();
}

class _DiaryListViewContentState extends State<_DiaryListViewContent> {
  bool get noFavoritesAvailable {
    return widget.diaryEntriesListSorted
        .where((element) => element.favorite)
        .isEmpty;
  }

  bool? get showFavoritesOnly {
    return widget.showFavoritesOnly;
  }

  bool get showInfoMessage {
    return noFavoritesAvailable && showFavoritesOnly!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Builder(
        builder: (context) {
          return showInfoMessage
              ? _NoFavoritesView(
                  animationController: widget.animationController,
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  //itemCount: entriesBox.values.length,
                  itemCount: widget.diaryEntriesListSorted.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(bottom: 96.0),
                  itemBuilder: (BuildContext context, int listIndex) {
                    final DiaryEntry diaryEntry =
                        widget.diaryEntriesListSorted[listIndex];
                    return showFavoritesOnly!
                        ? diaryEntry.favorite
                            ? DiaryListTile(
                                animationController: widget.animationController,
                                listIndex: listIndex,
                                diaryEntry: diaryEntry,
                              )
                            : SizedBox()
                        : DiaryListTile(
                            animationController: widget.animationController,
                            listIndex: listIndex,
                            diaryEntry: diaryEntry,
                          );
                  },
                );
        },
      ),
    );
  }
}

/// A widget displaying a description text stating that no favorite entries
/// have been found.
class _NoFavoritesView extends StatelessWidget {
  final AnimationController? animationController;

  const _NoFavoritesView({
    Key? key,
    required this.animationController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScrollableColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: LitEdgeInsets.card,
          child: LitDescriptionTextBox(
            title: HOMLocalizations(context).noFavoritesAvailable,
            text: HOMLocalizations(context).noFavoritesAvailableDescr,
          ),
        )
      ],
    );
  }
}
