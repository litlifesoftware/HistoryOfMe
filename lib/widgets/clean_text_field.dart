part of widgets;

/// A clean [TextField] without border decoration applied.
///
/// Allows to provide a custom text style.
class CleanTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextStyle style;
  final bool showCounter;
  final int? maxLines;
  final int? minLines;

  /// Creates a [CleanTextField].
  const CleanTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.style,
    this.maxLines,
    this.minLines,
    this.showCounter = false,
  }) : super(key: key);

  /// Returns the hint's text style
  TextStyle get hintStyle => style.copyWith(color: LitColors.grey200);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: LitColors.grey200,
      cursorRadius: Radius.circular(2.0),
      decoration: InputDecoration(
        border: InputBorder.none,
        counter: showCounter ? WordCountBadge(controller: controller) : null,
        hintText: AppLocalizations.of(context).hintText + "...",
        hintStyle: hintStyle,
      ),
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      style: style,
    );
  }
}
