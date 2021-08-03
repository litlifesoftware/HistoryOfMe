import 'package:flutter/material.dart';
import 'package:leitmotif/leitmotif.dart';

class EditableTitleHeader extends StatelessWidget {
  final AnimationController animationController;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final EdgeInsets padding;
  const EditableTitleHeader({
    Key? key,
    required this.animationController,
    required this.textEditingController,
    required this.focusNode,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 4.0,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: Padding(
        padding: padding,
        child: EditableText(
          controller: textEditingController!,
          focusNode: focusNode!,
          style: LitSansSerifStyles.h6,
          cursorColor: HexColor('#b7b7b7'),
          backgroundCursorColor: Colors.black,
          selectionColor: HexColor('#b7b7b7'),
          cursorWidth: 2.0,
          maxLines: null,
          cursorRadius: Radius.circular(2.0),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return FadeInTransformContainer(
          animationController: animationController,
          transform: Matrix4.translationValues(
            25 + -25 * animationController.value,
            0,
            0,
          ),
          child: child ?? SizedBox(),
        );
      },
    );
  }
}
