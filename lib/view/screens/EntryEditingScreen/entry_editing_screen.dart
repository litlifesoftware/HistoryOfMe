import 'dart:async';

import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/controller/controllers.dart';
import 'package:history_of_me/controller/mood_translation_controller.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

/// A screen [Widget] to edit a [DiaryEntry].
///
/// The mutated [DiaryEntry] will kept in state as long as the user has not
/// saved all changes. While the draft has not been saved yet, the user will be
/// promted to save his changes if he decides to navigate back. Once saved, the
/// user will then be able to navigate back without any dialogs being shown.
class EntryEditingScreen extends StatefulWidget {
  /// The [DiaryEntry] that should be edited.
  final DiaryEntry diaryEntry;

  /// Creates a [EntryEditingScreen].
  ///
  /// Pass a [DiaryEntry] which should be edited. This property is required.
  const EntryEditingScreen({
    Key? key,
    required this.diaryEntry,
  }) : super(key: key);
  @override
  _EntryEditingScreenState createState() => _EntryEditingScreenState();
}

class _EntryEditingScreenState extends State<EntryEditingScreen>
    with TickerProviderStateMixin {
  /// The current mood score value the user has set.
  late double _moodScore;

  /// The current title text the user is editing.
  late String _title;

  /// The current content text the user is editing.
  late String _content;

  /// The [FocusNode] to control the focus on the title's [EditableText].
  final FocusNode _titleEditFocusNode = FocusNode();

  /// The [FocusNode] to control the focus on the content's [EditableText].
  final FocusNode _contentEditFocusNode = FocusNode();

  /// The controller to track the user's input on the title text.
  late TextEditingController _titleEditingController;

  /// The controller to track the user's input on the content text.
  late TextEditingController _contentEditingController;

  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeInAnimationController;
  late LitRouteController _routeController;
  late LitSnackbarController _savedSnackbarContr;
  late AutosaveController _autosaveController;

  /// Syncs the editing controllers' text input with the corresponding state
  /// values to check for any changes made to the inital values.
  ///
  /// This must rather be done on the didChangeDependencies method because the
  /// listeners will be overriden on this very method.
  void _syncTextEditingControllerChanges() {
    _titleEditingController.addListener(() {
      setState(() {
        _title = _titleEditingController.text;
      });
    });
    _contentEditingController.addListener(() {
      setState(() {
        _content = _contentEditingController.text;
      });
    });
  }

  void _onMoodScoreChanged(double value) {
    setState(() {
      _moodScore = value;
    });
  }

  /// Checks whether the user has submitted any unsaved changes.
  bool _isUnsaved(DiaryEntry databaseEntry) {
    bool _titleChanged =
        _title != databaseEntry.title && !(_title == initialDiaryEntryTitle);
    bool _contentChanged = _content != databaseEntry.content;
    bool _moodScoreChanged = _moodScore != databaseEntry.moodScore;
    return (_titleChanged || _contentChanged || _moodScoreChanged);
  }

  Future<void> _saveChanges() async {
    // Verify the title has been modified (does not equal the localized string).
    String title = (_titleEditingController.text !=
            AppLocalizations.of(context).untitledLabel)
        ? _titleEditingController.text
        : "";
    DiaryEntry updatedDiaryEntry = DiaryEntry(
      uid: widget.diaryEntry.uid,
      date: widget.diaryEntry.date,
      created: widget.diaryEntry.created,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
      title: title,
      content: _contentEditingController.text,
      moodScore: _moodScore,
      favorite: widget.diaryEntry.favorite,
      backdropPhotoId: widget.diaryEntry.backdropPhotoId,
    );
    AppAPI().updateDiaryEntry(updatedDiaryEntry);
    if (DEBUG) print('Saved changes on current diary entry');
  }

  /// Handles the `discard` action.
  ///
  /// Shows the discard draft dialog to allow to confirm discarding.
  void _handleDiscardDraft() {
    showDialog(
      context: context,
      builder: (_) => DiscardDraftDialog(
        onDiscard: () {
          _routeController.dicardAndExit();
        },
      ),
    );
  }

  /// Initializes the [_titleEditingController] using diary enty's title or
  /// the localized 'untitled' string, if none title is available.
  ///
  /// The initialization must be done twice during runtime. First on the
  /// initState method using an empty string to avoid null values on the
  /// widget's build procedure and the second time on the didChangeDependencies
  /// method to replace the empty string with the localized value for
  /// 'untitled'.
  void _initTitleEditingController(String fallbackValue) {
    _titleEditingController = TextEditingController(
        text: widget.diaryEntry.title != initialDiaryEntryTitle
            ? widget.diaryEntry.title
            : fallbackValue);
  }

  /// Handles the `pop` action.
  ///
  /// Ensures to show the discard dialog when a draft has been detected.
  Future<bool> handlePopAction(bool isChanged) {
    if (isChanged) {
      _handleDiscardDraft();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  /// Handles the `autosave` event by saving all changes and showing the
  /// corresponding snackbar.
  void _onAutosave() {
    _saveChanges();
    _savedSnackbarContr.showSnackBar();
  }

  @override
  void initState() {
    super.initState();

    _title = widget.diaryEntry.title;
    _content = widget.diaryEntry.content;
    _moodScore = widget.diaryEntry.moodScore;

    _fadeInAnimationController = AnimationController(
      duration: Duration(milliseconds: 450),
      vsync: this,
    );

    // Initialized using empty string.
    _initTitleEditingController("");

    _contentEditingController =
        TextEditingController(text: widget.diaryEntry.content);

    _routeController = LitRouteController(context);

    _fadeInAnimationController.forward();
    // Allow editing the entry at the start.
    _contentEditFocusNode.requestFocus();

    _autosaveController = AutosaveController(_onAutosave);

    _savedSnackbarContr = LitSnackbarController();
  }

  @override
  void didChangeDependencies() {
    // Reinitalized using localized string.
    _initTitleEditingController(AppLocalizations.of(context).untitledLabel);
    _syncTextEditingControllerChanges();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fadeInAnimationController.dispose();
    _contentEditFocusNode.dispose();
    _contentEditingController.dispose();
    _scrollController.dispose();
    _autosaveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QueryDiaryEntryProvider(
      diaryEntryUid: widget.diaryEntry.uid,
      builder: (context, diaryEntry, isFirst, isLast, boxLength) {
        if (diaryEntry == null) {
          return Text("ERROR: Diary Entry not available");
        }

        return WillPopScope(
          onWillPop: () => handlePopAction(
            _isUnsaved(diaryEntry),
          ),
          child: LitScaffold(
            appBar: FixedOnScrollAppbar(
              scrollController: _scrollController,
              backgroundColor: Colors.white,
              shouldNavigateBack: !_isUnsaved(diaryEntry),
              onInvalidNavigation: _handleDiscardDraft,
              child: EditableItemMetaInfo(
                lastUpdateTimestamp: diaryEntry.lastUpdated,
                showUnsavedBadge: _isUnsaved(diaryEntry),
              ),
            ),
            snackbars: [
              LitIconSnackbar(
                snackBarController: _savedSnackbarContr,
                text: AppLocalizations.of(context).entrySavedDescr,
                title: LeitmotifLocalizations.of(context).savedLabel,
                iconData: LitIcons.check,
              )
            ],
            body: SafeArea(
              child: Stack(
                children: [
                  LitScrollbar(
                    scrollController: _scrollController,
                    child: ScrollableColumn(
                      controller: _scrollController,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 16.0),
                            AnimatedUpdatedLabel(
                              lastUpdateTimestamp: diaryEntry.lastUpdated,
                            ),
                            _DiaryTitleTextfield(
                              controller: _titleEditingController,
                              focusNode: _titleEditFocusNode,
                              animationController: _fadeInAnimationController,
                            ),
                            _DiaryContentInput(
                              contentEditController: _contentEditingController,
                              contentEditFocusNode: _contentEditFocusNode,
                              fadeInAnimationController:
                                  _fadeInAnimationController,
                            ),
                          ],
                        ),
                        _MoodSlider(
                          moodScore: _moodScore,
                          onChange: _onMoodScoreChanged,
                        ),
                      ],
                    ),
                  ),
                  PurplePinkSaveButton(
                    disabled: !_isUnsaved(diaryEntry),
                    onSaveChanges: _saveChanges,
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

class _MoodSlider extends StatelessWidget {
  final double moodScore;
  final void Function(double) onChange;
  const _MoodSlider({
    Key? key,
    required this.moodScore,
    required this.onChange,
  }) : super(key: key);

  static const height = 128.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: LitGradientCard(
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            color: Colors.black38,
            offset: Offset(-4.0, 2.0),
            spreadRadius: 1.0,
          )
        ],
        borderRadius: const BorderRadius.all(Radius.zero),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  top: 8.0,
                  left: 8.0,
                  right: 8.0,
                ),
                child: Text(
                  AppLocalizations.of(context).yourMoodLabel.toUpperCase(),
                  style: LitSansSerifStyles.subtitle2,
                ),
              ),
              LitSliderCard(
                padding: const EdgeInsets.symmetric(),
                value: moodScore,
                onChanged: onChange,
                activeTrackColor: Color.lerp(
                  LitColors.lightRed,
                  Color(0xFFbee5be),
                  moodScore,
                )!,
                valueTitleText: MoodTranslationController(
                  moodScore: moodScore,
                  context: context,
                ).uppercaseLabel,
                min: 0.0,
                max: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A text input allowing to edit the diary entry's body text.
class _DiaryContentInput extends StatelessWidget {
  final AnimationController fadeInAnimationController;
  final TextEditingController contentEditController;
  final FocusNode contentEditFocusNode;
  final EdgeInsets padding;
  const _DiaryContentInput({
    Key? key,
    required this.fadeInAnimationController,
    required this.contentEditController,
    required this.contentEditFocusNode,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) : super(key: key);

  /// Calculates a transform matrix based on the device width.
  Matrix4 _calcTransform(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final offset = width / 3;
    final x = offset + (-offset * fadeInAnimationController.value);
    return Matrix4.translationValues(x, 0, 0);
  }

  /// Calculates the minimum height based on the current device height.
  double _calcMinHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - _MoodSlider.height - 64.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeInAnimationController,
      builder: (context, snapshot) {
        return FadeInTransformContainer(
          animationController: fadeInAnimationController,
          transform: _calcTransform(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _calcMinHeight(context),
            ),
            child: Padding(
              padding: padding,
              child: Column(
                children: [
                  CleanTextField(
                    controller: contentEditController,
                    focusNode: contentEditFocusNode,
                    style: LitSansSerifStyles.body2.copyWith(
                      height: 1.65,
                      color: LitColors.grey350,
                    ),
                    minLines: 16,
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

/// A text input allowing to edit the diary entry's title text.
class _DiaryTitleTextfield extends StatelessWidget {
  final AnimationController animationController;
  final TextEditingController controller;
  final FocusNode focusNode;
  final EdgeInsets padding;
  const _DiaryTitleTextfield({
    Key? key,
    required this.animationController,
    required this.controller,
    required this.focusNode,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) : super(key: key);

  /// Returns a transform matrix.
  Matrix4 get _transform {
    final offset = 25;
    final x = offset + -offset * animationController.value;
    return Matrix4.translationValues(x, 0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: Padding(
        padding: padding,
        child: CleanTextField(
          controller: controller,
          focusNode: focusNode,
          style: LitSansSerifStyles.h6,
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return FadeInTransformContainer(
          animationController: animationController,
          transform: _transform,
          child: child ?? SizedBox(),
        );
      },
    );
  }
}
