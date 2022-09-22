part of widgets;

class EntryDetailCard extends StatefulWidget {
  final DiaryEntry diaryEntry;
  final int listIndex;
  final int boxLength;
  final BoxDecoration backgroundDecoration;
  final bool isFirst;
  final bool isLast;
  final QueryController? queryController;
  final void Function(DragEndDetails details, DiaryEntry entry) flipPage;

  final void Function() onEdit;
  const EntryDetailCard({
    Key? key,
    required this.listIndex,
    required this.boxLength,
    required this.diaryEntry,
    required this.onEdit,
    this.backgroundDecoration = const BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [
          0.65,
          1.00,
        ],
        colors: [
          LitColors.white,
          LitColors.grey300,
        ],
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
    ),
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
    horizontal: 22.0,
  );
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
    AppAPI().toggleDiaryEntryFavorite(widget.diaryEntry);
  }

  void _onEdit() {
    widget.onEdit();
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
              boxDecoration: widget.backgroundDecoration,
              diaryEntry: widget.diaryEntry,
              diaryNumberLabel: _diaryNumberLabel,
              isFirst: widget.isFirst,
              isLast: widget.isLast,
              onToggleFavorite: _onToggleFavorite,
              onEdit: _onEdit,
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
  final BoxDecoration boxDecoration;
  final String diaryNumberLabel;
  final bool isFirst;
  final bool isLast;
  final void Function() onToggleFavorite;
  final void Function() onEdit;
  const _Header({
    Key? key,
    required this.diaryEntry,
    required this.boxDecoration,
    required this.diaryNumberLabel,
    required this.isFirst,
    required this.isLast,
    required this.onToggleFavorite,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: boxDecoration,
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
                                  color: LitColors.grey380,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: LitBadge(
                                  backgroundColor: LitColors.grey200,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 1.0,
                                      horizontal: 4.0,
                                    ),
                                    child: Text(
                                      diaryNumberLabel,
                                      style:
                                          LitSansSerifStyles.caption.copyWith(
                                        color: LitColors.white,
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
                      color: LitColors.grey400,
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
                      ),
                      _FavoriteButton(
                        onPressed: onToggleFavorite,
                        favorite: diaryEntry.favorite,
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
                            child: _MetaLabel(
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
                            child: _MetaLabel(
                              title: AppLocalizations.of(context).firstLabel,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
          ),
          _MoodScoreIndicator(
            moodScore: diaryEntry.moodScore,
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

  /// Returns the text boxes' constraints.
  BoxConstraints get _constraints => BoxConstraints(
        maxWidth: (constraints.maxWidth / 2) - 44.0 - spacing - iconSize,
      );
  @override
  Widget build(BuildContext context) {
    //  this.backgroundColor = LitColors.red580,
    //   this.accentColor = LitColors.grey380,

    return LitPushedThroughButton(
      onPressed: onEdit,
      accentColor: LitColors.red580,
      backgroundColor: LitColors.red50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LitIcons.pencil,
            color: Colors.white,
            size: iconSize,
          ),
          SizedBox(width: spacing),
          ConstrainedBox(
            constraints: _constraints,
            child: ClippedText(
              AppLocalizations.of(context).editLabel.toUpperCase(),
              style: LitSansSerifStyles.button.copyWith(
                color: Colors.white,
              ),
            ),
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
      ),
    );
  }
}
