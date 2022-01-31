part of widgets;

/// A dialog widget allowing the user to change his name.
class ChangeNameDialog extends StatefulWidget {
  /// The user's data.
  final UserData userData;

  /// Creates a [ChangeNameDialog].
  const ChangeNameDialog({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  _ChangeNameDialogState createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  late AppAPI _api;

  /// Controlls the `name` input value.
  late TextEditingController _nameController;

  /// Controlls the text field focus.
  late FocusNode _focusNode;

  /// Returns whether the input is different from the initial value.
  bool get _isChanged {
    print(_nameController.text != widget.userData.name);
    return _nameController.text != widget.userData.name;
  }

  /// Handles the `cancel` action.
  void _onCancel() {
    LitRouteController(context).closeDialog();
  }

  /// Defocuses the text field.
  void _defocus() {
    LitFocusController(context).defocus();
  }

  /// Submits the updated user value.
  void _onSubmit() {
    _api.updateUsername(widget.userData, _nameController.text);
    LitRouteController(context).closeDialog();
  }

  /// Forces to rebuild the widget.
  ///
  /// The validation [_isChanged] requires the widget to rebuild after each
  /// keystroke to ensure the `save` button gets enabled.
  void _forceRebuild() {
    setState(() => {});
  }

  ActionButtonData get _cancelButtonData => ActionButtonData(
        title: LeitmotifLocalizations.of(context).cancelLabel,
        onPressed: _onCancel,
      );

  ActionButtonData get _saveButtonData => ActionButtonData(
        title: LeitmotifLocalizations.of(context).applyLabel,
        accentColor: Color(0xFFEDDEC0),
        backgroundColor: Color(0xFFEAEACA),
        disabled: !_isChanged,
        onPressed: _onSubmit,
      );

  @override
  void initState() {
    super.initState();

    _api = AppAPI();

    _nameController = TextEditingController(
      text: widget.userData.name,
    )..addListener(_forceRebuild);

    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return LitTitledDialog(
      titleText: AppLocalizations.of(context).changeYourNameLabel,
      actionButtons: [
        DialogActionButton(
          data: _cancelButtonData,
        ),
        DialogActionButton(data: _saveButtonData),
      ],
      child: CleanInkWell(
        onTap: _defocus,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: LitEdgeInsets.card,
                child: LitGradientCard(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      16.0,
                    ),
                  ),
                  colors: [
                    Color(0xFFF2ECE1),
                    Color(0xFFEDE7DD),
                  ],
                  boxShadow: LitBoxShadows.md,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 64.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Center(
                        child: _InputField(
                          controller: _nameController,
                          focusNode: _focusNode,
                          userData: widget.userData,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A styled text input widget.
///
/// Implements a [CleanTextField] on top of a colored border.
class _InputField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final UserData userData;
  const _InputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CleanTextField(
          style: LitSansSerifStyles.body1,
          controller: controller,
          focusNode: focusNode,
          maxLines: 1,
        ),
        Container(
          height: 3.0,
          decoration: BoxDecoration(
            color: LitColors.grey300,
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
        ),
        SizedBox(height: 2.0)
      ],
    );
  }
}
