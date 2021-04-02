import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/exclamation_rectangle.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/diary_screen/diary_bookmark_header.dart';
import 'package:history_of_me/view/widgets/diary_screen/greetings_bar.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'diary_list_tile.dart';
import 'diary_filter_header.dart';

class DiaryListView extends StatelessWidget {
  final ScrollController? scrollController;
  final AnimationController? animationController;
  final UserData? userData;
  final List<dynamic> diaryEntriesListSorted;
  final bool? showFavoriteEntriesOnly;
  final void Function() toggleShowFavoritesOnly;
  const DiaryListView({
    Key? key,
    required this.scrollController,
    required this.animationController,
    required this.userData,
    required this.diaryEntriesListSorted,
    required this.showFavoriteEntriesOnly,
    required this.toggleShowFavoritesOnly,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: LitRouteController(context).closeDialog,
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
              ? _NoFavoriteEntries(
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
                                diaryEntry: diaryEntry)
                            : SizedBox()
                        : DiaryListTile(
                            animationController: widget.animationController,
                            listIndex: listIndex,
                            diaryEntry: diaryEntry);
                  },
                );
        },
      ),
    );
  }
}

class _NoFavoriteEntries extends StatelessWidget {
  final AnimationController? animationController;

  const _NoFavoriteEntries({
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
                horizontal: 16.0,
              ),
              child: ScrollableColumn(
                children: [
                  Text(
                    "No Favorites Available",
                    style: LitTextStyles.sansSerif.copyWith(
                      color: HexColor('#8A8A8A'),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: ExclamationRectangle(),
                  ),
                  LitConstrainedSizedBox(
                    landscapeWidthFactor: 0.45,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Text(
                            "Add an entry to your favorites by tapping the heart icon on the read view.",
                            textAlign: TextAlign.center,
                            style: LitTextStyles.sansSerif.copyWith(
                              color: HexColor('#8A8A8A'),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Icon(
                            LitIcons.heart_solid,
                            color: LitColors.lightGrey,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
