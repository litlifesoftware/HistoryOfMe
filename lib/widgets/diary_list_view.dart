part of widgets;

class DiaryListView extends StatelessWidget {
  final ScrollController scrollController;
  final AnimationController animationController;
  final AnimationController bookmarkAnimation;
  final UserData userData;
  final List<DiaryEntry> diaryEntriesListSorted;
  final bool showFavoriteEntriesOnly;
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

  int get _favoriteEntriesCount => diaryEntriesListSorted
      .where((entry) {
        return entry.favorite;
      })
      .toList()
      .length;

  int get _filteredLength => showFavoriteEntriesOnly
      ? _favoriteEntriesCount
      : diaryEntriesListSorted.length;

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
                      filteredLength: _filteredLength,
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

class _DiaryListViewContent extends StatelessWidget {
  final AnimationController animationController;
  final List<DiaryEntry> diaryEntriesListSorted;
  final bool showFavoritesOnly;

  const _DiaryListViewContent({
    Key? key,
    required this.animationController,
    required this.diaryEntriesListSorted,
    required this.showFavoritesOnly,
  }) : super(key: key);

  bool get noFavoritesAvailable {
    return diaryEntriesListSorted.where((element) => element.favorite).isEmpty;
  }

  bool get showInfoMessage {
    return noFavoritesAvailable && showFavoritesOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Builder(
        builder: (context) {
          return showInfoMessage
              ? _NoFavoritesView(
                  animationController: animationController,
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: diaryEntriesListSorted.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(bottom: 96.0),
                  itemBuilder: (BuildContext context, int listIndex) {
                    final DiaryEntry diaryEntry =
                        diaryEntriesListSorted[listIndex];
                    return showFavoritesOnly
                        ? diaryEntry.favorite
                            ? DiaryListTile(
                                animationController: animationController,
                                listIndex: listIndex,
                                diaryEntry: diaryEntry,
                              )
                            : SizedBox()
                        : DiaryListTile(
                            animationController: animationController,
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
            title: AppLocalizations.of(context).noFavoritesAvailLabel,
            text: AppLocalizations.of(context).noFavoritesAvailDescr,
          ),
        )
      ],
    );
  }
}
