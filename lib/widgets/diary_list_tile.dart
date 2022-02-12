part of widgets;

class DiaryListTile extends StatefulWidget {
  final AnimationController? animationController;
  final int listIndex;
  final DiaryEntry diaryEntry;
  final double landscapeWidthFactor;
  const DiaryListTile({
    Key? key,
    required this.animationController,
    required this.listIndex,
    required this.diaryEntry,
    this.landscapeWidthFactor = 0.75,
  }) : super(key: key);

  @override
  _DiaryListTileState createState() => _DiaryListTileState();
}

class _DiaryListTileState extends State<DiaryListTile> {
  late HOMNavigator _screenRouter;

  void _onTilePressed() {
    _screenRouter.toDiaryEntryDetailScreen(
      listIndex: widget.listIndex,
      diaryEntryUid: widget.diaryEntry.uid,
    );
  }

  @override
  void initState() {
    super.initState();
    _screenRouter = HOMNavigator(context);
  }

  @override
  Widget build(BuildContext context) {
    /// The [List] of month labels provided by the [CalendarLocalizationService].
    List<String> monthLabels;
    print(widget.diaryEntry.date);
    // monthLabels = CalendarLocalizationService.getLocalizedCalendarMonths(
    //     Localizations.localeOf(context));
    monthLabels = [
      LeitmotifLocalizations.of(context).january,
      LeitmotifLocalizations.of(context).february,
      LeitmotifLocalizations.of(context).march,
      LeitmotifLocalizations.of(context).april,
      LeitmotifLocalizations.of(context).may,
      LeitmotifLocalizations.of(context).june,
      LeitmotifLocalizations.of(context).july,
      LeitmotifLocalizations.of(context).august,
      LeitmotifLocalizations.of(context).september,
      LeitmotifLocalizations.of(context).october,
      LeitmotifLocalizations.of(context).november,
      LeitmotifLocalizations.of(context).december,
    ];
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (context, _) {
        widget.animationController!.forward();

        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / 50) * widget.listIndex, 1.0,
                    curve: Curves.easeInOut)));
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              -(MediaQuery.of(context).size.width *
                      (1 / 50) *
                      widget.listIndex) +
                  ((MediaQuery.of(context).size.width *
                          (1 / 50) *
                          widget.listIndex) *
                      animation.value),
              0,
              0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _EntryDateLabel(
                      boxShadowOffset: Offset(-2, 4),
                      quaterTurns: 3,
                      text: monthLabels[
                          DateTime.parse(widget.diaryEntry.date).month - 1],
                      landscapeWidthFactor: widget.landscapeWidthFactor,
                    ),
                    _EntryCard(
                      listIndex: widget.listIndex,
                      diaryEntry: widget.diaryEntry,
                      landscapeWidthFactor: widget.landscapeWidthFactor,
                      onPressed: _onTilePressed,
                    ),
                    _EntryDateLabel(
                      boxShadowOffset: Offset(4, -2),
                      quaterTurns: 1,
                      text: DateTime.parse(widget.diaryEntry.date)
                          .year
                          .toString(),
                      landscapeWidthFactor: widget.landscapeWidthFactor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EntryDateLabel extends StatefulWidget {
  final int quaterTurns;
  final String text;
  final Offset boxShadowOffset;
  final double landscapeWidthFactor;
  const _EntryDateLabel({
    Key? key,
    required this.quaterTurns,
    required this.text,
    required this.boxShadowOffset,
    required this.landscapeWidthFactor,
  }) : super(key: key);

  @override
  __EntryDateLabelState createState() => __EntryDateLabelState();
}

class __EntryDateLabelState extends State<_EntryDateLabel> {
  Size get _deviceSize {
    return MediaQuery.of(context).size;
  }

  double get portraitWidth {
    return MediaQuery.of(context).size.width * 0.125;
  }

  double get landscapeWidth {
    return portraitWidth * widget.landscapeWidthFactor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: alternativeWidth(
        _deviceSize,
        portraitWidth: portraitWidth,
        landscapeWidth: landscapeWidth,
      ),
      child: RotatedBox(
          quarterTurns: widget.quaterTurns,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: HexColor('efefef'),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15.0,
                    offset: widget.boxShadowOffset,
                    color: Colors.black.withOpacity(0.20),
                    spreadRadius: 2.0,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 12.0,
                ),
                child: Center(
                  child: ClippedText(
                    "${widget.text}",
                    textAlign: TextAlign.center,
                    style: LitTextStyles.sansSerifStyles[caption],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class _EntryCard extends StatefulWidget {
  final int listIndex;
  final DiaryEntry diaryEntry;
  final double landscapeWidthFactor;
  final void Function() onPressed;
  const _EntryCard({
    Key? key,
    required this.listIndex,
    required this.diaryEntry,
    required this.landscapeWidthFactor,
    required this.onPressed,
  }) : super(key: key);

  @override
  __EntryCardState createState() => __EntryCardState();
}

class __EntryCardState extends State<_EntryCard> {
  /// Returns the [RelativeDateTime] of the last diary entry update..
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

  bool get _titleAvailable {
    return widget.diaryEntry.title != DefaultData.diaryEntryTitle;
  }

  String get _title {
    return _titleAvailable
        ? widget.diaryEntry.title
        : AppLocalizations.of(context).untitledLabel;
  }

  double get _portraitWidth {
    return MediaQuery.of(context).size.width * 0.75;
  }

  double get _landscapeWidth {
    return _portraitWidth * widget.landscapeWidthFactor;
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LitPushedButton(
              onPressed: widget.onPressed,
              minScale: 0.94,
              animateOnStart: false,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 4),
                          blurRadius: 12.0,
                          spreadRadius: 1.0,
                          color: Colors.black.withOpacity(0.22),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_title,
                              style: LitTextStyles.sansSerifStyles[body]),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 16.0,
                              top: 4.0,
                            ),
                            child: Container(
                              width:
                                  ((MediaQuery.of(context).size.width - 32.0) *
                                          0.75) -
                                      32.0,
                              height: 2.0,
                              color: HexColor('e0e0e0'),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formattedDiaryDate,
                                style: LitTextStyles.sansSerifStyles[caption]
                                    .copyWith(
                                  color: HexColor('666666'),
                                ),
                              ),
                              Text(
                                _relativeDateUpdated,
                                style: LitTextStyles.sansSerifStyles[caption]
                                    .copyWith(
                                  color: HexColor('666666'),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        8.0,
                      ),
                      child: Container(
                        height: 15.0,
                        width: 15.0,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            LitColors.lightRed,
                            HexColor('bee5be'),
                            widget.diaryEntry.moodScore,
                          ),
                          borderRadius: BorderRadius.circular(
                            5.95,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
