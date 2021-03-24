import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_titled_dialog.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class ConfirmDiscardDraftDialog extends StatefulWidget {
  final String titleText;
  final String discardButtonLabel;
  final String cancelButtonLabel;
  final String unsavedChangesDetectedText;
  final String discardDraftText;
  final void Function() onDiscardCallback;
  const ConfirmDiscardDraftDialog({
    Key key,
    this.titleText = "Unsaved changes",
    this.discardButtonLabel = "Discard",
    this.cancelButtonLabel = "Cancel",
    this.unsavedChangesDetectedText =
        "There have been unsaved changes detected.",
    this.discardDraftText = "Do you want to discard your changes?",
    @required this.onDiscardCallback,
  }) : super(key: key);
  @override
  _ConfirmDiscardDraftDialogState createState() =>
      _ConfirmDiscardDraftDialogState();
}

class _ConfirmDiscardDraftDialogState extends State<ConfirmDiscardDraftDialog>
    with TickerProviderStateMixin {
  AnimationController _appearAnimationController;

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
      actionButtons: [
        LitGradientButton(
          boxShadow: [],
          color: Color.lerp(
            LitColors.mediumGrey,
            LitColors.lightGrey,
            0.34,
          ),
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
        builder: (BuildContext context, Widget _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                ),
                child: Text(
                  widget.unsavedChangesDetectedText,
                  textAlign: TextAlign.center,
                  style: LitTextStyles.sansSerif.copyWith(
                    color: HexColor('#B57B79'),
                  ),
                ),
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
