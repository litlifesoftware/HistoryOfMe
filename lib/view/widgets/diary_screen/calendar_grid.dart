import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

import 'calendar_day_item.dart';

class CalendarGrid extends StatelessWidget {
  final CalendarController calendarController;
  final DateTime? selectedDate;
  final void Function(DateTime) setSelectedDateTime;
  final void Function() exclusiveMonthCallback;
  final void Function() futureDateCallback;
  const CalendarGrid({
    Key? key,
    required this.calendarController,
    required this.selectedDate,
    required this.setSelectedDateTime,
    required this.exclusiveMonthCallback,
    required this.futureDateCallback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final List<Row> weekList = <Row>[];
        int count = 0;
        for (int i = 0; i < calendarController.derivateDates.length / 7; i++) {
          final List<Widget> dayList = <Widget>[];

          for (int i = 0; i < 7; i++) {
            //print(count);
            final DateTime iteratedDate =
                calendarController.derivateDates[count];
            dayList.add(
              CalendarDayItem(
                constraints: constraints,
                displayedDate: iteratedDate,
                templateDate: calendarController.templateDate,
                selectDateCallback: setSelectedDateTime,
                selectedDate: selectedDate,
                exclusiveMonthCallback: exclusiveMonthCallback,
                futureDateCallback: futureDateCallback,
              ),
            );
            if (count < (calendarController.derivateDates.length - 1)) {
              count++;
            }
            // print(count);
            // print(derivateDateList.length - 1);
          }
          weekList.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: dayList,
          ));
        }
        return Column(
          children: weekList,
        );
      }),
    );
  }
}
