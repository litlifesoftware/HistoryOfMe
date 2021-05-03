import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/database/hive_query_controller.dart';
import 'package:history_of_me/controller/routes/screen_router.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/view/styles/app_text_styles.dart';
import 'package:history_of_me/view/widgets/entry_details_screen/confirm_delete_entry_dialog.dart';
import 'package:history_of_me/view/widgets/entry_details_screen/entry_details_backdrop.dart';
import 'package:history_of_me/view/widgets/entry_details_screen/backdrop_photo_overlay.dart';
import 'package:history_of_me/view/widgets/entry_details_screen/change_photo_dialog.dart';
import 'package:history_of_me/view/widgets/entry_details_screen/entry_details_card.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class EntryDetailScreen extends StatefulWidget {
  //final int index;
  //final DiaryEntry diaryEntry;
  final int listIndex;
  final String? diaryEntryUid;
  final double portraitPhotoHeight;
  final double landscapePhotoHeight;
  const EntryDetailScreen({
    Key? key,
    required this.listIndex,
    required this.diaryEntryUid,
    //@required this.index,
    //@required this.diaryEntry,
    this.portraitPhotoHeight = 2.9,
    this.landscapePhotoHeight = 1.5,
  }) : super(key: key);

  @override
  _EntryDetailScreenState createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen>
    with TickerProviderStateMixin {
  bool? backdropPhotosLoading;
  List<BackdropPhoto> backdropPhotos = [];
  ScrollController? _scrollController;
  late SettingsPanelController _settingsPanelController;
  HiveQueryController? _hiveQueryController;
  late ScreenRouter _screenRouter;

  // final List<String> imageNames = [
  //   "assets/images/niilo-isotalo--BZc9Ee1qo0-unsplash.jpg",
  //   "assets/images/peiwen-yu-Etpd8Le6b8E-unsplash.jpg"
  // ];

  void parseBackdropPhotos(String assetData) {
    final parsed = jsonDecode(assetData).cast<Map<String, dynamic>>();
    parsed.forEach((json) =>
        setState(() => backdropPhotos.add(BackdropPhoto.fromJson(json))));
    print(backdropPhotos.length);
    setState(() {
      backdropPhotosLoading = false;
    });
    // return parsed
    //     .map<void>((json) => backdropPhotos.add(BackdropPhoto.fromJson(json)));
  }

  Future<void> loadPhotosFromJson() async {
    String data =
        await rootBundle.loadString('assets/json/image_collection_data.json');

    return parseBackdropPhotos(data);
  }

  void _showChangePhotoDialog(DiaryEntry diaryEntry) {
    showDialog(
      context: context,
      builder: (_) => ChangePhotoDialog(
        backdropPhotos: backdropPhotos,
        diaryEntry: diaryEntry,
        // imageNames: imageNames,
      ),
    );
  }

  void _showConfirmEntryDeletionCallback() {
    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteEntryDialog(
        //index: widget.index,
        diaryEntryUid: widget.diaryEntryUid,
      ),
    );
  }

  bool _shouldShowNextButton(DiaryEntry diaryEntry) {
    return _hiveQueryController!.nextEntryExistsByUID(diaryEntry.uid);
  }

  bool _shouldShowPreviousButton(DiaryEntry diaryEntry) {
    return _hiveQueryController!.previousEntryExistsByUID(diaryEntry.uid);
  }

  void _onEdit(DiaryEntry diaryEntry) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => EntryEditingScreen(
    //       diaryEntry: diaryEntry,
    //       //index: widget.index,
    //     ),
    //   ),
    // );
    // Widget widget = EntryEditingScreen(
    //   diaryEntry: diaryEntry,
    //   //index: widget.index,
    // );
    // _routeController.pushWidgetToStack(widget);
    _screenRouter.toEntryEditingScreen(diaryEntry: diaryEntry);
  }

  void _onNextPressed(DiaryEntry diaryEntry) {
    LitRouteController(context).replaceCurrentCupertinoWidget(
      newWidget: EntryDetailScreen(
        // Decrease the index by one to artificially lower the total entries count
        // and therefore increase the entries number on the label text.
        listIndex: widget.listIndex,
        diaryEntryUid: _hiveQueryController!.getNextDiaryEntry(diaryEntry).uid,
      ),
    );
  }

  void _onPreviousPressed(DiaryEntry diaryEntry) {
    LitRouteController(context).replaceCurrentCupertinoWidget(
      newWidget: EntryDetailScreen(
        // Increase the index by one to artificially higher the total entries count
        // and therefore lower the entries number on the label text.
        listIndex: widget.listIndex,
        diaryEntryUid:
            _hiveQueryController!.getPreviousDiaryEntry(diaryEntry).uid,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    backdropPhotosLoading = true;
    loadPhotosFromJson();

    _scrollController = ScrollController();
    _settingsPanelController = SettingsPanelController();
    _hiveQueryController = HiveQueryController();
    _screenRouter = ScreenRouter(context);
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(backdropPhotosLoading);
    return LitScaffold(
      wrapInSafeArea: false,
      settingsPanel: SettingsPanel(
        height: 128.0,
        controller: _settingsPanelController,
        title: "Options",
        children: [
          LitPushedThroughButton(
            backgroundColor: LitColors.lightPink,
            child: ClippedText(
              "Delete",
              style: LitTextStyles.sansSerif.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
              ),
            ),
            onPressed: _showConfirmEntryDeletionCallback,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveDBService().getDiaryEntries(),
        builder: (BuildContext context, Box<DiaryEntry> entriesBox, Widget? _) {
          /// Ensure the entry has not been deleted yet (if it's the latest one available).

          final DiaryEntry? diaryEntry = entriesBox.get(widget.diaryEntryUid);

          if (diaryEntry != null) {
            // final List<dynamic> diaryEntriesSorted =
            //     _hiveQueryController.diaryEntriesSorted;

            final int lastIndex = (entriesBox.length - 1);

            final bool _isFirst = entriesBox.getAt(0)!.uid == diaryEntry.uid;
            final bool _isLast =
                entriesBox.getAt(lastIndex)!.uid == diaryEntry.uid;

            // final int _indexChronologically =
            //     _hiveQueryController.getIndexChronologically(diaryEntry);

            // final bool _previousEntryExists = _indexChronologically > 0;
            // final bool _nextEntryExists =
            //     _indexChronologically < (diaryEntriesSorted.length - 1);

            // final String previousEntryUID =
            //     _hiveQueryController.previousEntryExists(diaryEntry)
            //         ? _hiveQueryController
            //             .getPreviousDiaryEntry(_indexChronologically)
            //             .uid
            //         : diaryEntry.uid;

            // final String nextEntryUID =
            //     _hiveQueryController.nextEntryExists(diaryEntry)
            //         ? diaryEntriesSorted[_indexChronologically + 1].uid
            //         : diaryEntry.uid;

            //print("chronological index $_indexChronologically");
            print("current entry uid ${diaryEntry.uid}");
            //print("previous entry uid $previousEntryUID");
            //print("next entry uid $nextEntryUID");

            return LayoutBuilder(builder: (context, constraints) {
              return Container(
                child: Stack(
                  children: [
                    EntryDetailsBackdrop(
                      backdropPhotos: backdropPhotos,
                      loading: backdropPhotosLoading,
                      diaryEntry: diaryEntry,
                      relativeLandscapePhotoHeight: widget.landscapePhotoHeight,
                      relativePortraitPhotoHeight: widget.portraitPhotoHeight,
                    ),
                    ScrollableColumn(
                      controller: _scrollController,
                      verticalCut: 172.0,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height /
                                (constraints.maxHeight > constraints.maxWidth
                                    ? widget.portraitPhotoHeight
                                    : widget.landscapePhotoHeight) -
                            30,
                      ),
                      children: [
                        EntryDetailsCard(
                          relativeLandscapePhotoHeight:
                              widget.landscapePhotoHeight,
                          relativePortraitPhotoHeight:
                              widget.portraitPhotoHeight,
                          //index: widget.index,
                          boxLength: entriesBox.length,
                          listIndex: widget.listIndex,
                          isFirst: _isFirst,
                          isLast: _isLast,
                          diaryEntry: diaryEntry,
                          onEditCallback: () => _onEdit(diaryEntry),
                          queryController: _hiveQueryController,
                        ),
                        _EntryDetailFooter(
                          showNextButton: _shouldShowNextButton(diaryEntry),
                          showPreviousButton:
                              _shouldShowPreviousButton(diaryEntry),
                          onPreviousPressed: () =>
                              _onPreviousPressed(diaryEntry),
                          onNextPressed: () => _onNextPressed(diaryEntry),
                          moreOptionsPressed:
                              _settingsPanelController.showSettingsPanel,
                        ),
                      ],
                    ),
                    BackdropPhotoOverlay(
                      scrollController: _scrollController,
                      showChangePhotoDialogCallback: () =>
                          _showChangePhotoDialog(diaryEntry),
                      backdropPhotos: backdropPhotos,
                      loading: backdropPhotosLoading,
                      diaryEntry: diaryEntry,
                    ),
                  ],
                ),
              );
            });
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class _EntryDetailFooter extends StatelessWidget {
  final void Function() moreOptionsPressed;
  final bool showPreviousButton;
  final bool showNextButton;
  final void Function() onPreviousPressed;
  final void Function() onNextPressed;
  final List<BoxShadow> buttonBoxShadow;
  const _EntryDetailFooter({
    Key? key,
    required this.moreOptionsPressed,
    required this.showPreviousButton,
    required this.showNextButton,
    required this.onPreviousPressed,
    required this.onNextPressed,
    this.buttonBoxShadow = const [
      const BoxShadow(
        blurRadius: 6.0,
        color: Colors.black26,
        offset: Offset(2, 2),
        spreadRadius: -1.0,
      )
    ],
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 72.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LitColors.lightGrey,
            Colors.white,
          ],
          stops: [
            0.00,
            0.87,
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            offset: Offset(0, -2),
            color: Colors.black12,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                showPreviousButton
                    ? Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: LitGradientButton(
                          boxShadow: buttonBoxShadow,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 4.0,
                                ),
                                child: Icon(
                                  LitIcons.chevron_left_solid,
                                  size: 14.0,
                                  color: AppTextStyles
                                      .labeledButtonDarkTextStyle.color,
                                ),
                              ),
                              Text(
                                "Previous".toUpperCase(),
                                style: AppTextStyles.labeledButtonDarkTextStyle,
                              )
                            ],
                          ),
                          accentColor: Colors.grey[200]!,
                          onPressed: onPreviousPressed,
                        ),
                      )
                    : SizedBox(),
                showNextButton
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: LitGradientButton(
                          boxShadow: buttonBoxShadow,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Next".toUpperCase(),
                                style: AppTextStyles.labeledButtonDarkTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4.0,
                                ),
                                child: Icon(
                                  LitIcons.chevron_right_solid,
                                  size: 14.0,
                                  color: AppTextStyles
                                      .labeledButtonDarkTextStyle.color,
                                ),
                              ),
                            ],
                          ),
                          accentColor: Colors.grey[200]!,
                          onPressed: onNextPressed,
                        ),
                      )
                    : SizedBox()
              ],
            ),
            LitGradientButton(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  15.0,
                ),
              ),
              boxShadow: buttonBoxShadow,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              child: EllipsisIcon(
                animated: false,
                dotColor: Colors.white,
              ),
              accentColor: HexColor('#9B9B9B'),
              color: HexColor('#CCCCCC'),
              onPressed: moreOptionsPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class EllipsisIcon extends StatefulWidget {
  final bool animated;
  final Axis axis;
  final double dotHeight;
  final double dotWidth;
  final Color dotColor;
  final List<BoxShadow> boxShadow;

  const EllipsisIcon(
      {Key? key,
      this.animated = true,
      this.axis = Axis.horizontal,
      this.dotHeight = 8.0,
      this.dotWidth = 8.0,
      this.dotColor = LitColors.mediumGrey,
      this.boxShadow = const [
        BoxShadow(
          blurRadius: 3.0,
          color: Colors.black12,
          offset: Offset(
            1.0,
            1.0,
          ),
          spreadRadius: 1.0,
        )
      ]})
      : super(key: key);

  @override
  _EllipsisIconState createState() => _EllipsisIconState();
}

class _EllipsisIconState extends State<EllipsisIcon>
    with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(
        milliseconds: 590,
      ),
      vsync: this,
    );
    if (widget.animated) {
      _animationController!.forward();
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, _) {
        final List<Widget> children = [];
        for (int i = 0; i < 3; i++) {
          children.add(
            _Dot(
              animated: widget.animated,
              axis: widget.axis,
              animationController: _animationController,
              height: widget.dotHeight,
              width: widget.dotWidth,
              color: widget.dotColor,
              boxShadow: widget.boxShadow,
            ),
          );
        }
        return widget.axis == Axis.horizontal
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  final AnimationController? animationController;
  final bool animated;
  final double height;
  final double width;
  final Color color;
  final List<BoxShadow> boxShadow;
  final Axis axis;
  const _Dot({
    Key? key,
    required this.animationController,
    required this.animated,
    required this.height,
    required this.width,
    required this.color,
    required this.boxShadow,
    required this.axis,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: animated
          ? Matrix4.translationValues(
              -8.0 + 8.0 * (animationController!.value),
              0,
              0,
            )
          : Matrix4.translationValues(
              0,
              0,
              0,
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2.0,
          vertical: 1.0,
        ),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: color,
            boxShadow: boxShadow,
          ),
        ),
      ),
    );
  }
}
