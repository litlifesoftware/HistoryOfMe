import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'selectable_color_tile.dart';

class SecondaryColorSelectorCard extends StatefulWidget {
  final String cardTitle;
  final List<BoxShadow> buttonBoxShadow;
  final List<UserCreatedColor> userCreatedColors;
  //final UserData? userData;
  final int selectedSecondaryColorValue;
  final void Function(Color color) onSelectSecondaryColor;
  const SecondaryColorSelectorCard({
    Key? key,
    this.cardTitle = "Secondary Color",
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

  @override
  _SecondaryColorSelectorCardState createState() =>
      _SecondaryColorSelectorCardState();
}

class _SecondaryColorSelectorCardState
    extends State<SecondaryColorSelectorCard> {
  @override
  Widget build(BuildContext context) {
    bool _colorIsSelected(Color color) {
      return color == Color(widget.selectedSecondaryColorValue);
    }

    Color _mapSelectedColor(int index) {
      return Color.fromARGB(
        widget.userCreatedColors[index].alpha,
        widget.userCreatedColors[index].red,
        widget.userCreatedColors[index].green,
        widget.userCreatedColors[index].blue,
      );
    }

    return LitElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.cardTitle,
            style: LitTextStyles.sansSerif.copyWith(
              color: HexColor('#878787'),
              fontSize: 22.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 64.0,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.userCreatedColors.length,
                itemBuilder: (BuildContext context, int index) {
                  return SelectableColorTile(
                    onSelectCallback: widget.onSelectSecondaryColor,
                    color: _mapSelectedColor(index),
                    selected: _colorIsSelected(_mapSelectedColor(index)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
