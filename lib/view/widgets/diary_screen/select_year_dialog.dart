import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_titled_dialog.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// A dialog [Widget] displaying a list of selectable years.
///
/// Once the year has been selected by the user, the provided callback method
/// will return the desired year as an integer (e.g. 2021).
class SelectYearDialog extends StatefulWidget {
  final void Function(int year) setDisplayedYearCallback;
  final DateTime templateDate;
  final int numberOfYears;

  /// Creates a [SelectYearDialog].
  ///
  /// Pass a [setDisplayedYearCallback] to set the parent's state and a
  /// [templateDate] to set the initially displayed year inside the list.
  const SelectYearDialog({
    Key key,
    @required this.setDisplayedYearCallback,
    @required this.templateDate,
    this.numberOfYears = 20,
  }) : super(key: key);

  @override
  _SelectYearDialogState createState() => _SelectYearDialogState();
}

class _SelectYearDialogState extends State<SelectYearDialog> {
  PageController _pageController;

  final int millisecondsPerYear = 31556926000;

  void _onPressed(int value) {
    widget.setDisplayedYearCallback(value);
    LitRouteController(context).closeDialog();
  }

  /// Gets the inital page that should be selected on the page view.
  int get initialPage {
    return
        // If the provided template date is as recently as the provided number
        // of years allow (e.g. as recently as 20 years ago).
        widget.templateDate.year >
                DateTime.now()
                    .subtract(Duration(
                        milliseconds:
                            millisecondsPerYear * widget.numberOfYears))
                    .year
            // Set the index to display the provided template year
            ? (DateTime.now().year -
                (DateTime.fromMillisecondsSinceEpoch(
                        widget.templateDate.millisecondsSinceEpoch))
                    .year)
            // Otherwise select the first year in the page list.
            : 0;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  Widget build(BuildContext context) {
    print(_pageController.initialPage);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: LitTitledDialog(
        titleText: "Year",
        child: Builder(
          builder: (context) {
            final List<Widget> children = [];
            for (int i = 0; i < widget.numberOfYears; i++) {
              final DateTime iteratedDate = DateTime.now()
                  .subtract(Duration(milliseconds: millisecondsPerYear * i));
              children.add(
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30.0,
                      horizontal: 30.0,
                    ),
                    child: LitRoundedElevatedButton(
                      color: HexColor('#b6c5c6'),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24.0,
                          color: Colors.black38,
                          offset: Offset(4, 4),
                          spreadRadius: 2.0,
                        )
                      ],
                      child: ScaledDownText(
                        "${iteratedDate.year}",
                        style: LitTextStyles.sansSerif.copyWith(
                          fontSize: 24.0,
                          color: Colors.white,
                          letterSpacing: 0.45,
                        ),
                      ),
                      onPressed: () => _onPressed(iteratedDate.year),
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 130.0,
              child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  children: children),
            );
          },
        ),
      ),
    );
  }
}
