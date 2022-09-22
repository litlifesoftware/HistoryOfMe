part of widgets;

class EntryDetailCard extends StatefulWidget {
  final DiaryEntry diaryEntry;
  final int listIndex;
  final int boxLength;
  final bool isFirst;
  final bool isLast;
  final QueryController queryController;

  final void Function(DragEndDetails details, DiaryEntry entry) flipPage;
  final void Function() onEdit;

  /// Creates an [EntryDetailCard].
  const EntryDetailCard({
    Key? key,
    required this.listIndex,
    required this.boxLength,
    required this.diaryEntry,
    required this.onEdit,
    required this.isFirst,
    required this.isLast,
    required this.queryController,
    required this.flipPage,
  }) : super(key: key);

  @override
  _EntryDetailCardState createState() => _EntryDetailCardState();

  static const minHeight = 576.0;

  static const margin = const EdgeInsets.symmetric(
    vertical: 16.0,
    horizontal: 20.0,
  );
}

class _EntryDetailCardState extends State<EntryDetailCard>
    with TickerProviderStateMixin {
  late AnimationController _favoriteButtonAniCon;
  late DateColorScheme _dateColorScheme;
  late AppAPI _api;

  /// Returns the diary's number as a string label.
  /// The value is based on the index in the hive box.
  String get _diaryNumberLabel {
    int number = widget.queryController
            .getIndexChronologicallyByUID(widget.diaryEntry.uid) +
        1;
    return number.toString();
  }

  DateTime get _entryDate => DateTime.parse(widget.diaryEntry.date);

  /// Toggles the 'favorite' state by updating the diary entry.
  void _onToggleFavorite() {
    _favoriteButtonAniCon
        .reverse(from: 1.0)
        .then((value) => _api.toggleDiaryEntryFavorite(widget.diaryEntry))
        .then(
          (value) => _favoriteButtonAniCon.forward(),
        );
  }

  /// Handles the `edit` action.
  void _onEdit() {
    widget.onEdit();
  }

  @override
  void initState() {
    super.initState();

    _api = AppAPI();
    _dateColorScheme = DateColorScheme(_entryDate);
    _favoriteButtonAniCon = AnimationController(
        duration: Duration(
          milliseconds: 120,
        ),
        vsync: this)
      ..forward();
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
          minHeight:
              MediaQuery.of(context).size.height - EntryDetailBackdrop.height,
        ),
        child: Column(
          children: [
            _Header(
              diaryEntry: widget.diaryEntry,
              diaryNumberLabel: _diaryNumberLabel,
              isFirst: widget.isFirst,
              isLast: widget.isLast,
              onToggleFavorite: _onToggleFavorite,
              onEdit: _onEdit,
              dateColorScheme: _dateColorScheme,
              favoriteButtonAnimationController: _favoriteButtonAniCon,
            ),
            _MoodScoreIndicator(
              moodScore: widget.diaryEntry.moodScore,
            ),
            GestureDetector(
              onHorizontalDragEnd: (details) =>
                  widget.flipPage(details, widget.diaryEntry),
              child: _TextPreview(
                diaryEntry: widget.diaryEntry,
                onEdit: _onEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The [EntryDetailCard]'s header element containing meta informations and
/// the action buttons.
class _Header extends StatelessWidget {
  final DiaryEntry diaryEntry;
  final String diaryNumberLabel;
  final DateColorScheme dateColorScheme;
  final bool isFirst;
  final bool isLast;
  final AnimationController favoriteButtonAnimationController;
  final void Function() onToggleFavorite;
  final void Function() onEdit;
  const _Header({
    Key? key,
    required this.diaryEntry,
    required this.dateColorScheme,
    required this.diaryNumberLabel,
    required this.isFirst,
    required this.isLast,
    required this.onToggleFavorite,
    required this.onEdit,
    required this.favoriteButtonAnimationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: LitBoxShadows.md,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            dateColorScheme.colorOfTheSeason,
            dateColorScheme.combinedColor,
            dateColorScheme.colorOfYear,
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EntryDetailCard.margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth / 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .entryLabel
                                    .capitalize(),
                                style: LitSansSerifStyles.subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: LitBadge(
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1.0,
                                      horizontal: 4.0,
                                    ),
                                    child: Text(
                                      diaryNumberLabel,
                                      style:
                                          LitSansSerifStyles.caption.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth / 2,
                          ),
                          child: _EditButton(
                            constraints: constraints,
                            onEdit: onEdit,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    diaryEntry.title != DefaultData.diaryEntryTitle
                        ? diaryEntry.title
                        : AppLocalizations.of(context).untitledLabel,
                    style: LitSansSerifStyles.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 8.0,
                          color: Colors.black26,
                        ),
                      ],
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
                        lastUpdateTimestamp: diaryEntry.lastUpdated,
                        textStyle: LitSansSerifStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _FavoriteButton(
                        onPressed: onToggleFavorite,
                        favorite: diaryEntry.favorite,
                        animationController: favoriteButtonAnimationController,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    isLast
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                              left: 0.0,
                              right: isFirst ? 3.0 : 0,
                            ),
                            child: _MetaDataBadge(
                              title: LeitmotifLocalizations.of(context)
                                  .latestLabel,
                            ),
                          )
                        : SizedBox(),
                    isFirst
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: 4.0,
                              bottom: 4.0,
                              left: isLast ? 3.0 : 0.0,
                              right: 0.0,
                            ),
                            child: _MetaDataBadge(
                              title: AppLocalizations.of(context).firstLabel,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final BoxConstraints constraints;
  final void Function() onEdit;

  const _EditButton({
    Key? key,
    required this.constraints,
    required this.onEdit,
  }) : super(key: key);

  static const iconSize = 14.0;

  static const spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return LitPushedThroughButton(
      onPressed: onEdit,
      accentColor: Colors.white,
      backgroundColor: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LitIcons.pencil,
            size: iconSize,
          ),
          SizedBox(width: spacing),
          ClippedText(
            AppLocalizations.of(context).editLabel.toUpperCase(),
            style: LitSansSerifStyles.button,
          ),
        ],
      ),
    );
  }
}

class _MetaDataBadge extends StatelessWidget {
  final String title;

  const _MetaDataBadge({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitBadge(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 2.0,
      ),
      child: Text(
        title,
        style: LitSansSerifStyles.caption.copyWith(
          fontWeight: bold,
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool favorite;
  final AnimationController animationController;
  final void Function() onPressed;
  const _FavoriteButton({
    Key? key,
    required this.favorite,
    required this.animationController,
    required this.onPressed,
  }) : super(key: key);

  Matrix4 get _transform {
    double x = 0;
    double y = ((favorite ? -8.0 : 8.0) +
        (favorite ? 8.0 : -8.0) * animationController.value);
    double z = 0;
    return Matrix4.translationValues(x, y, z);
  }

  @override
  Widget build(BuildContext context) {
    return CleanInkWell(
      onTap: onPressed,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return AnimatedOpacity(
            duration: animationController.duration!,
            opacity: 0.5 + 0.5 * animationController.value,
            child: Transform(
              transform: _transform,
              child: Icon(
                favorite ? LitIcons.heart_solid : LitIcons.heart,
                size: 26.0,
                color: Color.lerp(
                  favorite ? LitColors.white : LitColors.red600,
                  favorite ? LitColors.red550 : LitColors.white,
                  animationController.value,
                ),
                shadows: favorite
                    ? [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black26,
                          offset: Offset(1.0, 1.0),
                        )
                      ]
                    : [],
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
  final void Function() onEdit;
  const _TextPreview({
    Key? key,
    required this.diaryEntry,
    required this.onEdit,
  }) : super(key: key);

  List<DiaryPhoto> get photos => diaryEntry.photos ?? [];

  int get wordCount => diaryEntry.content.wordCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EntryDetailCard.margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                DateTime.parse(diaryEntry.date)
                    .formatAsLocalizedDateWithWeekday(context),
                style: LitSansSerifStyles.subtitle2,
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
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              diaryEntry.content,
                              style: LitSansSerifStyles.body2.copyWith(
                                height: 1.5,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SelectableText(
                                wordCount.toString() +
                                    " " +
                                    (wordCount == 1
                                        ? AppLocalizations.of(context)
                                            .wordWrittenLabel
                                        : AppLocalizations.of(context)
                                            .wordsWrittenLabel) +
                                    ".",
                                style: LitSansSerifStyles.overline.copyWith(
                                  height: 1.5,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: SelectableText(
                                photos.length.toString() +
                                    " " +
                                    (photos.length == 1
                                        ? AppLocalizations.of(context)
                                            .photoAvailableLabel
                                        : AppLocalizations.of(context)
                                            .photosAvailableLabel) +
                                    ".",
                                style: LitSansSerifStyles.overline.copyWith(
                                  height: 1.5,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        )
                      : _NoContentAvailableCard(
                          onEdit: onEdit,
                        );
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
  final void Function() onEdit;

  const _NoContentAvailableCard({
    Key? key,
    required this.onEdit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: LitDescriptionTextBox(
            title: AppLocalizations.of(context).emptyEntryTitle,
            text: AppLocalizations.of(context).emptyEntryDescr,
          ),
        ),
        LitTitledActionCard(
          child: Text(
            AppLocalizations.of(context).emptyEntryActionDescr,
            style: LitSansSerifStyles.subtitle2,
          ),
          actionButtonData: [
            ActionButtonData(
              title: AppLocalizations.of(context).editLabel,
              onPressed: onEdit,
              accentColor: AppColors.pastelPink,
              backgroundColor: AppColors.pastelPurple,
            )
          ],
        ),
      ],
    );
  }
}

class _MoodScoreIndicator extends StatefulWidget {
  final double moodScore;

  const _MoodScoreIndicator({
    Key? key,
    required this.moodScore,
  }) : super(key: key);

  static const animationDuration = Duration(milliseconds: 4000);

  @override
  __MoodScoreIndicatorState createState() => __MoodScoreIndicatorState();
}

class __MoodScoreIndicatorState extends State<_MoodScoreIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: _MoodScoreIndicator.animationDuration,
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(
                      Colors.red,
                      Colors.green,
                      widget.moodScore,
                    ) ??
                    Colors.grey,
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
              horizontal: 22.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  AppLocalizations.of(context).yourMoodLabel.capitalize(),
                  style: LitTextStyles.sansSerif.copyWith(
                    fontSize: 13.0,
                    letterSpacing: 0.25,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  MoodTranslator(
                    moodScore: widget.moodScore,
                    context: context,
                  ).label.toUpperCase(),
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
    );
  }
}
