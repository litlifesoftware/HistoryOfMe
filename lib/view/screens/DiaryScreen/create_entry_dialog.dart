import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/routes/screen_router.dart';
import 'package:history_of_me/view/shared/lit_toggle_button_group.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:intl/intl.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// The today indicator.
const int TODAY = 1;

/// The previous day indicator.
const int PREVIOUS_DAY = 2;

/// A dialog enabling the user to either create a diary entry for today or a
/// previous day using the [LitDatePickerDialog].
class CreateEntryDialog extends StatefulWidget {
  @override
  _CreateEntryDialogState createState() => _CreateEntryDialogState();
}

class _CreateEntryDialogState extends State<CreateEntryDialog>
    with TickerProviderStateMixin {
  /// The screen router to switch to the newly created entry's editing
  /// screen.
  late ScreenRouter _screenRouter;
  late AnimationController _appearAnimationController;

  /// Snackbar controller to show a message once the user tries to create an
  /// already existing date.
  late LitSnackbarController _duplicateSnackBarController;

  /// The currently selected entry type.
  int createEntryType = TODAY;

  /// The currently selected dialog type. It's value will depend on the
  /// selected entry type.
  int selectedDialogType = TODAY;

  /// Sets the currently selected entry type.
  void setCreateEntryType(int value) {
    setState(() {
      createEntryType = value;
    });
    if (!(value == createEntryType)) {
      _appearAnimationController.forward(from: 0);
    }
  }

  /// Sets the currently selected dialog type.
  void setSelectedDialogType(int value) {
    setState(() {
      selectedDialogType = value;
    });
  }

  /// Closes the currently displayed dialog.
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

  /// Creates a diary entry for today.
  ///
  /// If today's diary entry already exists, the snackbar will be shown
  /// stating that the creation was not successful.
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
      _duplicateSnackBarController.showSnackBar();
    }
  }

  /// Creates a diary entry for the provided date.
  void _createPreviousDayEntry(DateTime date) {
    HiveDBService service = HiveDBService();

    if (!service.entryWithDateDoesExist(date)) {
      DiaryEntry createdEntry = service.addDiaryEntry(date: date);
      _closeDialog();

      _screenRouter.toEntryEditingScreen(diaryEntry: createdEntry);
    } else {
      _duplicateSnackBarController.showSnackBar();
    }
  }

  /// Handles the 'on create' button press.
  void _onCreate() {
    if (createEntryType == TODAY) {
      _createTodaysEntry();
    } else {
      setSelectedDialogType(PREVIOUS_DAY);
    }
  }

  String get _snackbarText {
    switch (createEntryType) {
      case TODAY:
        return "There already is a entry for today.";
      case PREVIOUS_DAY:
        return "There already is a entry for your selected day.";
      default:
        return "";
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
          selectedDialogType == TODAY
              ? DefaultCreateEntryDialog(
                  animationController: _appearAnimationController,
                  createEntryType: createEntryType,
                  onCreate: _onCreate,
                  setCreateEntryType: setCreateEntryType,
                )
              : LitDatePickerDialog(
                  onBackCallback: () => setSelectedDialogType(TODAY),
                  onSubmit: _createPreviousDayEntry,
                  allowFutureDates: false,
                ),
          IconSnackbar(
            iconData: LitIcons.info,
            text: _snackbarText,
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

/// The default 'create entry' dialog showing the options to create a diary
/// entry for today or to select the 'previous day' date picker dialog.
class DefaultCreateEntryDialog extends StatefulWidget {
  final AnimationController animationController;
  final int createEntryType;
  final void Function(int) setCreateEntryType;
  final void Function() onCreate;
  const DefaultCreateEntryDialog({
    Key? key,
    required this.animationController,
    required this.createEntryType,
    required this.setCreateEntryType,
    required this.onCreate,
  }) : super(key: key);

  @override
  _DefaultCreateEntryDialogState createState() =>
      _DefaultCreateEntryDialogState();
}

class _DefaultCreateEntryDialogState extends State<DefaultCreateEntryDialog> {
  String get _buttonLabel {
    switch (widget.createEntryType) {
      case TODAY:
        return "Create for today";
      case PREVIOUS_DAY:
        return "Create for a previous day";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: "Add a diary entry",
      child: AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget? _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: LitToggleButtonGroup(
                  selectedValue: widget.createEntryType,
                  onSelectCallback: widget.setCreateEntryType,
                  direction: Axis.vertical,
                  showDividersOnVerticalAxis: true,
                  items: [
                    LitToggleButtonGroupItemData(
                      label: "For today",
                      value: TODAY,
                    ),
                    LitToggleButtonGroupItemData(
                      label: "For a previous day",
                      value: PREVIOUS_DAY,
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: widget.animationController.duration!,
                opacity: widget.animationController.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                  child: LitRoundedElevatedButton(
                    color: HexColor("#8e8e8e"),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 32.0,
                    ),
                    child: Text(
                      _buttonLabel,
                      style: LitTextStyles.sansSerif.copyWith(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: widget.onCreate,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
