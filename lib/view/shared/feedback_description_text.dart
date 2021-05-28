import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// A a description text providing feedback to the user alongside an
/// [ExclamationRectangle] for visualization.
class FeedbackDescriptionText extends StatelessWidget {
  final String text;
  final double exclRectHeight;
  final double exclRectWidth;
  final EdgeInsets textBoxMargin;

  /// Creates a [FeedbackDescriptionText].
  const FeedbackDescriptionText({
    Key? key,
    required this.text,
    this.exclRectHeight = 64.0,
    this.exclRectWidth = 64.0,
    this.textBoxMargin = const EdgeInsets.only(left: 16.0),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExclamationRectangle(
              height: exclRectHeight,
              width: exclRectWidth,
            ),
            SizedBox(
              width: constraints.maxWidth - exclRectWidth,
              child: Padding(
                padding: textBoxMargin,
                child: Text(
                  text,
                  style: LitTextStyles.sansSerifStyles[body].copyWith(
                    fontSize: 14.0,
                    letterSpacing: -0.15,
                    height: 1.7,
                    color: Color(0xFF939393),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
