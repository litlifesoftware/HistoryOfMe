import 'package:flutter/material.dart';
import 'package:history_of_me/config/styles.dart';
import 'package:leitmotif/leitmotif.dart';

class PurplePinkButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;

  const PurplePinkButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitGradientButton(
      accentColor: lightPurple,
      color: pink,
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
