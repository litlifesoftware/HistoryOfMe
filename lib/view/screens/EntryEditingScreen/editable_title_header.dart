import 'package:flutter/material.dart';
import 'package:leitmotif/leitmotif.dart';

class EditableTitleHeader extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final EdgeInsets padding;
  const EditableTitleHeader({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 25.0,
      vertical: 4.0,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: EditableText(
        controller: textEditingController!,
        focusNode: focusNode!,
        style: LitTextStyles.sansSerif.copyWith(
          fontSize: 17.4,
          letterSpacing: 0.22,
          fontWeight: FontWeight.w700,
          color: LitColors.darkGrey,
        ),
        cursorColor: HexColor('#b7b7b7'),
        backgroundCursorColor: Colors.black,
        selectionColor: HexColor('#b7b7b7'),
        cursorWidth: 2.0,
        maxLines: null,
        cursorRadius: Radius.circular(2.0),
      ),
    );
  }
}
