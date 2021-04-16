import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class LitCalendarDayItem extends StatefulWidget {
  final BoxConstraints constraints;
  final DateTime displayedDate;
  final DateTime? templateDate;
  final DateTime? selectedDate;
  final void Function(DateTime date) selectDateCallback;
  final void Function() exclusiveMonthCallback;
  final void Function() futureDateCallback;
  final bool allowFutureDates;
  const LitCalendarDayItem({
    Key? key,
    required this.constraints,
    required this.displayedDate,
    required this.templateDate,
    required this.selectDateCallback,
    required this.selectedDate,
    required this.exclusiveMonthCallback,
    required this.futureDateCallback,
    required this.allowFutureDates,
  }) : super(key: key);

  @override
  _LitCalendarDayItemState createState() => _LitCalendarDayItemState();
}

class _LitCalendarDayItemState extends State<LitCalendarDayItem> {
  bool get _isPast {
    return widget.displayedDate.isBefore(DateTime.now()) &&
        !widget.allowFutureDates;
  }

  void _onSelect() {
    if (widget.displayedDate.month == widget.templateDate!.month) {
      // allowFutureDates has a higher hierarchy - if it's true, the futureDate
      // callback will never be called.
      if (_isPast || widget.allowFutureDates) {
        widget.selectDateCallback(widget.displayedDate);
      } else {
        widget.futureDateCallback();
      }
    } else {
      widget.exclusiveMonthCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.selectedDate == widget.displayedDate
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 8.0,
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  spreadRadius: 1.0,
                )
              ],
              gradient: LinearGradient(
                  colors: [
                    HexColor("#ef93a1"),
                    HexColor('#b2b2b2'),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.2,
                    0.9,
                  ]),
              borderRadius:
                  BorderRadius.circular((widget.constraints.maxWidth / 7) / 2),
            )
          : BoxDecoration(),
      child: InkWell(
        borderRadius:
            BorderRadius.circular((widget.constraints.maxWidth / 7) / 2),
        onTap: _onSelect,
        child: SizedBox(
          width: widget.constraints.maxWidth / 7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: ScaledDownText(
                "${widget.displayedDate.day}",
                style: LitTextStyles.sansSerif.copyWith(
                  fontSize: 16.0,
                  color:
                      widget.displayedDate.month == widget.templateDate!.month
                          ? widget.selectedDate == widget.displayedDate
                              ? Colors.white
                              : HexColor('#7a7a7a')
                          : HexColor('#7a7a7a').withOpacity(0.65),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
