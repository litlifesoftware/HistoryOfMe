import 'package:flutter/material.dart';
import 'package:history_of_me/view/widgets/diary_screen/selected_create_tile.dart';
import 'package:history_of_me/view/widgets/diary_screen/unselected_create_tile.dart';

class EntryDaySelectionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final void Function() onPress;
  final AnimationController animationController;
  const EntryDaySelectionTile({
    Key? key,
    required this.label,
    required this.selected,
    required this.onPress,
    required this.animationController,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: selected
          ? AnimatedOpacity(
              opacity: animationController.value,
              duration: animationController.duration!,
              child: SelectedCreateTile(
                label: label,
              ),
            )
          : UnselectedCreateTile(
              label: label,
            ),
    );
  }
}
