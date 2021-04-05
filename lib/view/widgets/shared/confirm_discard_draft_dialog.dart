import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_titled_dialog.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

import '../art/exclamation_rectangle.dart';

class ConfirmDiscardDraftDialog extends StatefulWidget {
  final String titleText;
  final String discardButtonLabel;
  final String cancelButtonLabel;
  final String unsavedChangesDetectedText;
  final String discardDraftText;
  final void Function() onDiscardCallback;
  const ConfirmDiscardDraftDialog({
    Key? key,
    this.titleText = "Unsaved changes",
    this.discardButtonLabel = "Discard",
    this.cancelButtonLabel = "Cancel",
    this.unsavedChangesDetectedText =
        "There have been unsaved changes detected.",
    this.discardDraftText = "Do you want to discard your changes?",
    required this.onDiscardCallback,
  }) : super(key: key);
  @override
  _ConfirmDiscardDraftDialogState createState() =>
      _ConfirmDiscardDraftDialogState();
}

class _ConfirmDiscardDraftDialogState extends State<ConfirmDiscardDraftDialog>
    with TickerProviderStateMixin {
  late AnimationController _appearAnimationController;

  /// Closes the dialog.
  void _onCancel() {
    LitRouteController(context).closeDialog();
  }

  @override
  void initState() {
    super.initState();
    _appearAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: widget.titleText,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      actionButtons: [
        LitGradientButton(
          boxShadow: [],
          color: Color.lerp(
            LitColors.mediumGrey,
            LitColors.lightGrey,
            0.34,
          )!,
          accentColor: LitColors.mediumGrey,
          child: Text(
            widget.discardButtonLabel,
            style: LitTextStyles.sansSerif.copyWith(
              color: Colors.white,
            ),
          ),
          onPressed: widget.onDiscardCallback,
        ),
        LitGradientButton(
          boxShadow: [],
          child: Text(
            widget.cancelButtonLabel,
            style: LitTextStyles.sansSerif,
          ),
          onPressed: _onCancel,
        ),
      ],
      child: AnimatedBuilder(
        animation: _appearAnimationController,
        builder: (BuildContext context, Widget? _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * 0.25,
                        child: ExclamationRectangle(
                          width: (constraints.maxWidth * 0.25) - 4,
                          height: (constraints.maxWidth * 0.25) - 4,
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth * 0.66,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: Text(
                            widget.unsavedChangesDetectedText,
                            textAlign: TextAlign.left,
                            style: LitTextStyles.sansSerif.copyWith(
                              color: LitColors.lightGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                ),
                child: Text(
                  widget.discardDraftText,
                  textAlign: TextAlign.center,
                  style: LitTextStyles.sansSerif.copyWith(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
