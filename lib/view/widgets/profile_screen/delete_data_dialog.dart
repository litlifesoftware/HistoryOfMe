import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class DeleteDataDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 16.0,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Row(
              children: [
                ExclamationRectangle(
                  height: constraints.maxWidth * 0.35,
                  width: constraints.maxWidth * 0.35,
                  margin: const EdgeInsets.all(8.0),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.65,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Text(
                      "To delete all your data including your diary and other user specific data, simply uninstall this app.",
                      style: LitTextStyles.sansSerifBodyTighterSmaller,
                    ),
                  ),
                )
              ],
            )
          ],
        );
      }),
      titleText: "Delete your data",
    );
  }
}
