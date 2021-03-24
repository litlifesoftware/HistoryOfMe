import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_plain_label_button.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_titled_dialog.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class SelectMonthDialog extends StatefulWidget {
  final void Function(int) setDisplayedMonthCallback;
  final List<String> months;
  const SelectMonthDialog({
    Key key,
    @required this.setDisplayedMonthCallback,
    @required this.months,
  }) : super(key: key);

  @override
  _SelectMonthDialogState createState() => _SelectMonthDialogState();
}

class _SelectMonthDialogState extends State<SelectMonthDialog> {
  void _onPressed(int value) {
    widget.setDisplayedMonthCallback(value);
    LitRouteController(context).closeDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: LitTitledDialog(
        titleText: "Month",
        child: Builder(
          builder: (context) {
            final List<Widget> children = [];
            widget.months.asMap().forEach((index, string) {
              children.add(LitPlainLabelButton(
                label: string,
                accentColor: LitColors.darkOliveGreen,
                onPressed: () => _onPressed(index + 1),
              ));
            });

            return ScrollableColumn(children: children);
          },
        ),
      ),
    );
  }
}
