import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/focus_controller.dart';

/// The [LitRouteController] enables navigation between multiple screens without the
/// need to specify a particular [PageRoute] on every navigation as it is done by
/// using [Navigator.push]. Pushing the [PageRoute] into the widget stack is done
/// by calling the either [pushCupertinoWidget]
class LitRouteController {
  final BuildContext context;
  const LitRouteController(this.context);

  /// Request the focus to collapse the soft keyboard.
  void resetFocus() {
    FocusController(context).defocus();
  }

  /// Pop the latest added [Widget] from the widget stack, enabling the user to
  /// navigate back.
  void pop() {
    if (Navigator.of(context).canPop()) {
      resetFocus();
      Navigator.of(context).pop();
    }
  }

  /// Shows the provided dialog [Widget].
  void showDialogWidget(Widget dialog) {
    showDialog(
      context: context,
      builder: (_) => dialog,
    );
  }

  /// Closes the currently displayed [Dialog], by popping it from the widget tree.
  void closeDialog() {
    pop();
  }

  /// Navigates back to the previous screen.
  void navigateBack() {
    pop();
  }

  /// Closes the displayed dialog and navigates back to the previous screen by popping
  /// the lastest two widgets from the stack.
  ///
  /// This method can be executed once the user wants to navigate back despite having
  /// a dialog shown on the screen. This can be implemented to navigate back to the
  /// previous screen after confirming a discard of user input using a prompt dialog.
  void dicardAndExit() {
    closeDialog();
    navigateBack();
  }

  /// Navigates to another screen by pushing the provided widget into the widget stack
  /// using the [MaterialPageRoute] animation.
  void pushCupertinoWidget(Widget pushedWidget) {
    resetFocus();

    /// Navigate to another widget by pushing it to
    /// the stack.
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => pushedWidget,
      ),
    );
  }

  /// Navigates to another screen by pushing the provided widget into the widget stack
  /// using the [MaterialPageRoute] animation.
  void pushMaterialWidget(Widget pushedWidget) {
    resetFocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pushedWidget,
      ),
    );
  }

  /// Navigate to another screen and remove the latest (current) [Widget] from the stack.
  /// This can be done to avoid multiple screens stacking up and to avoid the need of
  /// tapping the back button multiple times to e.g. go back to the home screen.
  void replaceCurrentWidget({
    @required Widget newWidget,
  }) {
    resetFocus();
    // Check if replacing the current [Widget] is even possible by checking if the widget
    // can be popped. If not the HomeScreen widget would be replaced with the pushed widget.
    if (Navigator.of(context).canPop()) {
      // Replace the widget.
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (BuildContext context) => newWidget));
    } else {
      // If there is no room for replacing the
      // widget, push it.
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => newWidget,
        ),
      );
    }
  }
}
