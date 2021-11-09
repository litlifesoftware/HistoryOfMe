import 'package:flutter/material.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/config/config.dart';
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
  late HOMLocalizations _localizationController;
  bool _shouldShowStartupScreen = false;
  bool _initalStartup = false;

  /// The currently inputed username.
  String _username = "";

  /// Create a [HiveDBService] instance to access the database methods.
  HiveDBService _dbService = HiveDBService();

  /// Creates the initial entires on the database required for certain features
  /// on the app.
  void _createInitialEntries() {
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

  /// Handles the privacy confirmation.
  ///
  /// Pushes the [ConfirmAgeScreen] into the navigation stack to enable the
  /// user to input his age.
  ///
  /// Ensure to always push a new Instance of the [ConfirmAgeScreen] to avoid
  /// previous state objects to be unmounted while the widget is still being
  /// displayed.
  void _onPrivacyConfirmed() {
    LitRouteController(context).pushCupertinoWidget(
      // RestoreDiaryScreen(
      //   onCreateNewInstance: () =>
      //       LitRouteController(context).pushCupertinoWidget(
      //     LitVerifyAgeScreen(
      //       onSubmit: _onSubmitAge,
      //       // invalidAgeText: _localizationController.invalidAgeText,
      //       // submitLabel: _localizationController.submit,
      //       // subtitle: _localizationController.confirmYourAgeSubtitle,
      //       // setLabel: _localizationController.setAge,
      //       // title: _localizationController.confirmYourAge,
      //       // validLabel: _localizationController.valid,
      //       // chooseDateLabel: _localizationController.chooseDate,
      //       // yourAgeLabel: _localizationController.yourAge,
      //     ),
      //   ),
      // ),
      LitSignUpScreen(
        // title: _localizationController.whatShallWeCallYou,
        // onSubmitButtonText: _localizationController.thatsMe,
        onSubmit: _handleUserCreation,
        // inputFields: [
        //   LitTextField(
        //     label: _localizationController.yourName,
        //     onChange: _setUsername,
        //     icon: LitIcons.person,
        //   ),
        // ],
        data: [
          TextFieldData(
            label: _localizationController.yourName,
            onChange: _setUsername,
            icon: LitIcons.person,
          ),
        ],
      ),
    );
  }

  /// Handles the actions once the user confirmes his age. To create the actual
  /// user data entry, the user has to provide his name using the
  /// [LitSignUpScreen].
  // void _onSubmitAge(DateTime date) {
  //   LitRouteController(context).replaceCurrentMaterialWidget(
  //     newWidget: LitSignUpScreen(
  //       // title: _localizationController.whatShallWeCallYou,
  //       // onSubmitButtonText: _localizationController.thatsMe,
  //       onSubmit: _handleUserCreation,
  //       // inputFields: [
  //       //   LitTextField(
  //       //     label: _localizationController.yourName,
  //       //     onChange: _setUsername,
  //       //     icon: LitIcons.person,
  //       //   ),
  //       // ],
  //     ),
  //   );
  // }

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
    ).then((_) {
      if (_initalStartup & !DEBUG) {
        _toggleShouldShowStartupScreen();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _localizationController = HOMLocalizations(context);
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
              _createInitialEntries();
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
                    return LitPrivacyDisclaimerScreen(
                      onConfirm: _onPrivacyConfirmed,
                      // titleText: _localizationController.yourDataIsSafe,
                      // descriptionText:
                      //     _localizationController.offlineAppDescription,
                      confirmButtonLabel: _localizationController.okay,
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
