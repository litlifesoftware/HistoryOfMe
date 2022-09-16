part of widgets;

class DiaryFilterHeader extends StatefulWidget {
  final int filteredLength;
  final TextStyle textStyle;
  final TextStyle accentTextStyle;
  final bool showFavoritesOnly;
  final void Function() toggleShowFavoritesOnly;
  final double landscapeWidthFactor;
  final ScrollController scrollController;
  final AnimationController animationController;
  const DiaryFilterHeader({
    Key? key,
    required this.filteredLength,
    required this.textStyle,
    required this.accentTextStyle,
    required this.showFavoritesOnly,
    required this.toggleShowFavoritesOnly,
    this.landscapeWidthFactor = 0.75,
    required this.scrollController,
    required this.animationController,
  }) : super(key: key);

  @override
  _DiaryFilterHeaderState createState() => _DiaryFilterHeaderState();
}

class _DiaryFilterHeaderState extends State<DiaryFilterHeader>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationOnScrollController _animationOnScrollController;

  double get portraitWidth => MediaQuery.of(context).size.width * 0.75;

  double get landscapeWidth => portraitWidth * widget.landscapeWidthFactor;

  double get _offsetThreshold => 84.0;

  /// Returns the amount of filted entires in human-readable format.
  String get _entriesLabel {
    final bool isPlural =
        (widget.filteredLength > 1) || (widget.filteredLength == 0);

    if (widget.showFavoritesOnly) {
      if (isPlural) {
        return AppLocalizations.of(context).favoriteEntriesLabel;
      } else {
        return AppLocalizations.of(context).favoriteEntryLabel;
      }
    } else {
      if (isPlural) {
        return AppLocalizations.of(context).entriesLabel;
      } else {
        return AppLocalizations.of(context).entryLabel;
      }
    }
  }

  double get _scrollAniValue =>
      _animationOnScrollController.animationController.value;

  List<BoxShadow> get _boxShadow {
    List<BoxShadow> shadows = [];

    for (BoxShadow shadow in LitBoxShadows.md) {
      shadows.add(
        BoxShadow(
          blurRadius: _scrollAniValue * shadow.blurRadius,
          color:
              shadow.color.withOpacity(_scrollAniValue * shadow.color.opacity),
          offset: Offset(
            _scrollAniValue * shadow.offset.dx,
            _scrollAniValue * shadow.offset.dy,
          ),
        ),
      );
    }
    return shadows;
  }

  void _onShowFavoritesOnlyToggle() {
    _animationController
        .reverse()
        .then((val) => _animationController.forward());
    widget.toggleShowFavoritesOnly();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(
        milliseconds: 150,
      ),
      vsync: this,
    );

    _animationOnScrollController = AnimationOnScrollController(
      scrollController: widget.scrollController,
      vsync: this,
      requiredScrollOffset: _offsetThreshold,
    );

    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: DiaryFilterHeaderDelegate(
        AnimatedBuilder(
          animation: _animationOnScrollController.animationController,
          builder: (context, child) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: _boxShadow,
            ),
            child: child,
          ),
          child: SizedBox(
            width: alternativeWidth(
              MediaQuery.of(context).size,
              portraitWidth: portraitWidth,
              landscapeWidth: landscapeWidth,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 8.0,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: RichText(
                        text: TextSpan(
                          style: widget.textStyle,
                          children: [
                            TextSpan(
                              text: widget.filteredLength.toString(),
                            ),
                            TextSpan(text: ' '),
                            TextSpan(
                              text: _entriesLabel,
                              style: widget.accentTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  builder: (context, child) {
                    return AnimatedOpacity(
                      duration: _animationController.duration!,
                      opacity: _animationController.value,
                      child: child,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: SizedBox(
                    width: 112.0,
                    child: LitSliderToggleButton(
                      onPressed: _onShowFavoritesOnlyToggle,
                      enabledTitle: Icon(
                        LitIcons.heart_solid,
                        size: 16.0,
                        color: widget.showFavoritesOnly
                            ? widget.accentTextStyle.color
                            : widget.textStyle.color,
                      ),
                      disabledTitle: ClippedText(
                        LeitmotifLocalizations.of(context).allLabel,
                        style: widget.textStyle.copyWith(
                          color: widget.showFavoritesOnly
                              ? widget.textStyle.color
                              : widget.accentTextStyle.color,
                        ),
                      ),
                      enabled: widget.showFavoritesOnly,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
