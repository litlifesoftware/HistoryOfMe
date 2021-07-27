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
                      accentTextStyle: LitTextStyles.sansSerif.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        color: HexColor('#999999'),
                      ),
                      textStyle: LitTextStyles.sansSerif.copyWith(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ];
                },
                body: _NestedScrollViewBody(
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

class _NestedScrollViewBody extends StatefulWidget {
  final AnimationController? animationController;
  final List<dynamic> diaryEntriesListSorted;
  final bool? showFavoritesOnly;
  const _NestedScrollViewBody({
    Key? key,
    required this.animationController,
    required this.diaryEntriesListSorted,
    required this.showFavoritesOnly,
  }) : super(key: key);

  @override
  __NestedScrollViewBodyState createState() => __NestedScrollViewBodyState();
}

class __NestedScrollViewBodyState extends State<_NestedScrollViewBody> {
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
              ? _NoFavoriteEntriesCard(
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

class _NoFavoriteEntriesCard extends StatelessWidget {
  final AnimationController? animationController;

  const _NoFavoriteEntriesCard({
    Key? key,
    required this.animationController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, _) {
        return Transform(
          transform: Matrix4.translationValues(
            -30 + (30 * animationController!.value),
            0,
            0,
          ),
          child: FadeTransition(
            opacity: animationController!,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 30.0,
              ),
              child: LitConstrainedSizedBox(
                landscapeWidthFactor: 0.45,
                child: ScrollableColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HOMLocalizations(context).noFavoritesAvailable,
                      textAlign: TextAlign.left,
                      style: LitTextStyles.sansSerifStyles[header6].copyWith(
                        color: HexColor('#8A8A8A'),
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    FeedbackDescriptionText(
                      text: HOMLocalizations(context).noFavoritesAvailableDescr,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
