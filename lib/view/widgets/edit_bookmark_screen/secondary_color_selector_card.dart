import 'package:flutter/material.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:history_of_me/view/widgets/edit_bookmark_screen/selectable_color_tile.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class SecondaryColorSelectorCard extends StatelessWidget {
  final String cardTitle;
  final List<BoxShadow> buttonBoxShadow;
  final List<UserCreatedColor> userCreatedColors;

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
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitElevatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cardTitle,
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
                itemCount: userCreatedColors.length,
                itemBuilder: (BuildContext context, int index) {
                  return SelectableColorTile(
                    onSelectCallback: (color) =>
                        {print("selected color $color")},
                    color: Color.fromARGB(
                      userCreatedColors[index].alpha,
                      userCreatedColors[index].red,
                      userCreatedColors[index].green,
                      userCreatedColors[index].blue,
                    ),
                    selected: false,
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
