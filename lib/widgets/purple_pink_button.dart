part of widgets;

/// A Flutter widget displaying a gradient-decorated button.
class PurplePinkButton extends StatelessWidget {
  /// The button's label.
  final String label;

  /// Handles the `onPressed` action.
  final void Function() onPressed;

  /// Creates a [PurplePinkButton].
  const PurplePinkButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitGradientButton(
      accentColor: AppColors.purple,
      color: AppColors.pink,
      child: Text(
        label.toUpperCase(),
        style: LitTextStyles.sansSerifStyles[button].copyWith(
          color: Colors.white,
          fontSize: 13.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.3,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
