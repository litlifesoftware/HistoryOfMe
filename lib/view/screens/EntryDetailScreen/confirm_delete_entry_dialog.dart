import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:leitmotif/leitmotif.dart';

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
      titleText: HOMLocalizations(context).deleteEntry,
      child: Padding(
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
                Expanded(
                  flex: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ExclamationRectangle(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        height: constraints.maxWidth,
                        width: constraints.maxWidth,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      HOMLocalizations(context).deleteEntryDescr,
                      textAlign: TextAlign.left,
                      style: LitSansSerifStyles.body1.copyWith(
                        color: LitColors.lightGrey,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actionButtons: [
        DialogActionButton(
          data: ActionButtonData(
            title: HOMLocalizations(context).cancel.toUpperCase(),
            onPressed: _onCancel,
          ),
        ),
        DialogActionButton(
          data: ActionButtonData(
            title: HOMLocalizations(context).delete.toUpperCase(),
            backgroundColor: LitColors.lightRed,
            accentColor: Colors.white,
            onPressed: _onDelete,
          ),
        ),
      ],
    );
  }
}
