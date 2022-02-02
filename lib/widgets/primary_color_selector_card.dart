part of widgets;

/// A widget allowing to either select one of the previously created colors or
/// to enable the user to create a new color.
class PrimaryColorSelectorCard extends StatefulWidget {
  /// Creates a [PrimaryColorSelectorCard].
  const PrimaryColorSelectorCard({
    Key? key,
    required this.cardTitle,
    required this.selectedColorValue,
    this.buttonBoxShadow = const [
      const BoxShadow(
        blurRadius: 2.0,
        color: Colors.black12,
        offset: Offset(2.0, 1.0),
        spreadRadius: 0.5,
      ),
    ],
    required this.userCreatedColors,
    required this.onSelectPrimaryColor,
    required this.onAddColorError,
  }) : super(key: key);

  /// The card's title.
  final String cardTitle;

  /// The currently selected color.
  final int selectedColorValue;

  /// The button's box shadow.
  final List<BoxShadow> buttonBoxShadow;

  /// All previously created colors.
  final List<UserCreatedColor> userCreatedColors;

  /// Handles the 'on select color' action.
  final void Function(Color) onSelectPrimaryColor;

  /// Handles any errors, if adding the color failed.
  final void Function() onAddColorError;

  @override
  _PrimaryColorSelectorCardState createState() =>
      _PrimaryColorSelectorCardState();
}

class _PrimaryColorSelectorCardState extends State<PrimaryColorSelectorCard>
    with TickerProviderStateMixin {
  late AnimationController _additionalColorsAnimationController;
  late AnimationController _colorSliderAnimationController;

  /// States whether to show all available colors.
  bool showAllColors = false;

  /// Animates the selectable color cards.
  Future<void> animateAdditionalColorsTransition() async {
    return showAllColors
        ? _additionalColorsAnimationController
            .reverse(from: 1.0)
            .then((value) => _additionalColorsAnimationController.forward())
        : _additionalColorsAnimationController.forward(from: 0.0);
  }

  /// Toggles the [showAllColors] values and plays the color card animation.
  void toggleAllColors() {
    animateAdditionalColorsTransition().then(
      (value) => setState(
        () {
          showAllColors = !showAllColors;
        },
      ),
    );
  }

  /// Shows the [LitColorPickerDialog] to enable user input for color values.
  void handleCreateColor() {
    showDialog(
      context: context,
      builder: (_) => LitColorPickerDialog(
        onApplyColor: (Color color) {
          _addColor(color);
        },
        initialColor: Color(widget.selectedColorValue),
        // applyLabel: HOMLocalizations(context).apply,
        // resetLabel: HOMLocalizations(context).reset,
        // titleText: HOMLocalizations(context).pickAColor,
        // transparentColorText: HOMLocalizations(context).colorIsTransparent,
      ),
    );
  }

  /// Adds a user created color or displays a error message, if adding the
  /// color has failed.
  void _addColor(Color color) {
    try {
      AppAPI(debug: App.DEBUG).addUserCreatedColor(
        color.alpha,
        color.red,
        color.green,
        color.blue,
      );

      animateAdditionalColorsTransition();
      // Prevent the duplicate color to be added to the database.
    } catch (e) {
      widget.onAddColorError();

      // Select the provided color as the user's primary color.
      widget.onSelectPrimaryColor(color);
    }
  }

  /// Returns the `show all colors` button data.
  ActionButtonData get showAllButtonData => ActionButtonData(
        title: showAllColors
            ? LeitmotifLocalizations.of(context).lessLabel
            : LeitmotifLocalizations.of(context).moreLabel,
        onPressed: toggleAllColors,
      );

  /// Returns the `toggle show all colors` button data.
  ActionButtonData get createButtonData => ActionButtonData(
        title: LeitmotifLocalizations.of(context).createLabel,
        backgroundColor: LitColors.grey120,
        accentColor: LitColors.grey120,
        onPressed: handleCreateColor,
      );

  @override
  void initState() {
    super.initState();
    // Initialize all controllers.
    _additionalColorsAnimationController = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _colorSliderAnimationController = AnimationController(
      duration: Duration(milliseconds: 130),
      vsync: this,
    );
    // Play back the animations.
    _additionalColorsAnimationController.forward();
    _colorSliderAnimationController.forward();
  }

  @override
  void dispose() {
    _additionalColorsAnimationController.dispose();
    _colorSliderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: LitTitledActionCard(
        title: widget.cardTitle,
        subtitle: AppLocalizations.of(context).selectMainColorLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: UserCreatedColorGrid(
                    additionalColorsAnimationController:
                        _additionalColorsAnimationController,
                    boxShadow: widget.buttonBoxShadow,
                    onSelectColorCallback: widget.onSelectPrimaryColor,
                    selectedColorValue: widget.selectedColorValue,
                    showAllColors: showAllColors,
                    userColors: widget.userCreatedColors,
                  ),
                ),
              ],
            ),
          ],
        ),
        actionButtonData: showAllColors
            ? [showAllButtonData, createButtonData]
            : [showAllButtonData],
      ),
    );
  }
}

/// A widget displaying a grid of selectable color cards.
class UserCreatedColorGrid extends StatefulWidget {
  final AnimationController additionalColorsAnimationController;
  final List<BoxShadow> boxShadow;
  final bool showAllColors;
  final List<UserCreatedColor> userColors;
  final void Function(Color) onSelectColorCallback;
  final int selectedColorValue;
  const UserCreatedColorGrid({
    Key? key,
    required this.additionalColorsAnimationController,
    required this.boxShadow,
    required this.showAllColors,
    required this.userColors,
    required this.onSelectColorCallback,
    required this.selectedColorValue,
  }) : super(key: key);
  @override
  _UserCreatedColorGridState createState() => _UserCreatedColorGridState();
}

class _UserCreatedColorGridState extends State<UserCreatedColorGrid>
    with TickerProviderStateMixin {
  /// States whether the user has entered the 'deletion' mode to remove colors.
  bool _deletionEnabled = false;

  late AnimationController _animationController;

  /// Toggles the [_deletionEnabled] value and plays back the animation.
  void _toggleDeletionEnabled() {
    setState(() {
      _deletionEnabled = !_deletionEnabled;
    });
    if (_deletionEnabled) {
      _animationController.repeat(reverse: true);
    } else {
      if (_animationController.isAnimating) {
        _animationController.stop();
        _animationController.animateTo(1.0);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: widget.additionalColorsAnimationController,
          builder: (context, _) {
            List<Widget> _colorGrid = [];
            const int columns = 5;
            int colorIndex = 0;
            for (int i = 0;
                widget.showAllColors
                    ? (i < (widget.userColors.length / columns).ceil())
                    : (i < (1));
                i++) {
              List<Widget> colorRow = [];

              for (int j = 0; j < 5; j++) {
                if (colorIndex < (widget.userColors.length)) {
                  colorRow.add(
                    AnimatedOpacity(
                      duration:
                          widget.additionalColorsAnimationController.duration!,
                      opacity: widget.additionalColorsAnimationController.value,
                      child: _DeletableColorGridItem(
                        animation: _animationController,
                        boxShadow: widget.boxShadow,
                        columns: columns,
                        constraints: constraints,
                        deletionEnabled: _deletionEnabled,
                        index: colorIndex,
                        onSelectColorCallback: widget.onSelectColorCallback,
                        selectedColorValue: widget.selectedColorValue,
                        toggleDeletionEnabled: _toggleDeletionEnabled,
                        userColors: widget.userColors,
                      ),
                    ),
                  );
                  colorIndex++;
                }
              }
              _colorGrid.add(Row(
                children: colorRow,
              ));
            }
            return Column(
              children: _colorGrid,
            );
          },
        );
      },
    );
  }
}

/// A widget displaying a selectable color card.
///
/// The [deletionEnabled] will state whether the color be allowed to be removed.
class _DeletableColorGridItem extends StatefulWidget {
  final bool deletionEnabled;
  final Animation animation;
  final List<BoxShadow> boxShadow;
  final int index;
  final List<dynamic> userColors;
  final int selectedColorValue;
  final void Function(Color) onSelectColorCallback;
  final BoxConstraints constraints;
  final int columns;
  final void Function() toggleDeletionEnabled;
  const _DeletableColorGridItem({
    Key? key,
    required this.deletionEnabled,
    required this.animation,
    required this.boxShadow,
    required this.index,
    required this.userColors,
    required this.selectedColorValue,
    required this.onSelectColorCallback,
    required this.constraints,
    required this.columns,
    required this.toggleDeletionEnabled,
  }) : super(key: key);
  @override
  _DeletableColorGridItemState createState() => _DeletableColorGridItemState();
}

class _DeletableColorGridItemState extends State<_DeletableColorGridItem> {
  /// Returns a [Color] object based on the provided [UserCreatedColor].
  Color _mapColor(UserCreatedColor userColor) {
    int red = userColor.red;
    int green = userColor.green;
    int blue = userColor.blue;
    int alpha = userColor.alpha;
    return Color.fromARGB(alpha, red, green, blue);
  }

  /// Deletes the color permanently.
  void _onDelete() {
    AppAPI().deleteUserCreatedColor(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return DeletableContainer(
      deletionEnabled: widget.deletionEnabled,
      animation: widget.animation,
      child: SelectableColorTile(
        boxShadow: widget.boxShadow,
        onSelectCallback: widget.onSelectColorCallback,
        selected: widget.selectedColorValue ==
            _mapColor(
              widget.userColors[widget.index],
            ).value,
        color: _mapColor(
          widget.userColors[widget.index],
        ),
        height: widget.constraints.maxWidth / widget.columns,
        width: widget.constraints.maxWidth / widget.columns,
      ),
      toggleDeletionEnabled: widget.toggleDeletionEnabled,
      colorIndex: widget.index,
      onDelete: _onDelete,
    );
  }
}
