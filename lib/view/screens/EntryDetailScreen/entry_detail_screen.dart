import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/view/shared/art/ellipse_icon.dart';
import 'package:leitmotif/leitmotif.dart';

import 'backdrop_photo_overlay.dart';
import 'change_photo_dialog.dart';
import 'entry_detail_backdrop.dart';
import 'entry_detail_card.dart';

/// A `screen` widget showing details and properties of a single [DiaryEntry]
/// object while providing options to e.g. edit the entry.
class EntryDetailScreen extends StatefulWidget {
  final int listIndex;
  final String? diaryEntryUid;

  /// Creates a [EntryDetailScreen].
  const EntryDetailScreen({
    Key? key,
    required this.listIndex,
    required this.diaryEntryUid,
  }) : super(key: key);

  @override
  _EntryDetailScreenState createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen>
    with TickerProviderStateMixin {
  List<BackdropPhoto> _photoAssets = [];
  late QueryController _queryController;
  ScrollController? _scrollController;
  bool _assetsLoading = false;
  late HOMNavigator _screenRouter;
  late LitSettingsPanelController _settingsPanelController;

  /// Toggles the [_assetsLoading] value.
  void _toggleAssetsLoading() {
    setState(() {
      _assetsLoading = !_assetsLoading;
    });
  }

  /// Adds the provided object to the [_photoAssets] list.
  void _addAsset(dynamic json) {
    setState(() => _photoAssets.add(BackdropPhoto.fromJson(json)));
  }

  /// Decodes the json provided string data.
  void _decode(String assetData) {
    final parsed = jsonDecode(assetData).cast<Map<String, dynamic>>();
    parsed.forEach((json) => _addAsset(json));
    _toggleAssetsLoading();
  }

  /// Loads the json assets from storage into memory.
  Future<void> _loadAssets() async {
    String data = await rootBundle.loadString(App.imageCollectionPath);

    return _decode(data);
  }

  void _showChangePhotoDialog(DiaryEntry diaryEntry) {
    showDialog(
      context: context,
      builder: (_) => ChangePhotoDialog(
        backdropPhotos: _photoAssets,
        diaryEntry: diaryEntry,
        // imageNames: imageNames,
      ),
    );
  }

  void _onDeleteEntry() {
    LitRouteController(context).clearNavigationStack();
    AppAPI().deleteDiaryEntry(widget.diaryEntryUid);
  }

  void _showConfirmDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        onDelete: _onDeleteEntry,
      ),
    );
  }

  bool _shouldShowNextButton(DiaryEntry diaryEntry) {
    return _queryController.nextEntryExistsByUID(diaryEntry.uid);
  }

  bool _shouldShowPreviousButton(DiaryEntry diaryEntry) {
    return _queryController.previousEntryExistsByUID(diaryEntry.uid);
  }

  void _onEdit(DiaryEntry diaryEntry) {
    _screenRouter.toEntryEditingScreen(diaryEntry: diaryEntry);
  }

  void _onNextPressed(DiaryEntry diaryEntry) {
    Future.delayed(LitAnimationDurations.button).then(
      (_) {
        LitRouteController(context).replaceCurrentCupertinoWidget(
          newWidget: EntryDetailScreen(
            // Decrease the index by one to artificially lower the total entries count
            // and therefore increase the entries number on the label text.
            listIndex: widget.listIndex,
            diaryEntryUid: _queryController.getNextDiaryEntry(diaryEntry).uid,
          ),
        );
      },
    );
  }

  void _onPreviousPressed(DiaryEntry diaryEntry) {
    Future.delayed(LitAnimationDurations.button).then(
      (_) {
        LitRouteController(context).replaceCurrentCupertinoWidget(
          newWidget: EntryDetailScreen(
            // Increase the index by one to artificially higher the total entries count
            // and therefore lower the entries number on the label text.
            listIndex: widget.listIndex,
            diaryEntryUid:
                _queryController.getPreviousDiaryEntry(diaryEntry).uid,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _toggleAssetsLoading();
    _loadAssets();

    _scrollController = ScrollController();
    _settingsPanelController = LitSettingsPanelController();
    _queryController = QueryController();
    _screenRouter = HOMNavigator(context);
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QueryDiaryEntryProvider(
      diaryEntryUid: widget.diaryEntryUid!,
      builder: (context, diaryEntry, isFirst, isLast, boxLength) {
        /// Verify the entry has not been deleted yet.
        if (diaryEntry != null) {
          return LitScaffold(
            appBar: FixedOnScrollTitledAppbar(
              scrollController: _scrollController,
              title: diaryEntry.title != ""
                  ? diaryEntry.title
                  : AppLocalizations.of(context).untitledLabel,
            ),
            settingsPanel: LitSettingsPanel(
              height: 128.0,
              controller: _settingsPanelController,
              title: AppLocalizations.of(context).optionsLabel,
              children: [
                LitDeleteButton(
                  onPressed: _showConfirmDeleteDialog,
                ),
              ],
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              return Container(
                child: Stack(
                  children: [
                    EntryDetailBackdrop(
                      backdropPhotos: _photoAssets,
                      loading: _assetsLoading,
                      diaryEntry: diaryEntry,
                    ),
                    LitScrollbar(
                      child: ScrollableColumn(
                        controller: _scrollController,
                        children: [
                          BackdropPhotoOverlay(
                            scrollController: _scrollController,
                            showChangePhotoDialogCallback: () =>
                                _showChangePhotoDialog(diaryEntry),
                            backdropPhotos: _photoAssets,
                            loading: _assetsLoading,
                            diaryEntry: diaryEntry,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          EntryDetailCard(
                            boxLength: boxLength,
                            listIndex: widget.listIndex,
                            isFirst: isFirst,
                            isLast: isLast,
                            diaryEntry: diaryEntry,
                            onEdit: () => _onEdit(diaryEntry),
                            queryController: _queryController,
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
                    ),
                  ],
                ),
              );
            }),
          );
        }
        return SizedBox();
      },
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
                    ? _BottomNavButton(
                        isPrevious: true,
                        onPressed: onPreviousPressed,
                      )
                    : SizedBox(),
                showNextButton
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                        ),
                        child: _BottomNavButton(
                          isPrevious: false,
                          onPressed: onNextPressed,
                        ))
                    : SizedBox()
              ],
            ),
            LitPushedThroughButton(
              boxShadow: buttonBoxShadow,

              margin: LitEdgeInsets.button * 1.5,
              child: EllipseIcon(
                animated: false,
                dotColor: Colors.white,
              ),
              accentColor: LitColors.grey200,
              //baackgroundColor: HexColor('#CCCCCC'),
              backgroundColor: LitColors.grey100,
              onPressed: moreOptionsPressed,
            ),
          ],
        ),
      ),
    );
  }
}

/// A button enabling to navigate between all available diary entries.
class _BottomNavButton extends StatelessWidget {
  final bool isPrevious;
  final void Function() onPressed;

  const _BottomNavButton({
    Key? key,
    required this.isPrevious,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8.0,
      ),
      child: LitPushedThroughButton(
        child: Row(
          children: [
            isPrevious
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: 4.0,
                    ),
                    child: LinearNavigationIcon(
                      mode: LitLinearNavigationMode.previous,
                    ),
                  )
                : SizedBox(),
            Text(
              isPrevious
                  ? AppLocalizations.of(context).previousLabel.toUpperCase()
                  : AppLocalizations.of(context).nextLabel.toUpperCase(),
              style: LitSansSerifStyles.button,
            ),
            !isPrevious
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                    ),
                    child: LinearNavigationIcon(
                      mode: LitLinearNavigationMode.next,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        accentColor: Colors.grey[200]!,
        onPressed: onPressed,
      ),
    );
  }
}
