part of controllers;

/// A `controller` class handling autosave events.
///
/// Executes the [saveChanges] methods whenenver the preferred
/// duration has been reached.
class AutosaveController {
  /// Handles the save action.
  final void Function() saveChanges;

  /// The timer's preferred duration.
  final Duration duration;

  /// Creates a [AutosaveController].
  ///
  /// Initializes the autosave timer.
  AutosaveController(
    this.saveChanges, {
    this.duration = defaultDuration,
  }) {
    _init();
  }

  /// The timer's default duration.
  static const defaultDuration = const Duration(seconds: 60);

  /// The timer to handle calling the [saveChanges] method.
  late Timer timer;

  /// Disposes the [AutosaveController] by canceling the timer.
  void dispose() {
    timer.cancel();
  }

  /// Initializes the [AutosaveController].
  void _init() {
    timer = Timer.periodic(
      duration,
      (_) => {
        saveChanges(),
      },
    );
  }
}
