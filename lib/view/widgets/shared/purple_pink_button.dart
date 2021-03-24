import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class PurplePinkButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const PurplePinkButton({
    Key key,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitGradientButton(
      accentColor: const Color(0xFFDE8FFA),
      color: const Color(0xFFFA72AA),
      child: Text(
        label.toUpperCase(),
        style: LitTextStyles.sansSerif.copyWith(
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
