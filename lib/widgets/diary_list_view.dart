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
      child: Column(
        children: <Widget>[
          //GreetingsBar(),
          Expanded(
            child: NestedScrollView(
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
                    scrollController: scrollController,
                    animationController: animationController,
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

  List<DiaryEntry> get favoriteEntries =>
      diaryEntriesListSorted.where((element) => element.favorite).toList();

  bool get noFavoritesAvailable {
    return favoriteEntries.isEmpty;
  }

  bool get showFavoritesInfoMessage {
    return noFavoritesAvailable && showFavoritesOnly;
  }

  DiaryEntry getDiaryEntryByIndex(int index) => showFavoritesOnly
      ? favoriteEntries[index]
      : diaryEntriesListSorted[index];

  @override
  Widget build(BuildContext context) {
    return LitScrollbar(
      child: Container(
        child: Builder(
          builder: (context) {
            if (showFavoritesInfoMessage)
              return _NoFavoritesView(
                animationController: animationController,
              );

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: showFavoritesOnly
                  ? favoriteEntries.length
                  : diaryEntriesListSorted.length,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(
                bottom: 128.0,
                top: 36.0,
              ),
              itemBuilder: (BuildContext context, int index) => DiaryListTile(
                animationController: animationController,
                listIndex: index,
                listLength: showFavoritesOnly
                    ? favoriteEntries.length
                    : diaryEntriesListSorted.length,
                diaryEntry: getDiaryEntryByIndex(index),
                showDivider: showFavoritesOnly
                    ? (index != favoriteEntries.length - 1)
                    : (index != diaryEntriesListSorted.length - 1),
              ),
            );
          },
        ),
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
