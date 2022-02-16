import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controllers.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

/// A `History of Me` `screen` widget showing details and properties of a
/// specific [DiaryEntry] object while providing options to edit or delete
/// the entry.
class EntryDetailScreen extends StatefulWidget {
  /// The entry's index on the chronological list of diary entries.
  final int listIndex;

  /// The entry's uid.
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

  /// Shows the [ChangePhotoDialog].
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
    if (_settingsPanelController.isShown)
      _settingsPanelController.dismissSettingsPanel();
    _screenRouter.toEntryEditingScreen(diaryEntry: diaryEntry);
  }

  /// Delays the [_onEdit] call by the button animation duration to allow the
  /// animation to fully play back before transitioning to the next screen.
  void _onEditDelayed(DiaryEntry diaryEntry) {
    Future.delayed(LitAnimationDurations.button).then(
      (_) => _onEdit(diaryEntry),
    );
  }

  void _onNextPressed(DiaryEntry diaryEntry) {
    Future.delayed(LitAnimationDurations.button).then(
      (_) {
        LitRouteController(context).replaceCurrentCupertinoWidget(
          newWidget: EntryDetailScreen(
            // Decrease the index by one to artificially lower the total
            // entries count and therefore increase the entries number on
            // the label text.
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
            // Increase the index by one to artificially higher the total
            // entries count and therefore lower the entries number on
            // the label text.
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
              height: 180.0,
              controller: _settingsPanelController,
              title: AppLocalizations.of(context).optionsLabel.capitalize(),
              children: [
                LitPushedThroughButton(
                  child: Text(
                    AppLocalizations.of(context).editLabel.toUpperCase(),
                    style: LitSansSerifStyles.button,
                  ),
                  accentColor: LitColors.grey100,
                  onPressed: () => _onEditDelayed(diaryEntry),
                ),
                SizedBox(height: 16.0),
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
                          _Footer(
                            showNextButton: _shouldShowNextButton(diaryEntry),
                            showPreviousButton:
                                _shouldShowPreviousButton(diaryEntry),
                            onPrevious: () => _onPreviousPressed(diaryEntry),
                            onNext: () => _onNextPressed(diaryEntry),
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

/// A `History of Me` widget showing a row of buttons allowing the user to
/// interact with a diary entry.
///
/// It allows to navigate to the previous and next entry and to delete the
/// entry.
class _Footer extends StatelessWidget {
  final bool showNextButton;
  final bool showPreviousButton;
  final void Function() moreOptionsPressed;
  final void Function() onNext;
  final void Function() onPrevious;

  /// Creates a [_Footer].
  const _Footer({
    Key? key,
    required this.moreOptionsPressed,
    required this.onNext,
    required this.onPrevious,
    required this.showNextButton,
    required this.showPreviousButton,
  }) : super(key: key);

  /// Returns the spacing in pixels that should be applied between the
  /// buttons in the row.
  double get _buttonSpacing => showNextButton && showPreviousButton ? 8.0 : 0.0;

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
                    ? _PreviousNavigationButton(onPressed: onPrevious)
                    : SizedBox(),
                SizedBox(width: _buttonSpacing),
                showNextButton
                    ? _NextNavigationButton(onPressed: onNext)
                    : SizedBox(),
              ],
            ),
            LitPushedThroughButton(
              margin: LitEdgeInsets.button * 1.5,
              child: EllipseIcon(
                animated: false,
                dotColor: LitColors.grey380,
              ),
              onPressed: moreOptionsPressed,
              accentColor: Colors.white,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

/// A `History of Me` widget allowing to navigate to the next entry using the
/// [onPressed] callback.
class _NextNavigationButton extends StatelessWidget {
  final void Function() onPressed;

  /// Creates a [_NextNavigationButton].
  const _NextNavigationButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NavigationButton(
      label: LeitmotifLocalizations.of(context).nextLabel.toUpperCase(),
      mode: LitLinearNavigationMode.next,
      onPressed: onPressed,
    );
  }
}

/// A `History of Me` widget allowing to navigate to the previous entry using the
/// [onPressed] callback.
class _PreviousNavigationButton extends StatelessWidget {
  final void Function() onPressed;

  /// Creates a [_PreviousNavigationButton].
  const _PreviousNavigationButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NavigationButton(
      label: LeitmotifLocalizations.of(context).backLabel.toUpperCase(),
      mode: LitLinearNavigationMode.previous,
      onPressed: onPressed,
    );
  }
}

/// A `History of Me` widget displaying a navigation button based on the
/// provided [mode] value.
class _NavigationButton extends StatelessWidget {
  final LitLinearNavigationMode mode;
  final String label;
  final void Function() onPressed;
  const _NavigationButton({
    Key? key,
    required this.label,
    required this.mode,
    required this.onPressed,
  }) : super(key: key);

  static const double _maxWidth = 72.0;

  static const double _spacing = 4.0;

  @override
  Widget build(BuildContext context) {
    return LitPushedThroughButton(
      child: Row(
        children: [
          LinearNavigationIcon(
            mode: mode,
          ),
          const SizedBox(width: _spacing),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _maxWidth,
            ),
            child: ClippedText(
              label,
              style: LitSansSerifStyles.button,
            ),
          ),
          const SizedBox(width: _spacing),
        ],
      ),
      accentColor: LitColors.grey100,
      onPressed: onPressed,
    );
  }
}
