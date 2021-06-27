import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'selectable_color_tile.dart';

/// A card widget displaying a scrolling list of selectable color cards.
///
/// The selected color's values are set to be the bookmark's secondary color.
class SecondaryColorSelectorCard extends StatefulWidget {
  const SecondaryColorSelectorCard({
    Key? key,
    required this.cardTitle,
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

  /// The card's title.
  final String cardTitle;

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
  /// provided [widget.userCreatedColors] list (based on its index).
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
    return LitElevatedCard(
      margin: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 0.0,
              left: 18.0,
              right: 18.0,
            ),
            child: Text(
              widget.cardTitle,
              style: LitTextStyles.sansSerif.copyWith(
                color: HexColor('#878787'),
                fontSize: 22.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
            ),
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
    );
  }
}
