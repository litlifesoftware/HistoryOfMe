import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/routes/screen_router.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_titled_dialog.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/view/widgets/diary_screen/calendar_grid.dart';
import 'package:history_of_me/view/widgets/diary_screen/calendar_navigation.dart';
import 'package:history_of_me/view/widgets/diary_screen/calendar_weekday_label.dart';
import 'package:history_of_me/view/widgets/diary_screen/select_month_dialog.dart';
import 'package:history_of_me/view/widgets/diary_screen/select_year_dialog.dart';
import 'package:intl/intl.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class SelectPreviousDayDialog extends StatefulWidget {
  final void Function() onBackCallback;

  const SelectPreviousDayDialog({
    Key? key,
    required this.onBackCallback,
  }) : super(key: key);
  @override
  _SelectPreviousDayDialogState createState() =>
      _SelectPreviousDayDialogState();
}

class _SelectPreviousDayDialogState extends State<SelectPreviousDayDialog>
    with TickerProviderStateMixin {
  AnimationController? _appearAnimationController;
  late AnimationController _selectAnimationController;
  CalendarController _calendarController = CalendarController();
  LitSnackbarController? _exclusiveDateSnackBarController;
  LitSnackbarController? _futureDateSnackbarController;
  late ScreenRouter _screenRouter;
  DateTime? _selectedDate;
  String? weekdayLabels;

  void _decreaseByMonth() {
    setState(() => {_calendarController.decreaseByMonth()});
  }

  void _increaseByMonth() {
    setState(() => {_calendarController.increaseByMonth()});
  }

  void _setDisplayedMonth(int month) {
    setState(() {
      _calendarController.selectMonth(month);
    });
  }

  void _setDisplayedYear(int year) {
    setState(() {
      _calendarController.selectYear(year);
    });
  }

  void _setSelectedDate(DateTime date) {
    print(date);
    setState(() {
      if (_selectedDate == date) {
        _selectedDate = null;
        _selectAnimationController.reverse();
      } else {
        _selectedDate = date;
        _selectAnimationController.forward(from: 0);
      }
    });
  }

  void _onExclusiveMonth() {
    _exclusiveDateSnackBarController!.showSnackBar();
  }

  void _onFutureDate() {
    _futureDateSnackbarController!.showSnackBar();
  }

  void _onMonthLabelPress() {
    showDialog(
        context: context,
        builder: (_) => SelectMonthDialog(
              setDisplayedMonthCallback: _setDisplayedMonth,
              months: CalendarLocalizationService.getLocalizedCalendarMonths(
                  Localizations.localeOf(context)),
            ));
  }

  void _onYearLabelPress() {
    showDialog(
      context: context,
      builder: (_) => SelectYearDialog(
        setDisplayedYearCallback: _setDisplayedYear,
        templateDate: _calendarController.templateDate,
      ),
    );
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  void _onSubmitDate() {
    HiveDBService service = HiveDBService();

    if (!service.entryWithDateDoesExist(_selectedDate)) {
      DiaryEntry createdEntry = service.addDiaryEntry(date: _selectedDate!);
      _closeDialog();
      // Widget widget = EntryEditingScreen(
      //   diaryEntry: createdEntry,
      // );
      _screenRouter.toEntryEditingScreen(diaryEntry: createdEntry);
    } else {
      //TODO show snackbar
      print("does already exist");
    }
  }

  @override
  void initState() {
    super.initState();

    _appearAnimationController =
        AnimationController(duration: Duration(milliseconds: 140), vsync: this);
    _selectAnimationController =
        AnimationController(duration: Duration(milliseconds: 140), vsync: this);
    _appearAnimationController!.forward();
    _exclusiveDateSnackBarController = LitSnackbarController()..init(this);
    _futureDateSnackbarController = LitSnackbarController()..init(this);
    _screenRouter = ScreenRouter(context);
  }

  @override
  void dispose() {
    _exclusiveDateSnackBarController!.dispose();
    _futureDateSnackbarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_exclusiveDateSnackBarController!.animationController.value);

    print(DateTime.fromMillisecondsSinceEpoch(345600));
    return AnimatedBuilder(
        animation: _selectAnimationController,
        builder: (context, _) {
          return Material(
            color: _selectedDate != null
                ? Colors.black
                    .withOpacity((0.38 * _selectAnimationController.value))
                : Colors.transparent,
            child: Stack(
              children: [
                LitTitledDialog(
                  titleText: "Previous day",
                  leading: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: widget.onBackCallback,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: SizedBox(
                        height: 50.0,
                        width: 100.0,
                        child: LitTooltipContainer(
                            backgroundColor: HexColor('#d1cdcd'),
                            text:
                                "${MaterialLocalizations.of(context).backButtonTooltip}",
                            child: Icon(
                              LitIcons.arrow_left_solid,
                              size: 18.0,
                              color: HexColor('#f4f4f7'),
                            )),
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: AnimatedBuilder(
                    animation: _appearAnimationController!,
                    builder: (BuildContext context, Widget? _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeInTransformContainer(
                            transform: Matrix4.translationValues(
                                -20 + (20 * _appearAnimationController!.value),
                                0,
                                0),
                            animationController: _appearAnimationController,
                            child: CalendarNavigation(
                              decreaseByMonth: _decreaseByMonth,
                              increaseByMonth: _increaseByMonth,
                              onMonthLabelPress: _onMonthLabelPress,
                              onYearLabelPress: _onYearLabelPress,
                              monthLabel:
                                  "${CalendarLocalizationService.getLocalizedCalendarMonths(Localizations.localeOf(context))[_calendarController.templateDate!.month - 1]}",
                              yearLabel:
                                  "${_calendarController.templateDate!.year}",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              final List<String> strings =
                                  CalendarLocalizationService
                                      .getLocalizedCalendarWeekdays(
                                          Localizations.localeOf(context));
                              final List<Widget> labels = [];
                              for (String str in strings) {
                                labels.add(CalendarWeekdayLabel(
                                    constraints: constraints, label: str));
                              }
                              return Row(
                                children: labels,
                              );
                            }),
                          ),
                          FadeInTransformContainer(
                            animationController: _appearAnimationController,
                            child: CalendarGrid(
                              calendarController: _calendarController,
                              selectedDate: _selectedDate,
                              setSelectedDateTime: _setSelectedDate,
                              exclusiveMonthCallback: _onExclusiveMonth,
                              futureDateCallback: _onFutureDate,
                            ),
                            transform: Matrix4.translationValues(
                                0,
                                -20 + (20 * _appearAnimationController!.value),
                                0),
                          )
                        ],
                      );
                    },
                  ),
                ),
                IconSnackbar(
                    iconData: LitIcons.info,
                    text: "Date not included in current month.",
                    textStyle: LitTextStyles.sansSerif
                        .copyWith(color: Colors.white, fontSize: 13.0),
                    litSnackBarController: _exclusiveDateSnackBarController,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0)),
                IconSnackbar(
                    iconData: LitIcons.info,
                    text: "Future dates are not allowed.",
                    textStyle: LitTextStyles.sansSerif
                        .copyWith(color: Colors.white, fontSize: 13.0),
                    litSnackBarController: _futureDateSnackbarController,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0)),
                Align(
                  alignment: alternativeAlignment(MediaQuery.of(context).size,
                      portraitAlignment: Alignment.bottomCenter,
                      landscapeAlignment: Alignment.topRight),
                  child: Container(
                    child: _selectedDate != null
                        ? AnimatedOpacity(
                            duration: _selectAnimationController.duration!,
                            opacity:
                                0.5 + (_selectAnimationController.value * 0.5),
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  0,
                                  -32 + (_selectAnimationController.value * 32),
                                  0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24.0,
                                  horizontal: 16.0,
                                ),
                                child: LitGradientButton(
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8.0,
                                        color: Colors.black45,
                                        offset: Offset(
                                          -2,
                                          2,
                                        ),
                                        spreadRadius: 2.0,
                                      ),
                                    ],
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    child: Text(
                                      "${DateFormat.yMMMMd((Localizations.localeOf(context).languageCode)).format(_selectedDate!)}",
                                      style: LitTextStyles.sansSerif.copyWith(
                                          fontSize: alternativeFontSize(
                                            MediaQuery.of(context).size,
                                            potraitFontSize: 19.0,
                                            landscapeFontSize: 16.0,
                                          ),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onPressed: _onSubmitDate),
                                // AnimatedActionButton(
                                //   child: Text(
                                //     "$_selectedDate",
                                //     style: LitTextStyles.sansSerif.copyWith(
                                //         fontSize: 16.0,
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.w700),
                                //   ),
                                //   onPressed: _onSubmitDate,
                                //   alignment: Alignment.bottomCenter,
                                //   backgroundColor: HexColor("#8e8e8e"),
                                // ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                )
              ],
            ),
          );
        });
  }
}
