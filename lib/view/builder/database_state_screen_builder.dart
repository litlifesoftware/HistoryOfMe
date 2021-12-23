import 'package:flutter/material.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/model/models.dart';
import 'package:history_of_me/view/screens/RestoreDiaryScreen/restore_diary_screen.dart';
import 'package:history_of_me/view/screens/screens.dart';
import 'package:hive/hive.dart';
import 'package:lit_localization_service/lit_localization_service.dart';
import 'package:leitmotif/leitmotif.dart';

/// A builder widget to return the appropriate screen considering the current
/// database state.
///
/// E.g. if the database is empty, the user should first be prompted to enter
/// his data in order to create a user data entry. This should be done with the
/// related screen allowing the user to enter his details.
class DatabaseStateScreenBuilder extends StatefulWidget {
  final String localizationsAssetURL;

  const DatabaseStateScreenBuilder({
    Key? key,
    required this.localizationsAssetURL,
  }) : super(key: key);
  @override
  _DatabaseStateScreenBuilderState createState() =>
      _DatabaseStateScreenBuilderState();
}

class _DatabaseStateScreenBuilderState
    extends State<DatabaseStateScreenBuilder> {
  final Duration _startupAnimationDuration = const Duration(
    milliseconds: 6000,
  );
  //late HOMLocalizations _localizationController;
  bool _shouldShowStartupScreen = false;
  bool _initalStartup = false;

  /// The currently inputed username.
  String _username = "";

  /// Create a [HiveDBService] instance to access the database methods.
  HiveDBService _dbService = HiveDBService();

  /// Creates the initial entires on the database required for certain features
  /// on the app.
  void _createDefaultData() {
    _dbService.addInitialColors();
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
    _dbService.createUserData(_username);
    _dbService.createAppSettings();
    LitRouteController(context).clearNavigationStack();
    App.restartApp(context);
  }

  /// Shows the app's onboarding screen.
  void _showOnboardingScreen() {
    LitRouteController(context).pushCupertinoWidget(
      AppOnboardingScreen(
        localization: LitOnboardingScreenLocalization(
          title: LeitmotifLocalizations.of(context).onboardingLabel,
          nextLabel: LeitmotifLocalizations.of(context).dismissLabel,
          dismissLabel: AppLocalizations.of(context).continueLabel,
        ),
        onDismiss: _onDismissOnboarding,
      ),
    );
  }

  /// Dismisses the app's onboarding screen and forwards the user to the
  /// sign up screen.
  void _onDismissOnboarding() {
    LitRouteController(context).pushCupertinoWidget(
      LitSignUpScreen(
        onSubmit: _handleUserCreation,
        data: [
          TextFieldData(
            label: AppLocalizations.of(context).yourNameLabel,
            onChange: _setUsername,
            icon: LitIcons.person,
          ),
        ],
      ),
    );
  }

  Future<int> _initData() async {
    await LitLocalizationController()
        .initLocalizations(widget.localizationsAssetURL);
    return await _dbService.openBoxes();
  }

  void _toggleShouldShowStartupScreen() {
    setState(() {
      _shouldShowStartupScreen = !_shouldShowStartupScreen;
    });
  }

  void _showStartupScreen() {
    _toggleShouldShowStartupScreen();
    Future.delayed(
      _startupAnimationDuration,
    ).then(
      (_) {
        if (_initalStartup & !DEBUG) {
          _toggleShouldShowStartupScreen();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //_localizationController = HOMLocalizations(context);
    _showStartupScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initData(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if ((snapshot.connectionState == ConnectionState.done)) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            // If the snapshot has finished loading (listen for value of 0).
            if (snapshot.data == 0) {
              // Create the initial database entries,
              // but do nothing if there alredy are entires.
              _createDefaultData();
            }
            // Ensure the user data has been set on the database, otherwise
            // return the privacy screen and sign up screen.
            return ValueListenableBuilder(
              valueListenable: _dbService.getUserData(),
              builder: (BuildContext context, Box<UserData> userData, _) {
                if (userData.isEmpty) {
                  _initalStartup = true;
                  // Show the startup screen only on the first app start.
                  if (_shouldShowStartupScreen && !DEBUG) {
                    return LitStartupScreen(
                      animationDuration: _startupAnimationDuration,
                    );
                  } else {
                    return RestoreDiaryScreen(
                      onCreateNewInstance: _showOnboardingScreen,
                    );
                  }
                } else {
                  return HomeScreen();
                }
              },
            );
          }
          // Return a loading screen as long as the boxes are being opened.
        } else {
          return SplashScreen();
        }
      },
    );
  }
}
