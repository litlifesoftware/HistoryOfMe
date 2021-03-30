import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitTitledDialog extends StatelessWidget {
  final double titleBarHeight;
  final double borderRadius;
  final Widget child;
  final LinearGradient titleGradient;
  final String titleText;
  final Color titleTextColor;
  final bool elevated;
  final Widget leading;
  final double maxWidth;
  final double minHeight;
  final EdgeInsets margin;
  final List<Widget> actionButtons;
  const LitTitledDialog({
    Key? key,
    this.titleBarHeight = 52.0,
    this.borderRadius = 30.0,
    required this.child,
    this.titleGradient = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      stops: [
        0.65,
        1.00,
      ],
      colors: [
        Color(0xFFf4f4f7),
        Color(0xFFd1cdcd),
      ],
    ),
    required this.titleText,
    this.titleTextColor = const Color(0xFF444444),
    this.elevated = true,
    this.leading = const SizedBox(),
    this.maxWidth = 400,
    this.minHeight = 152.0,
    this.actionButtons = const [],
    this.margin = const EdgeInsets.only(
      top: 0.0,
      bottom: 0.0,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 0.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxWidth: constraints.maxWidth > maxWidth
                  ? maxWidth
                  : constraints.maxWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogTopBar(
                  titleBarHeight: titleBarHeight,
                  borderRadius: borderRadius,
                  titleGradient: titleGradient,
                  elevated: elevated,
                  titleText: titleText,
                  titleTextColor: titleTextColor,
                  leading: leading,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (minHeight - (2 * titleBarHeight)),
                    maxWidth: constraints.maxWidth > maxWidth
                        ? maxWidth
                        : constraints.maxWidth,
                  ),
                  child: Padding(
                    padding: margin,
                    child: child,
                  ),
                ),
                actionButtons.isNotEmpty
                    ? _DialogBottomBar(
                        titleBarHeight: titleBarHeight,
                        borderRadius: borderRadius,
                        actionButtons: actionButtons,
                      )
                    : SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DialogTopBar extends StatelessWidget {
  final double titleBarHeight;
  final double borderRadius;
  final Gradient titleGradient;
  final bool elevated;
  final String titleText;
  final Color titleTextColor;
  final Widget leading;
  const _DialogTopBar({
    Key? key,
    required this.titleBarHeight,
    required this.borderRadius,
    required this.titleGradient,
    required this.elevated,
    required this.titleText,
    required this.titleTextColor,
    required this.leading,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: titleBarHeight,
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              gradient: titleGradient,
              boxShadow: elevated
                  ? [
                      BoxShadow(
                          color: Colors.black38,
                          blurRadius: 15.0,
                          offset: Offset(-2, -2),
                          spreadRadius: 1.0)
                    ]
                  : []),
          child: Center(
            child: Text(
              titleText,
              textAlign: TextAlign.center,
              style: LitTextStyles.sansSerif.copyWith(
                  fontSize: 16.0,
                  color: titleTextColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Container(
          height: titleBarHeight,
          child: Align(
            alignment: Alignment.topLeft,
            child: leading,
          ),
        )
      ],
    );
  }
}

class _DialogBottomBar extends StatelessWidget {
  final double titleBarHeight;
  final double borderRadius;
  final List<Widget> actionButtons;
  const _DialogBottomBar({
    Key? key,
    required this.titleBarHeight,
    required this.borderRadius,
    required this.actionButtons,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: titleBarHeight,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
              color: LitColors.lightGrey,
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actionButtons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
