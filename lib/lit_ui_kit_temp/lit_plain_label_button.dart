import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitPlainLabelButton extends StatefulWidget {
  final String label;
  final void Function() onPressed;
  final Color accentColor;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;
  const LitPlainLabelButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.accentColor = Colors.white,
    this.color = const Color(0xFFb5b5b5),
    this.fontSize = 17.0,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  _LitPlainLabelButtonState createState() => _LitPlainLabelButtonState();
}

class _LitPlainLabelButtonState extends State<LitPlainLabelButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  void _onPressedDown(TapDownDetails details) {
    _animationController.reverse();
  }

  void _onPressedUp(TapUpDetails details) {
    _animationController.forward();
  }

  void _onPressed() {
    _animationController
        .reverse()
        .then((value) => _animationController.forward());
    widget.onPressed();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      onTapDown: _onPressedDown,
      onTapUp: _onPressedUp,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
        ),
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return ClippedText(
                widget.label,
                textAlign: widget.textAlign,
                style: LitTextStyles.sansSerif.copyWith(
                  fontSize: widget.fontSize,
                  color: Color.lerp(widget.accentColor, widget.color,
                      _animationController.value),
                ),
              );
            }),
      ),
    );
  }
}
