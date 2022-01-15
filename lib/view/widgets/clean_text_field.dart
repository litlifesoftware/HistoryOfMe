part of widgets;

/// A clean [TextField] without border decoration applied.
///
/// Allows to provide a custom text style.
class CleanTextField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextStyle style;
  final int? maxLines;

  /// Creates a [CleanTextField].
  const CleanTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.style,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: LitColors.grey200,
      cursorRadius: Radius.circular(2.0),
      decoration: InputDecoration(border: InputBorder.none),
      focusNode: focusNode,
      maxLines: maxLines,
      style: style,
    );
  }
}
