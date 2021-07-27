import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/controller/mood_translation_controller.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/view/shared/animated_updated_label.dart';
import 'package:history_of_me/view/shared/editable_item_meta_info.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:hive/hive.dart';
import 'package:leitmotif/leitmotif.dart';

import 'editable_title_header.dart';

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

  bool _isChanged(DiaryEntry databaseEntry) {
    bool _titleChanged =
        _title != databaseEntry.title && !(_title == initialDiaryEntryTitle);
    bool _contentChanged = _content != databaseEntry.content;
    bool _moodScoreChanged = _moodScore != databaseEntry.moodScore;
    return (_titleChanged || _contentChanged || _moodScoreChanged);
  }

  void _saveChanges() {
    // Verify the title has been modified (does not equal the localized string).
    String title =
        (_titleEditingController.text != HOMLocalizations(context).untitled)
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
    HiveDBService().updateDiaryEntry(updatedDiaryEntry);
  }

  void _handleDiscardDraft() {
    showDialog(
      context: context,
      builder: (_) => DiscardDraftDialog(
        titleText: HOMLocalizations(context).unsaved,
        infoDescription: HOMLocalizations(context).unsavedEntryDescr,
        discardText: HOMLocalizations(context).discardChanges,
        cancelButtonLabel: HOMLocalizations(context).cancel,
        discardButtonLabel: HOMLocalizations(context).discard,
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

  @override
  void initState() {
    super.initState();

    _title = widget.diaryEntry.title;
    _content = widget.diaryEntry.content;
    _moodScore = widget.diaryEntry.moodScore;

    _fadeInAnimationController = AnimationController(
      duration: Duration(milliseconds: 540),
      vsync: this,
    );

    // Initialized using empty string.
    _initTitleEditingController("");
    //_titleEditingController.addListener(_titleEditingControllerListener);

    _contentEditingController =
        TextEditingController(text: widget.diaryEntry.content);
    //_contentEditingController.addListener(_contentEditingControllerListener);

    _routeController = LitRouteController(context);
    //_syncTextEditingControllerChanges();
    _fadeInAnimationController.forward();
  }

  @override
  void didChangeDependencies() {
    // Reinitalized using localized string.
    _initTitleEditingController(HOMLocalizations(context).untitled);
    _syncTextEditingControllerChanges();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fadeInAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveDBService().getDiaryEntries(),
      builder: (BuildContext context, Box<DiaryEntry> entriesBox, Widget? _) {
        final DiaryEntry dbDiaryEntry = entriesBox.get(widget.diaryEntry.uid)!;
        return LitScaffold(
          appBar: FixedOnScrollAppbar(
            scrollController: _scrollController,
            backgroundColor: Colors.white,
            height: 50.0,
            title:
                _isChanged(dbDiaryEntry) ? "${dbDiaryEntry.lastUpdated}" : "",
            // child: EditableItemMetaInfo(
            //   lastUpdateTimestamp: dbDiaryEntry.lastUpdated,
            //   showUnsavedBadge: _isChanged(dbDiaryEntry),
            // ),
            shouldNavigateBack: !_isChanged(dbDiaryEntry),
            onInvalidNavigation: _handleDiscardDraft,
          ),
          body: SafeArea(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _fadeInAnimationController,
                  builder: (BuildContext context, Widget? _) {
                    return Stack(
                      children: [
                        LitScrollbar(
                          scrollController: _scrollController,
                          child: ScrollableColumn(
                            controller: _scrollController,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FadeInTransformContainer(
                                animationController: _fadeInAnimationController,
                                transform: Matrix4.translationValues(
                                    0,
                                    -50 +
                                        (50 * _fadeInAnimationController.value),
                                    0),
                                child: Column(
                                  children: [
                                    AnimatedUpdatedLabel(
                                      padding: const EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top: 16.0,
                                        bottom: 4.0,
                                      ),
                                      lastUpdateTimestamp:
                                          dbDiaryEntry.lastUpdated,
                                    ),
                                    EditableTitleHeader(
                                      textEditingController:
                                          _titleEditingController,
                                      focusNode: _titleEditFocusNode,
                                    ),
                                  ],
                                ),
                              ),
                              _DiaryContentInput(
                                contentEditController:
                                    _contentEditingController,
                                contentEditFocusNode: _contentEditFocusNode,
                                fadeInAnimationController:
                                    _fadeInAnimationController,
                              ),
                              LitGradientCard(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 8.0,
                                      color: Colors.black38,
                                      offset: Offset(-4.0, 2.0),
                                      spreadRadius: 1.0,
                                    )
                                  ],
                                  borderRadius:
                                      const BorderRadius.all(Radius.zero),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24.0,
                                      top: 8.0,
                                      //   vertical: 8.0,
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8.0,
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              HOMLocalizations(context)
                                                  .yourMoodWas
                                                  .toUpperCase(),
                                              style: LitTextStyles.sansSerif
                                                  .copyWith(
                                                letterSpacing: 0.59,
                                                fontWeight: FontWeight.w700,
                                                height: 1.8,
                                                color: LitColors.mediumGrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                        LitSliderCard(
                                          padding: const EdgeInsets.symmetric(),
                                          value: _moodScore,
                                          onChanged: _onMoodScoreChanged,
                                          activeTrackColor: Color.lerp(
                                            LitColors.lightRed,
                                            HexColor('bee5be'),
                                            _moodScore,
                                          )!,
                                          valueTitleText:
                                              MoodTranslationController(
                                            moodScore: _moodScore,
                                            context: context,
                                          ).translatedLabelText,
                                          min: 0.0,
                                          max: 1.0,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        PurplePinkSaveButton(
                          disabled: !_isChanged(dbDiaryEntry),
                          onSaveChanges: _saveChanges,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DiaryContentInput extends StatelessWidget {
  final AnimationController? fadeInAnimationController;
  final TextEditingController? contentEditController;
  final FocusNode? contentEditFocusNode;

  const _DiaryContentInput({
    Key? key,
    required this.fadeInAnimationController,
    required this.contentEditController,
    required this.contentEditFocusNode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeInTransformContainer(
      animationController: fadeInAnimationController,
      transform: Matrix4.translationValues(
        MediaQuery.of(context).size.width / 3 +
            (-MediaQuery.of(context).size.width /
                3 *
                fadeInAnimationController!.value),
        0,
        0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 164.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 25.0,
          ),
          child: EditableText(
            controller: contentEditController!,
            focusNode: contentEditFocusNode!,
            style: LitTextStyles.sansSerif.copyWith(
              fontSize: 15.5,
              letterSpacing: 0.19,
              fontWeight: FontWeight.w600,
              height: 1.8,
              color: HexColor('#939393'),
            ),
            cursorColor: HexColor('#b7b7b7'),
            backgroundCursorColor: Colors.black,
            selectionColor: HexColor('#b7b7b7'),
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
