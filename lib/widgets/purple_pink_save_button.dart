part of widgets;

/// A draggable purple pink button showing a [LitIcons.disk] icon as button
/// label.
///
/// It is designed to be used for saving changes.
class PurplePinkSaveButton extends StatelessWidget {
  final bool disabled;
  final void Function() onSaveChanges;

  /// Creates a [PurplePinkSaveButton].
  ///
  /// * [disabled] states whether to hide the button (e.g. if no changes have
  ///   been made).
  ///
  /// * [onSaveChanges] is the 'save' callback triggering the process to write
  ///   to the database.
  const PurplePinkSaveButton({
    Key? key,
    required this.disabled,
    required this.onSaveChanges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !disabled
        ? LitDraggable(
            initialDragOffset: Offset(
              MediaQuery.of(context).size.width - 90.0,
              MediaQuery.of(context).size.height - 156.0,
            ),
            child: LitGradientButton(
              accentColor: const Color(0xFFDE8FFA),
              color: const Color(0xFFFA72AA),
              child: Icon(
                LitIcons.disk,
                size: 28.0,
                color: Colors.white,
              ),
              onPressed: onSaveChanges,
            ),
          )
        : SizedBox();
  }
}
