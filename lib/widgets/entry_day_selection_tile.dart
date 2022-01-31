part of widgets;

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
