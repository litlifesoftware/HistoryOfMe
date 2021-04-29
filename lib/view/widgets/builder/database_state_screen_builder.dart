import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/screens/home_screen.dart';
import 'package:history_of_me/view/screens/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:lit_localization_service/lit_localization_service.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

/// A builder widget to return the appropriate screen considering the current database
/// state.
///
/// E.g. if the database is empty, the user should first be prompted to enter his data
/// in order to create a user data entry. This should be done with the related screen
/// allowing the user to enter his details.
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
  /// The currently inputed username.
  String _username = "";

  /// Create a [HiveDBService] instance to access the database methods.
  HiveDBService _dbService = HiveDBService();

  /// Creates the initial entires on the database required for certain features on the app.
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

  /// Creates the [UserData] object on the Hive database and pops all currently
  /// visible screen widgets to avoid leaking memory issues.
  void _handleUserCreation() {
    _dbService.createUserData(_username);
    LitRouteController(context).clearNavigationStack();
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
      ConfirmAgeScreen(onSubmit: _onSubmitAge),
    );
  }

  /// Handles the actions once the user confirmes his age. To create the actual
  /// user data entry, the user has to provide his name using the
  /// [LitSignUpScreen].
  void _onSubmitAge() {
    LitRouteController(context).replaceCurrentMaterialWidget(
      newWidget: LitSignUpScreen(
        title: "What shall we call you?",
        usernameLabel:
            LitLocalizations.of(context)!.getLocalizedValue("your_name"),
        onSubmitButtonText: "THATS ME",
        showPasswordConfirmInput: false,
        showPasswordInput: false,
        showPinInput: false,
        onSubmit: _handleUserCreation,
        onUsernameChange: _setUsername,
      ),
    );
  }

  Future<int> _initData() async {
    await LitLocalizationController()
        .initLocalizations(widget.localizationsAssetURL);
    return await _dbService.openBoxes();
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
            // Ensure the user data has been set on the database, otherwise return
            // the privacy screen and sign up screen.
            return ValueListenableBuilder(
              valueListenable: _dbService.getUserData(),
              builder: (BuildContext context, Box<UserData> userData, _) {
                if (userData.isEmpty) {
                  // return LitOfflineAppDisclaimerScreen(
                  //   onConfirm: _onPrivacyConfirmed,
                  // );
                  return LitOfflineAppDisclaimerScreen(
                    onConfirm: _onPrivacyConfirmed,
                  );
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
