part of widgets;

/// A builder widget returning the appropriate screen considering the current
/// database state.
///
/// E.g. if the database is empty, the user should first be prompted to enter
/// his name in order to create a user data entry.
class DatabaseStateScreenBuilder extends StatefulWidget {
  @override
  _DatabaseStateScreenBuilderState createState() =>
      _DatabaseStateScreenBuilderState();
}

class _DatabaseStateScreenBuilderState
    extends State<DatabaseStateScreenBuilder> {
  bool _showSplashScreen = false;
  bool _initalStartup = false;

  /// The currently inputed username.
  String _username = "";

  /// Create a [AppAPI] instance to access the database methods.
  AppAPI _api = AppAPI();

  /// Creates the initial entires on the database required for certain features
  /// on the app.
  void _createDefaultData() {
    _api.addInitialColors();
  }

  /// Sets the [_username] value using the provided argument value.
  ///
  /// Setting the state (setState) will not be required due to the
  /// value only being stored to be used on the backend.
  void _setUsername(String input) {
    _username = input;
  }

  /// Creates the initial [UserData] and [AppSettings] .
  ///
  /// Clearing the navigation stack will be done using a setState method to
  /// ensure the view will be rebuild. This is is required to mount the new
  /// widget tree correctly.
  void _handleUserCreation() {
    _api.createUserData(_username);
    _api.createAppSettings();
    LitRouteController(context).clearNavigationStack();
    App.restartApp(context);
  }

  /// Shows the app's onboarding screen.
  void _showOnboardingScreen() {
    LitRouteController(context).pushCupertinoWidget(
      _OnboardingScreen(
        onDismiss: _onDismissOnboarding,
      ),
    );
  }

  /// Dismisses the app's onboarding screen and forwards the user to the
  /// sign up screen.
  void _onDismissOnboarding() {
    LitRouteController(context).pushCupertinoWidget(
      _SignInScreen(
        handleUserCreation: _handleUserCreation,
        setUsername: _setUsername,
      ),
    );
  }

  Future<int> _initData() async {
    return await _api.openBoxes();
  }

  void _toggleShouldShowStartupScreen() {
    setState(() {
      _showSplashScreen = !_showSplashScreen;
    });
  }

  void _showStartupScreen() {
    _toggleShouldShowStartupScreen();
    Future.delayed(
      LitStartupScreen.backgroundAnimationDuration,
    ).then(
      (_) {
        if (_initalStartup & !App.DEBUG) {
          _toggleShouldShowStartupScreen();
        }
      },
    );
  }

  /// Returns the corresponding screen widget according to the current state
  /// on the database.
  Widget _buildScreens(BuildContext context, UserData? userData) {
    // If user data not present (first app startup)
    if (userData == null) {
      _initalStartup = true;

      if (_showSplashScreen && !App.DEBUG) {
        // Show the startup screen
        return _StartupScreen();
      }

      // Otherwise initiate the restore process.
      return RestoreDiaryScreen(
        onCreateNewInstance: _showOnboardingScreen,
      );
    }

    /// Show the home screen by default (user data present)
    return HomeScreen();
  }

  @override
  void initState() {
    super.initState();
    _showStartupScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initData(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        // Return a splash screen while ressources are loading
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return SplashScreen();
        }

        // Show an error message, once loading failed
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        // If the snapshot has finished loading (listen for value of 0).
        if (snapshot.data == 0) {
          // Create the initial database entries,
          // but do nothing if there alredy are entires.
          _createDefaultData();
        }

        // Ensure the user data has been set on the database, otherwise
        // return the privacy screen and sign up screen.
        return UserDataProvider(
          builder: _buildScreens,
        );
      },
    );
  }
}

/// Returns the [AppOnboardingScreen].
class _OnboardingScreen extends StatelessWidget {
  final void Function() onDismiss;
  const _OnboardingScreen({
    Key? key,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppOnboardingScreen(onDismiss: onDismiss);
  }
}

/// Returns a customized [LitSignUpScreen].
class _SignInScreen extends StatelessWidget {
  final void Function() handleUserCreation;
  final void Function(String) setUsername;
  const _SignInScreen({
    Key? key,
    required this.handleUserCreation,
    required this.setUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitSignUpScreen(
      onSubmit: handleUserCreation,
      data: [
        TextFieldData(
          label: AppLocalizations.of(context).yourNameLabel,
          onChange: setUsername,
          icon: LitIcons.person,
        ),
      ],
    );
  }
}

/// Returns a customized [LitStartupScreen].
class _StartupScreen extends StatelessWidget {
  const _StartupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LitStartupScreen();
  }
}
