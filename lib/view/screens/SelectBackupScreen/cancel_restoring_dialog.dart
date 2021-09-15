import 'package:flutter/material.dart';
import 'package:leitmotif/leitmotif.dart';

class CancelRestoringDialog extends StatelessWidget {
  final void Function() onCancel;
  const CancelRestoringDialog({
    Key? key,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      child: LitDescriptionTextBox(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        text:
            "Do you want to create a new diary instead of restoring your old one?",
      ),
      titleText: "Create new diary?",
      actionButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: LitPushedThroughButton(
            child: Text(
              "Create new".toUpperCase(),
              style: LitSansSerifStyles.button,
              textAlign: TextAlign.center,
            ),
            onPressed: onCancel,
          ),
        )
      ],
    );
  }
}
