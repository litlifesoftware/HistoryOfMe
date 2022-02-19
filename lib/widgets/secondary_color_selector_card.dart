part of widgets;

/// A card widget displaying a scrolling list of selectable color cards.
///
/// The selected color's values are set to be the bookmark's secondary color.
class SecondaryColorSelectorCard extends StatefulWidget {
  const SecondaryColorSelectorCard({
    Key? key,
    this.buttonBoxShadow = const [
      const BoxShadow(
        blurRadius: 2.0,
        color: Colors.black12,
        offset: Offset(2, 1),
        spreadRadius: 0.5,
      ),
    ],
    required this.userCreatedColors,
    required this.selectedSecondaryColorValue,
    required this.onSelectSecondaryColor,
  }) : super(key: key);

  /// The box shadow applied to the buttons.
  final List<BoxShadow> buttonBoxShadow;

  /// The list of selectable colors.
  final List<UserCreatedColor> userCreatedColors;

  /// The currently selected color (as an integer value).
  final int selectedSecondaryColorValue;

  /// The callback to update the selected color.
  final void Function(Color color) onSelectSecondaryColor;

  @override
  _SecondaryColorSelectorCardState createState() =>
      _SecondaryColorSelectorCardState();
}

class _SecondaryColorSelectorCardState
    extends State<SecondaryColorSelectorCard> {
  /// States whether the provided [color] is currently selected.
  bool _colorIsSelected(Color color) {
    return color == Color(widget.selectedSecondaryColorValue);
  }

  /// Returns the color values as a [Color] object of an specific item on the
  /// provided color list (based on its index).
  Color _mapSelectedColor(int index) {
    return Color.fromARGB(
      widget.userCreatedColors[index].alpha,
      widget.userCreatedColors[index].red,
      widget.userCreatedColors[index].green,
      widget.userCreatedColors[index].blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: LitTitledActionCard(
        title: AppLocalizations.of(context).accentColorLabel.capitalize(),
        subtitle: AppLocalizations.of(context).selectAccentColorLabel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                height: 64.0,
                child: LitScrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.userCreatedColors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SelectableColorTile(
                        onSelectCallback: widget.onSelectSecondaryColor,
                        color: _mapSelectedColor(index),
                        selected: _colorIsSelected(
                          _mapSelectedColor(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
