import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitBadge extends StatelessWidget {
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Widget child;

  const LitBadge({
    Key key,
    this.backgroundColor = LitColors.mediumGrey,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(8.0),
    ),
    @required this.child,
    this.padding = const EdgeInsets.symmetric(
      vertical: 2.0,
      horizontal: 8.0,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
