import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/mood_translation_controller.dart';
import 'package:history_of_me/data/constants.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_draggable.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_slider_card.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/view/widgets/shared/animated_updated_label.dart';
import 'package:history_of_me/view/widgets/entry_editing_screen/editable_title_header.dart';
import 'package:history_of_me/view/widgets/shared/confirm_discard_draft_dialog.dart';
import 'package:history_of_me/view/widgets/shared/editable_item_meta_info.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// A screen [Widget] to edit a [DiaryEntry].
///
/// The mutated [DiaryEntry] will kept in state as long as the user has not saved all changes.
/// While the draft has not been saved yet, the user will be promted to save his changes if he
/// decides to navigate back. Once saved, the user will then be able to navigate back without
/// any dialogs being shown.
class EntryEditingScreen extends StatefulWidget {
  /// The [DiaryEntry] that should be edited.
  final DiaryEntry diaryEntry;

  /// Creates a [EntryEditingScreen].
  ///
  /// Pass a [DiaryEntry] which should be edited. This property is required.
  const EntryEditingScreen({
    Key key,
    @required this.diaryEntry,
  }) : super(key: key);
  @override
  _EntryEditingScreenState createState() => _EntryEditingScreenState();
}

class _EntryEditingScreenState extends State<EntryEditingScreen>
    with TickerProviderStateMixin {
  /// The current mood score value the user has set.
  double _moodScore;

  /// The current title text the user is editing.
  String _title;

  /// The current content text the user is editing.
  String _content;

  /// The [FocusNode] to control the focus on the title's [EditableText].
  FocusNode _titleEditFocusNode;

  /// The [FocusNode] to control the focus on the content's [EditableText].
  FocusNode _contentEditFocusNode;

  /// The controller to track the user's input on the title text.
  TextEditingController _titleEditingController;

  /// The controller to track the user's input on the content text.
  TextEditingController _contentEditingController;

  ScrollController _scrollController;
  AnimationController _fadeInAnimationController;

  LitRouteController _routeController;
  //TODO
  /// Current db state and input state will have to be synchronized because the editing
  /// screen may is initialized without a database reference with default values only.
  ///
  /// ===> detect any db changes using the ValueListener

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

  // void _onButtonDragStart() {
  //   _dragAnimationController.reverse();
  // }

  void _onMoodScoreChanged(double value) {
    setState(() {
      _moodScore = value;
      // if (_moodScore != widget.diaryEntry.moodScore) {
      //   _moodScoreChanged = true;
      // } else {
      //   _moodScoreChanged = false;
      // }
    });
  }

  bool _isChanged(DiaryEntry databaseEntry) {
    return (_title != databaseEntry.title ||
        _content != databaseEntry.content ||
        _moodScore != databaseEntry.moodScore);
  }

  // void _resetAllChangedValues() {
  //   setState(() {
  //     _titleChanged = false;
  //     _moodScoreChanged = false;
  //     _contentChanged = false;
  //   });
  // }

  // bool _titleChanged;
  // bool _contentChanged;
  // bool _moodScoreChanged;

  void _onSaveChanges() {
    DiaryEntry updatedDiaryEntry = DiaryEntry(
      uid: widget.diaryEntry.uid,
      date: widget.diaryEntry.date,
      created: widget.diaryEntry.created,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
      title: _titleEditingController.text,
      content: _contentEditingController.text,
      moodScore: _moodScore,
      favorite: widget.diaryEntry.favorite,
      backdropPhotoId: widget.diaryEntry.backdropPhotoId,
    );
    HiveDBService().updateDiaryEntry(updatedDiaryEntry);

    /// Resetting the the 'changed' state values does involve setting the state.
    /// Therefore there will be no need for additional setState calls required to
    /// reload the mutated data from the database.
    //_resetAllChangedValues();
  }

  // /// Action listener to set the changed flag on the content input.
  // void _contentEditingControllerListener() {
  //   if (widget.diaryEntry.title != _contentEditingController.text) {
  //     setState(() {
  //       _contentChanged = true;
  //     });
  //   } else {
  //     setState(() {
  //       _contentChanged = false;
  //     });
  //   }
  // }

  // /// Action listener to set the changed flag on the title input.
  // void _titleEditingControllerListener() {
  //   if (widget.diaryEntry.title != _titleEditingController.text) {
  //     setState(() {
  //       _titleChanged = true;
  //     });
  //   } else {
  //     setState(() {
  //       _titleChanged = false;
  //     });
  //   }
  // }

  void _handleDiscardDraft() {
    showDialog(
      context: context,
      builder: (_) => ConfirmDiscardDraftDialog(
        unsavedChangesDetectedText:
            "There have been changes made to this diary entry.",
        onDiscardCallback: () {
          _routeController.dicardAndExit();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _title = widget.diaryEntry.title;
    _content = widget.diaryEntry.content;

    // _titleChanged = false;
    // _contentChanged = false;
    // _moodScoreChanged = false;

    _moodScore = widget.diaryEntry.moodScore;

    _fadeInAnimationController =
        AnimationController(duration: Duration(milliseconds: 540), vsync: this);

    _titleEditFocusNode = FocusNode();
    _titleEditingController = TextEditingController(
        text: widget.diaryEntry.title != initialDiaryEntryTitle
            ? widget.diaryEntry.title
            : 'Untitled');
    //_titleEditingController.addListener(_titleEditingControllerListener);
    _contentEditFocusNode = FocusNode();
    _contentEditingController =
        TextEditingController(text: widget.diaryEntry.content);
    //_contentEditingController.addListener(_contentEditingControllerListener);
    _scrollController = ScrollController();

    _routeController = LitRouteController(context);
    _syncTextEditingControllerChanges();
    _fadeInAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeInAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("title: ${_titleEditingController.text}");
    return ValueListenableBuilder(
      valueListenable: HiveDBService().getDiaryEntries(),
      builder: (BuildContext context, Box<dynamic> entriesBox, Widget _) {
        final DiaryEntry newDiaryEntry = entriesBox.get(widget.diaryEntry.uid);
        return LitScaffold(
          appBar: FixedOnScrollAppbar(
            scrollController: _scrollController,
            backgroundColor: Colors.white,
            height: 50.0,
            child: EditableItemMetaInfo(
              lastUpdateTimestamp: newDiaryEntry.lastUpdated,
              showUnsavedBadge: _isChanged(newDiaryEntry),
            ),
            shouldNavigateBack: !_isChanged(newDiaryEntry),
            onInvalidNavigation: _handleDiscardDraft,
          ),
          body: SafeArea(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _fadeInAnimationController,
                  builder: (BuildContext context, Widget _) {
                    return Stack(
                      children: [
                        Scrollbar(
                          controller: _scrollController,
                          radius: Radius.circular(8.0),
                          thickness: 8.0,
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
                                          newDiaryEntry.lastUpdated,
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
                                              "Your mood was".toUpperCase(),
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
                                          ),
                                          valueTitleText:
                                              MoodTranslationController(
                                                      moodScore: _moodScore,
                                                      badMoodTranslation: "bad",
                                                      mediumMoodTranslation:
                                                          "alright",
                                                      goodMoodTranslation:
                                                          "good")
                                                  .translatedLabelText,
                                          min: 0.0,
                                          max: 1.0,
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        _isChanged(newDiaryEntry)
                            ? LitDraggable(
                                initialDragOffset: Offset(
                                  MediaQuery.of(context).size.width - 90.0,
                                  MediaQuery.of(context).size.height - 90.0,
                                ),
                                child: LitGradientButton(
                                  accentColor: const Color(0xFFDE8FFA),
                                  color: const Color(0xFFFA72AA),
                                  child: Icon(LitIcons.disk,
                                      size: 28.0, color: Colors.white),
                                  onPressed: _onSaveChanges,
                                ),
                              )
                            : SizedBox(),
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
  final AnimationController fadeInAnimationController;
  final TextEditingController contentEditController;
  final FocusNode contentEditFocusNode;

  const _DiaryContentInput({
    Key key,
    @required this.fadeInAnimationController,
    @required this.contentEditController,
    @required this.contentEditFocusNode,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FadeInTransformContainer(
      animationController: fadeInAnimationController,
      transform: Matrix4.translationValues(
        MediaQuery.of(context).size.width / 3 +
            (-MediaQuery.of(context).size.width /
                3 *
                fadeInAnimationController.value),
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
            controller: contentEditController,
            focusNode: contentEditFocusNode,
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
