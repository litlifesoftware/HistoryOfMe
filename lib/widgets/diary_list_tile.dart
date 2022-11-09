part of widgets;

/// A widget displaying a preview of the provided [DiaryEntry].
///
/// Allows to navigate to the [DiaryEntry]'s detail screen by tapping on the
/// widget.
class DiaryListTile extends StatefulWidget {
  final AnimationController animationController;
  final int listIndex;
  final int listLength;
  final DiaryEntry diaryEntry;
  final bool showDivider;
  final double landscapeWidthFactor;

  /// Creates a [DiaryListTile].
  const DiaryListTile({
    Key? key,
    required this.animationController,
    required this.listIndex,
    required this.listLength,
    required this.showDivider,
    required this.diaryEntry,
    this.landscapeWidthFactor = 0.75,
  }) : super(key: key);

  @override
  _DiaryListTileState createState() => _DiaryListTileState();
}

class _DiaryListTileState extends State<DiaryListTile> {
  late HOMNavigator _screenRouter;
  //late DateColorScheme _colorScheme;
  late ScrollController _titleScrollController = ScrollController();

  DateTime get _date => DateTime.parse(widget.diaryEntry.date);

  double get _deviceWidth => MediaQuery.of(context).size.width;

  double get _intervalBegin => (1 / 50) * widget.listIndex;

  double get _tweenX => _deviceWidth * _intervalBegin;

  Curve get _animationCurve =>
      Interval(_intervalBegin, 1.0, curve: Curves.easeInOut);

  Tween<double> get _animationTween => Tween(begin: 0.0, end: 1.0);

  Animation<double> get _animation => _animationTween.animate(
        CurvedAnimation(
          parent: widget.animationController,
          curve: _animationCurve,
        ),
      );

  Matrix4 get _tweenTransform => Matrix4.translationValues(
        -_tweenX + (_tweenX * _animation.value),
        0,
        0,
      );

  Matrix4 get _staticTransform => Matrix4.translationValues(0, -24, 0);

  void _onTilePressed() {
    _screenRouter.toDiaryEntryDetailScreen(
      listIndex: widget.listIndex,
      diaryEntry: widget.diaryEntry,
    );
  }

  void _onTappedEdit() {
    // Close the bottom sheet.
    Navigator.of(context).pop();
    Future.delayed(LitAnimationDurations.button).then(
      (_) => _screenRouter.toEntryEditingScreen(diaryEntry: widget.diaryEntry),
    );
  }

  void _deleteEntry() {
    LitRouteController(context).clearNavigationStack();
    AppAPI().deleteDiaryEntry(widget.diaryEntry.uid);
  }

  void _onTappedDelete() {
    // Close the bottom sheet.
    Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        onDelete: _deleteEntry,
      ),
    );
  }

  void _onTileLongPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DiaryEntryBottomSheet(
        title: widget.diaryEntry.title != DefaultData.diaryEntryTitle
            ? widget.diaryEntry.title
            : AppLocalizations.of(context).untitledLabel,
        onPressedEdit: _onTappedEdit,
        onPressedDelete: _onTappedDelete,
      ),
    );
  }

  /// Scrolls the entry's title text.
  ///
  /// Ensures the whole title is readible while only allocating one line of
  /// space.
  void _scrollText() async {
    if (_titleScrollController.positions.isEmpty) return;

    double forwardOffset = _titleScrollController.position.maxScrollExtent;
    double reverseOffest = 0;
    Duration duration = const Duration(milliseconds: 8000);
    Curve curve = Curves.ease;

    //if (MediaQuery.of(context).size.width > forwardOffset) return;

    if (_titleScrollController.positions.isNotEmpty) {
      await _titleScrollController.animateTo(
        forwardOffset,
        duration: duration,
        curve: curve,
      );
    }
    if (_titleScrollController.positions.isNotEmpty) {
      await _titleScrollController.animateTo(
        reverseOffest,
        duration: duration,
        curve: curve,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _screenRouter = HOMNavigator(context);
    // _colorScheme = DateColorScheme(DateTime.parse(widget.diaryEntry.date));
    _titleScrollController = ScrollController();
    // Ensure the DateColorScheme is rerendered in case the argument values
    // change.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: _animation,
          child: Transform(transform: _tweenTransform, child: child),
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              Transform(
                transform: _staticTransform,
                child: _DateIndicator(
                  colorScheme:
                      DateColorScheme(DateTime.parse(widget.diaryEntry.date)),
                  context: context,
                  date: _date,
                ),
              ),
              _EntryCard(
                listIndex: widget.listIndex,
                listLength: widget.listLength,
                diaryEntry: widget.diaryEntry,
                landscapeWidthFactor: widget.landscapeWidthFactor,
                colorScheme:
                    DateColorScheme(DateTime.parse(widget.diaryEntry.date)),
                titleScrollController: _titleScrollController,
                onPressed: _onTilePressed,
                onLongPressed: _onTileLongPressed,
              ),
            ],
          ),
          widget.showDivider
              ? Transform(
                  transform: _staticTransform,
                  child: Divider(color: Colors.black26),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class _DateIndicator extends StatelessWidget {
  final DateTime date;
  final DateColorScheme colorScheme;
  final BuildContext context;
  const _DateIndicator({
    Key? key,
    required this.date,
    required this.colorScheme,
    required this.context,
  }) : super(key: key);

  String get _yearLabel {
    return date.formatAsLocalizedYear(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.0,
      height: 120.0,
      decoration: BoxDecoration(
        color: colorScheme.colorOfYear,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          bottomRight: Radius.circular(8.0),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Expanded(
              child: Container(
                width: 36.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      12.0,
                    ),
                  ),
                  color: colorScheme.colorOfTheSeason,
                ),
                child: Transform(
                  transform: Matrix4.translationValues(-2, 0, 0),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Center(
                      child: Text(
                        date.formatAsLocalizedMonth(context),
                        style: LitSansSerifStyles.caption.copyWith(
                          letterSpacing: 0.75,
                          color:
                              colorScheme.colorOfTheSeason.applyColorByContrast(
                            Colors.white,
                            LitColors.grey550,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 18.0,
              child: Center(
                child: Text(
                  _yearLabel,
                  style: LitSansSerifStyles.caption.copyWith(
                    fontSize: 6.0,
                    letterSpacing: 0.75,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatefulWidget {
  final int listIndex;
  final int listLength;
  final DiaryEntry diaryEntry;
  final double landscapeWidthFactor;
  final DateColorScheme colorScheme;
  final ScrollController titleScrollController;
  final void Function() onPressed;
  final void Function() onLongPressed;
  const _EntryCard({
    Key? key,
    required this.listIndex,
    required this.listLength,
    required this.diaryEntry,
    required this.landscapeWidthFactor,
    required this.colorScheme,
    required this.titleScrollController,
    required this.onPressed,
    required this.onLongPressed,
  }) : super(key: key);

  @override
  __EntryCardState createState() => __EntryCardState();
}

class __EntryCardState extends State<_EntryCard> {
  RelativeDateTime get _relativeDateTime {
    return RelativeDateTime(
      dateTime: DateTime.now(),
      other: DateTime.fromMillisecondsSinceEpoch(
        widget.diaryEntry.lastUpdated,
      ),
    );
  }

  /// Creates a [RelativeDateFormat].
  RelativeDateFormat get _relativeDateFormatter {
    return RelativeDateFormat(
      Localizations.localeOf(context),
    );
  }

  /// Returns the entry's formatted date.
  String get _formattedDiaryDate {
    DateTime date = DateTime.parse(widget.diaryEntry.date);
    return date.formatAsLocalizedDate(context);
  }

  /// Returns the entry's last updated string.
  String get _relativeDateUpdated {
    return _relativeDateFormatter.format(_relativeDateTime);
  }

  bool get _isTitleAvailable {
    return widget.diaryEntry.title != DefaultData.diaryEntryTitle;
  }

  String get _title {
    return _isTitleAvailable
        ? widget.diaryEntry.title
        : AppLocalizations.of(context).untitledLabel;
  }

  double get _portraitWidth {
    return MediaQuery.of(context).size.width;
  }

  double get _landscapeWidth {
    return _portraitWidth * widget.landscapeWidthFactor;
  }

  int get _diaryNumber {
    return (widget.listIndex - widget.listLength).abs();
  }

  Matrix4 get _numberTransform {
    return Matrix4.translationValues(-8.0, -8.0, 0);
  }

  Color get _moodColor =>
      Color.lerp(
        Colors.red,
        Colors.green,
        widget.diaryEntry.moodScore,
      ) ??
      Colors.grey;

  List<BoxShadow> get _boxShadow => [
        BoxShadow(
          color: widget.colorScheme.combinedColor.withOpacity(0.5),
          blurRadius: 12.0,
          offset: Offset(2, 4),
          spreadRadius: 2.0,
        )
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: alternativeWidth(
            MediaQuery.of(context).size,
            portraitWidth: _portraitWidth,
            landscapeWidth: _landscapeWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              left: 34.0,
            ),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                LitPushedButton(
                  onPressed: widget.onPressed,
                  onLongPressed: widget.onLongPressed,
                  minScale: 0.94,
                  animateOnStart: false,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: _boxShadow,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScrollableText(
                            _title,
                            controller: widget.titleScrollController,
                            style: LitSansSerifStyles.subtitle1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Container(
                              width: constraints.maxWidth,
                              height: 6.0,
                              decoration: BoxDecoration(
                                color: _moodColor,
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(3.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formattedDiaryDate,
                                style: LitSansSerifStyles.overline,
                              ),
                              Text(
                                _relativeDateUpdated,
                                style: LitSansSerifStyles.overline,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Transform(
                    transform: _numberTransform,
                    child: _EntryNumberBadge(diaryNumber: _diaryNumber),
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

class _EntryNumberBadge extends StatelessWidget {
  final int diaryNumber;
  const _EntryNumberBadge({
    Key? key,
    required this.diaryNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: LitBadge(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 4.0,
        ),
        backgroundColor: LitColors.grey120,
        child: Text(
          '#' + (diaryNumber).toString(),
          textAlign: TextAlign.center,
          style: LitSansSerifStyles.overline.copyWith(
            fontSize: 8.0,
            fontWeight: FontWeight.w600,
            color: LitColors.grey600,
          ),
        ),
      ),
    );
  }
}
