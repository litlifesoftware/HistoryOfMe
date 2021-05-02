import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/routes/screen_router.dart';
import 'package:history_of_me/view/widgets/shared/lit_toggle_button_group.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:intl/intl.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class CreateEntryDialog extends StatefulWidget {
  @override
  _CreateEntryDialogState createState() => _CreateEntryDialogState();
}

class _CreateEntryDialogState extends State<CreateEntryDialog>
    with TickerProviderStateMixin {
  late ScreenRouter _screenRouter;
  late AnimationController _appearAnimationController;
  late LitSnackbarController _duplicateSnackBarController;

  //DateTime? _selectedDate;
  //TODO: CreateEntryType enum
  int createEntryType = 1;
  int selectedtDialogType = 1;

  void setCreateEntryType(int value) {
    setState(() {
      createEntryType = value;
    });
    if (!(value == createEntryType)) {
      _appearAnimationController.forward(from: 0);
    }
  }

  void setSelectedDialogType(int value) {
    setState(() {
      selectedtDialogType = value;
    });
  }

  void _closeDialog() {
    LitRouteController(context).closeDialog();
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void _createTodaysEntry() {
    DateTime now = DateTime.now();
    HiveDBService service = HiveDBService();

    if (!service.entryWithDateDoesExist(now)) {
      DiaryEntry createdEntry = service.addDiaryEntry(
        date: DateTime(now.year, now.month, now.day),
      );
      _closeDialog();
      _screenRouter.toEntryEditingScreen(diaryEntry: createdEntry);
    } else {
      print("already created for today");
      _duplicateSnackBarController.showSnackBar();
    }
  }

  void _onCreate() {
    /// TODAY
    if (createEntryType == 1) {
      _createTodaysEntry();
    } else {
      // showDialog(
      //     context: context,
      //     builder: (_) => );
      setSelectedDialogType(2);
      print("other day");
    }
  }

  void _onSubmit(DateTime date) {
    HiveDBService service = HiveDBService();

    if (!service.entryWithDateDoesExist(date)) {
      DiaryEntry createdEntry = service.addDiaryEntry(date: date);
      _closeDialog();
      // Widget widget = EntryEditingScreen(
      //   diaryEntry: createdEntry,
      // );
      _screenRouter.toEntryEditingScreen(diaryEntry: createdEntry);
    } else {
      _duplicateSnackBarController.showSnackBar();
    }
  }

  @override
  void initState() {
    super.initState();
    _screenRouter = ScreenRouter(context);
    _duplicateSnackBarController = LitSnackbarController()..init(this);
    _appearAnimationController =
        AnimationController(duration: Duration(milliseconds: 140), vsync: this);
    _appearAnimationController.forward();
  }

  @override
  void dispose() {
    _duplicateSnackBarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: _closeDialog,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          selectedtDialogType == 1
              ? LitTitledDialog(
                  titleText: "Add a diary entry",
                  child: AnimatedBuilder(
                    animation: _appearAnimationController,
                    builder: (BuildContext context, Widget? _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                            child: LitToggleButtonGroup(
                              selectedValue: createEntryType,
                              onSelectCallback: setCreateEntryType,
                              direction: Axis.vertical,
                              showDividersOnVerticalAxis: true,
                              items: [
                                LitToggleButtonGroupItemData(
                                    label: "For today", value: 1),
                                LitToggleButtonGroupItemData(
                                    label: "For a previous day", value: 2),
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: _appearAnimationController.duration!,
                            opacity: _appearAnimationController.value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 16.0),
                              child: LitRoundedElevatedButton(
                                  color: HexColor("#8e8e8e"),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 32.0,
                                  ),
                                  child: Text(
                                    "Create for ${createEntryType == 1 ? 'today' : 'previous day'}",
                                    style: LitTextStyles.sansSerif.copyWith(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: _onCreate),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              : LitDatePickerDialog(
                  onBackCallback: () => setSelectedDialogType(1),
                  //selectedDate: _selectedDate,
                  // selectDate: (date) => setState(
                  //   () => {_selectedDate = date},
                  // ),
                  onSubmit: _onSubmit,
                  allowFutureDates: false,
                ),
          IconSnackbar(
            iconData: LitIcons.info,
            text:
                "There already is a entry for ${createEntryType == 1 ? 'today' : 'this day'}.",
            textStyle: LitTextStyles.sansSerif
                .copyWith(color: Colors.white, fontSize: 13.0),
            litSnackBarController: _duplicateSnackBarController,
            alignment: Alignment.topRight,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          ),
        ],
      ),
    );
  }
}
