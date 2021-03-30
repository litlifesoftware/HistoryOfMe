import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitGlowingButton extends StatelessWidget {
  final void Function() onPressed;
  final Color baseColor;
  final Color accentColor;
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  const LitGlowingButton({
    Key? key,
    required this.onPressed,
    this.baseColor = const Color(0xFFef93a1),
    this.accentColor = const Color(0xFFb2b2b2),
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      vertical: 6.0,
      horizontal: 22.0,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LitPushedButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              offset: Offset(-2, -2),
              color: Color.lerp(baseColor, accentColor, 0.7)!.withOpacity(0.4),
              spreadRadius: 1.0,
            ),
            BoxShadow(
              blurRadius: 8.0,
              offset: Offset(2, 2),
              color: Color.lerp(baseColor, accentColor, 0.4)!.withOpacity(0.4),
              spreadRadius: 1.0,
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [
                0.0,
                0.95,
              ],
              colors: [
                baseColor,
                accentColor
              ]),
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
