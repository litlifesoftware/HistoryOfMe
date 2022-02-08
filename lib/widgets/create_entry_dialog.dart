part of widgets;

/// The today indicator.
const int TODAY = 1;

/// The previous day indicator.
const int PREVIOUS_DAY = 2;

/// The future day indicator.
const int FUTURE_DAY = 3;

/// A `History of Me` widget allowing to either create an entry for today or to
/// create an entry for a specific date.
///
/// Handles future date input by letting the user confirm his provided date.
class CreateEntryDialog extends StatefulWidget {
  static const appearAnimationDuration = Duration(milliseconds: 140);
  @override
  _CreateEntryDialogState createState() => _CreateEntryDialogState();
}

class _CreateEntryDialogState extends State<CreateEntryDialog>
    with TickerProviderStateMixin {
  /// The api instance.
  late AppAPI _api;

  /// The appear animation's controller.
  late AnimationController _appearAnimationController;

  /// The screen router to switch to the newly created entry's editing
  /// screen.
  late HOMNavigator _screenRouter;

  /// Snackbar controller to show a message once the user tries to create an
  /// already existing date.
  late LitSnackbarController _duplicateSnackBarController;

  /// States the currently selected future date.
  ///
  /// This date must be tracked outside the as it is provided by the date picker
  /// which will then be disposed.
  DateTime? _selectedFutureDate;

  /// The currently selected entry type.
  int _createEntryType = TODAY;

  /// The currently selected dialog type. It's value will depend on the
  /// selected entry type.
  int _selectedDialogType = TODAY;

  /// Sets the currently selected entry type.
  void setCreateEntryType(int value) {
    setState(() {
      _createEntryType = value;
    });
    if (!(value == _createEntryType)) {
      _appearAnimationController.forward(from: 0);
    }
  }

  /// Sets the currently selected dialog type.
  void setSelectedDialogType(int value) {
    setState(() {
      _selectedDialogType = value;
    });
  }

  /// Closes the currently displayed dialog.
  void _closeDialog() {
    LitRouteController(context).closeDialog();
  }

  /// Creates a diary entry for today.
  ///
  /// If today's diary entry already exists, the snackbar will be shown
  /// stating that the creation was not successful.
  void _addDiaryEntry({DateTime? selected}) {
    DateTime date = selected ?? DateTime.now();

    if (_api.entryWithDateDoesExist(date)) {
      _duplicateSnackBarController.showSnackBar();
      return;
    }

    DiaryEntry createdEntry = _api.addDiaryEntry(
      date: DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );
    _closeDialog();
    _screenRouter.toEntryEditingScreen(
      diaryEntry: createdEntry,
    );
  }

  /// Handles the `submit` action when selecting a date.
  ///
  /// Adds a new diary entry if the date is in the past or asks the user to
  /// confirm the date if the date is in the future.
  void _onSubmitDate(DateTime date) async {
    DateTime now = DateTime.now();

    if (date.isBefore(now)) {
      _addDiaryEntry(selected: date);
      return;
    }

    if (date.isAfter(now)) {
      setState(() {
        _selectedDialogType = FUTURE_DAY;
        _selectedFutureDate = date;
      });
      return;
    }

    setState(() {
      _selectedDialogType = PREVIOUS_DAY;
    });
  }

  /// Handles the 'on create' button press.
  void _onCreate() {
    if (_createEntryType == TODAY) {
      _addDiaryEntry();
    } else {
      setSelectedDialogType(PREVIOUS_DAY);
    }
  }

  /// Returns the snack bar text.
  String get _snackbarText {
    switch (_createEntryType) {
      case TODAY:
        return AppLocalizations.of(context).duplicateEntryTodayDescr;
      case PREVIOUS_DAY:
        return AppLocalizations.of(context).duplicateEntryDescr;
      default:
        return "";
    }
  }

  /// Returns the dialog widget according the current [_selectedDialogType]
  /// state.
  Widget get _dialog {
    // Show the create entry dialog.
    if (_selectedDialogType == TODAY)
      return _SelectDateTypeDialog(
        animationController: _appearAnimationController,
        createEntryType: _createEntryType,
        onCreate: _onCreate,
        setCreateEntryType: setCreateEntryType,
      );
    // Show the date picker dialog.
    if (_selectedDialogType == PREVIOUS_DAY)
      return LitDatePickerDialog(
        onSubmit: _onSubmitDate,
      );
    // Show the confirm future date dialog.
    if (_selectedDialogType == FUTURE_DAY && _selectedFutureDate != null) {
      return _ConfirmFutureDateDialog(
        onCancel: () => setState(
          () => _selectedDialogType = PREVIOUS_DAY,
        ),
        onCreate: () => _addDiaryEntry(
          selected: _selectedFutureDate,
        ),
      );
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();
    _screenRouter = HOMNavigator(context);
    _api = AppAPI();
    _duplicateSnackBarController = LitSnackbarController()..init(this);
    _appearAnimationController = AnimationController(
      duration: CreateEntryDialog.appearAnimationDuration,
      vsync: this,
    )..forward();
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
          _dialog,
          LitIconSnackbar(
            iconData: LitIcons.info,
            title: AppLocalizations.of(context).alreadyAvailableLabel,
            text: _snackbarText,
            snackBarController: _duplicateSnackBarController,
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }
}

/// A `History of Me` dialog widget allowing the user to either create a diary
/// entry for today or to select a specific date for the diary entry.
class _SelectDateTypeDialog extends StatefulWidget {
  final AnimationController animationController;
  final int createEntryType;
  final void Function() onCreate;
  final void Function(int) setCreateEntryType;

  /// Creates a [_SelectDateTypeDialog].
  const _SelectDateTypeDialog({
    Key? key,
    required this.animationController,
    required this.createEntryType,
    required this.onCreate,
    required this.setCreateEntryType,
  }) : super(key: key);

  @override
  _SelectDateTypeDialogState createState() => _SelectDateTypeDialogState();
}

class _SelectDateTypeDialogState extends State<_SelectDateTypeDialog> {
  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: AppLocalizations.of(context).createEntryLabel.capitalize(),
      child: Column(
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
                  label: LeitmotifLocalizations.of(context)
                      .todayLabel
                      .capitalize(),
                  value: TODAY,
                ),
                LitToggleButtonGroupItemData(
                  label: LeitmotifLocalizations.of(context)
                      .anotherDayLabel
                      .capitalize(),
                  value: PREVIOUS_DAY,
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: widget.animationController,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
              child: LitRoundedElevatedButton(
                color: LitColors.grey200,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 32.0,
                ),
                child: Text(
                  AppLocalizations.of(context).createLabel.toUpperCase(),
                  style: LitSansSerifStyles.button,
                ),
                onPressed: widget.onCreate,
              ),
            ),
            builder: (BuildContext context, Widget? child) {
              return AnimatedOpacity(
                duration: widget.animationController.duration!,
                opacity: widget.animationController.value,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A `History of Me` dialog widget allowing the user to confirm to add a diary
/// entry for a future date.
class _ConfirmFutureDateDialog extends StatelessWidget {
  /// Handles the `cancel` action.
  final void Function() onCancel;

  /// Handles the `create` action.
  final void Function() onCreate;

  /// Creates a [_ConfirmFutureDateDialog].
  const _ConfirmFutureDateDialog({
    Key? key,
    required this.onCancel,
    required this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      child: Padding(
        padding: LitEdgeInsets.dialogMargin,
        child: Column(
          children: [
            LitDescriptionTextBox(
              maxLines: 4,
              text: AppLocalizations.of(context).futureDateDescr,
            ),
            SizedBox(height: LitEdgeInsets.dialogMargin.top),
            Text(
              AppLocalizations.of(context).futureDateActionDescr,
              style: LitSansSerifStyles.caption,
            ),
          ],
        ),
      ),
      titleText: AppLocalizations.of(context).confirmDateLabel,
      actionButtons: [
        DialogActionButton(
          data: ActionButtonData(
            accentColor: LitColors.grey300,
            backgroundColor: LitColors.grey300,
            title: LeitmotifLocalizations.of(context).cancelLabel,
            onPressed: onCancel,
          ),
        ),
        DialogActionButton(
          data: ActionButtonData(
            title: LeitmotifLocalizations.of(context).createLabel,
            onPressed: onCreate,
          ),
        ),
      ],
    );
  }
}
