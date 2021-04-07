import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/view/widgets/art/exclamation_rectangle.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class ConfirmDeleteEntryDialog extends StatefulWidget {
  // final int index;
  final String? diaryEntryUid;
  const ConfirmDeleteEntryDialog({
    Key? key,
    required this.diaryEntryUid,
    // @required this.index,
  }) : super(key: key);
  @override
  _ConfirmDeleteEntryDialogState createState() =>
      _ConfirmDeleteEntryDialogState();
}

class _ConfirmDeleteEntryDialogState extends State<ConfirmDeleteEntryDialog> {
  void _onDelete() {
    LitRouteController(context).dicardAndExit();
    HiveDBService().deleteDiaryEntry(widget.diaryEntryUid);
    //print("delete diary on index ${widget.index}");
  }

  void _onCancel() {
    LitRouteController(context).closeDialog();
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: "Delete entry",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.4,
                      child: Center(child: ExclamationRectangle()),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.6,
                      child: Text(
                        "Do you want to delete your diary entry?",
                        textAlign: TextAlign.left,
                        style: LitTextStyles.sansSerif.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 16.0,
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [

          //     ],
          //   ),
          // )
        ],
      ),
      actionButtons: [
        LitRoundedFlatButton(
          color: LitColors.mediumGrey,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 20.0,
          ),
          child: Text(
            "Cancel",
            style: LitTextStyles.sansSerif.copyWith(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: _onCancel,
        ),
        LitRoundedFlatButton(
          color: LitColors.midRed,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 20.0,
          ),
          child: Text(
            "Delete",
            style: LitTextStyles.sansSerif.copyWith(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: _onDelete,
        ),
      ],
    );
  }
}
