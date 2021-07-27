import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/database/hive_query_controller.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/controller/mood_translation_controller.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:history_of_me/view/shared/updated_label_text.dart';
import 'package:leitmotif/leitmotif.dart';

class EntryDetailCard extends StatefulWidget {
  final int listIndex;
  final int boxLength;
  final DiaryEntry diaryEntry;
  final void Function() onEditCallback;
  final double backdropPhotoHeight;
  final BoxDecoration backgroundDecoration;
  final bool isFirst;
  final bool isLast;
  final HiveQueryController? queryController;
  final double minHeight;
  const EntryDetailCard({
    Key? key,
    required this.listIndex,
    required this.boxLength,
    required this.diaryEntry,
    required this.onEditCallback,
    required this.backdropPhotoHeight,
    this.backgroundDecoration = const BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [
          0.65,
          1.00,
        ],
        colors: [
          Color(0xFFf4f4f7),
          Color(0xFFd1cdcd),
        ],
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(22.0),
        topRight: Radius.circular(22.0),
      ),
    ),
    required this.isFirst,
    required this.isLast,
    required this.queryController,
    this.minHeight = 574.0,
  }) : super(key: key);

  @override
  _EntryDetailCardState createState() => _EntryDetailCardState();
}

class _EntryDetailCardState extends State<EntryDetailCard> {
  /// Returns the diary's number as a string label.
  /// The value is based on the index in the hive box.
  String get _diaryNumberLabel {
    int number = widget.queryController!
            .getIndexChronologicallyByUID(widget.diaryEntry.uid) +
        1;
    return "$number";
  }

  /// Toggles the 'favorite' state by updating the diary entry.
  void _onToggleFavorite() {
    HiveDBService().toggleDiaryEntryFavorite(widget.diaryEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30),
          topRight: const Radius.circular(30),
        ),
        color: Colors.white,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minHeight,
        ),
        child: Column(
          children: [
            _Header(
              boxDecoration: widget.backgroundDecoration,
              diaryEntry: widget.diaryEntry,
              diaryNumberLabel: _diaryNumberLabel,
              isFirst: widget.isFirst,
              isLast: widget.isLast,
              onToggleFavorite: _onToggleFavorite,
              onEditCallback: widget.onEditCallback,
            ),
            _TextPreview(
              diaryEntry: widget.diaryEntry,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  final DiaryEntry diaryEntry;
  final BoxDecoration boxDecoration;
  final String diaryNumberLabel;
  final bool isFirst;
  final bool isLast;
  final void Function() onToggleFavorite;
  final void Function() onEditCallback;
  const _Header({
    Key? key,
    required this.diaryEntry,
    required this.boxDecoration,
    required this.diaryNumberLabel,
    required this.isFirst,
    required this.isLast,
    required this.onToggleFavorite,
    required this.onEditCallback,
  }) : super(key: key);

  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  /// Returns the diary entry's title if available or return a fallback string
  String get _title {
    return widget.diaryEntry.title != initialDiaryEntryTitle
        ? widget.diaryEntry.title
        : HOMLocalizations(context).untitled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: widget.boxDecoration,
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  bottom: 4.0,
                  left: 24.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              HOMLocalizations(context).entry,
                              style:
                                  LitTextStyles.sansSerifStyles[body].copyWith(
                                fontSize: 16.5,
                                letterSpacing: -0.22,
                                fontWeight: FontWeight.w600,
                                color: HexColor('#b2b2b2'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor(
                                    "#b2b2b2",
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    15.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Text(
                                    //"${widget.index + 1}",
                                    widget.diaryNumberLabel,
                                    style: LitTextStyles.sansSerifStyles[body]
                                        .copyWith(
                                      fontWeight: black,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        LitGlowingButton(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14.0)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 18.0,
                          ),
                          onPressed: widget.onEditCallback,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 4.0,
                                ),
                                child: Text(
                                  HOMLocalizations(context).edit.toUpperCase(),
                                  style: LitTextStyles.sansSerifStyles[button]
                                      .copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                LitIcons.pencil,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        _title,
                        style: LitTextStyles.sansSerifStyles[body2].copyWith(
                          letterSpacing: -0.52,
                          fontWeight: FontWeight.w700,
                          color: LitColors.darkGrey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UpdatedLabelText(
                            lastUpdateTimestamp: widget.diaryEntry.lastUpdated,
                          ),
                          _FavoriteButton(
                            onPressed: widget.onToggleFavorite,
                            favorite: widget.diaryEntry.favorite,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        widget.isLast
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 4.0,
                                  left: 0.0,
                                  right: widget.isFirst ? 3.0 : 0,
                                ),
                                child: _MetaLabel(
                                  title: HOMLocalizations(context).latest,
                                ),
                              )
                            : SizedBox(),
                        widget.isFirst
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 4.0,
                                  left: widget.isLast ? 3.0 : 0.0,
                                  right: 0.0,
                                ),
                                child: _MetaLabel(
                                  title: HOMLocalizations(context).first,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
              _MoodScoreIndicator(
                moodScore: widget.diaryEntry.moodScore,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaLabel extends StatelessWidget {
  final String title;

  const _MetaLabel({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitBadge(
      backgroundColor: LitColors.beigeGrey,
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 2.0,
      ),
      child: Text(
        title,
        style: LitTextStyles.sansSerifStyles[caption].copyWith(
          fontWeight: bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final void Function() onPressed;
  final bool? favorite;
  const _FavoriteButton({
    Key? key,
    required this.onPressed,
    required this.favorite,
  }) : super(key: key);

  @override
  __FavoriteButtonState createState() => __FavoriteButtonState();
}

class __FavoriteButtonState extends State<_FavoriteButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  Matrix4 get _transform {
    double x = 0;
    double y = ((widget.favorite! ? -8.0 : 8.0) +
        (widget.favorite! ? 8.0 : -8.0) * _animationController.value);
    double z = 0;
    return Matrix4.translationValues(x, y, z);
  }

  void _onTap() {
    _animationController
        .reverse(from: 1.0)
        .then((value) => widget.onPressed())
        .then(
          (value) => _animationController.forward(),
        );
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(
          milliseconds: 120,
        ),
        vsync: this);
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CleanInkWell(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return AnimatedOpacity(
            duration: _animationController.duration!,
            opacity: 0.5 + 0.5 * _animationController.value,
            child: Transform(
              transform: _transform,
              child: Icon(
                widget.favorite! ? LitIcons.heart_solid : LitIcons.heart,
                size: 26.0,
                color: HexColor(
                  "#b2b2b2",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TextPreview extends StatelessWidget {
  final DiaryEntry diaryEntry;

  const _TextPreview({Key? key, required this.diaryEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                DateTime.parse(diaryEntry.date)
                    .formatAsLocalizedDateWithWeekday(context),
                style: LitTextStyles.sansSerif.copyWith(
                  fontSize: 15.4,
                  letterSpacing: 0.15,
                  fontWeight: FontWeight.w600,
                  color: HexColor('#c6c6c6'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 16.0,
              ),
              child: Builder(
                builder: (context) {
                  return diaryEntry.content.isNotEmpty
                      ? Text(
                          diaryEntry.content,
                          style: LitTextStyles.sansSerif.copyWith(
                            fontSize: 15.5,
                            letterSpacing: -0.09,
                            fontWeight: FontWeight.w600,
                            height: 1.7,
                            color: HexColor('#939393'),
                          ),
                        )
                      : _NoContentAvailableCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A fallback card displayed if no content is available.
class _NoContentAvailableCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HOMLocalizations(context).entryIsEmpty,
          textAlign: TextAlign.left,
          style: LitTextStyles.sansSerifStyles[body].copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            height: 1.7,
            color: HexColor('#939393'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: FeedbackDescriptionText(
            text: HOMLocalizations(context).entryIsEmptyDescr,
          ),
        )
      ],
    );
  }
}

class _MoodScoreIndicator extends StatefulWidget {
  final double? moodScore;

  const _MoodScoreIndicator({
    Key? key,
    required this.moodScore,
  }) : super(key: key);

  @override
  __MoodScoreIndicatorState createState() => __MoodScoreIndicatorState();
}

class __MoodScoreIndicatorState extends State<_MoodScoreIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  String get _moodTranslationString {
    return MoodTranslationController(
      moodScore: widget.moodScore,
      context: context,
    ).translatedLabelText.toUpperCase();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    LitColors.lightRed,
                    HexColor('bee5be'),
                    widget.moodScore!,
                  )!,
                  Color.lerp(
                    Colors.white,
                    Colors.grey,
                    _animationController.value,
                  )!,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    HOMLocalizations(context).yourMoodWas,
                    style: LitTextStyles.sansSerif.copyWith(
                      fontSize: 13.0,
                      letterSpacing: 0.25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "$_moodTranslationString",
                    style: LitTextStyles.sansSerif.copyWith(
                      fontSize: 12.0,
                      letterSpacing: 0.65,
                      fontWeight: FontWeight.w700,
                      color: Color.lerp(
                        Colors.grey,
                        Colors.white,
                        _animationController.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
