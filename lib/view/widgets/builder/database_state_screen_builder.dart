import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/screens/home_screen.dart';
import 'package:history_of_me/view/screens/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_sign_up_screen.dart';
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
    Key key,
    @required this.localizationsAssetURL,
  }) : super(key: key);
  @override
  _DatabaseStateScreenBuilderState createState() =>
      _DatabaseStateScreenBuilderState();
}

class _DatabaseStateScreenBuilderState
    extends State<DatabaseStateScreenBuilder> {
  /// The currently inputed username.
  String _username;

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

  /// Creates the [UserData] object on the Hive database and pops the
  /// [LitSignUpScreen] from the navigation stack.
  ///
  /// Without popping the screen, it will still be kept inside the
  /// navigation stack because it has been pushed into it.
  void _handleUserCreation() {
    _dbService.createUserData(_username);
    Navigator.pop(context);
  }

  /// Handles the privacy confirmation.
  ///
  /// Pushes the [LitSignUpScreen] into the navigation stack to enable
  /// the user to input his username.
  ///
  /// Note that the [LitSignUpScreen] should be popped again after the
  /// sign up process has been completed.
  void _onPrivacyConfirmed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LitSignUpScreen(
          title: "What shall we call you?",
          usernameLabel:
              LitLocalizations.of(context).getLocalizedValue("your_name"),
          onSubmitButtonText: "THATS ME",
          showPasswordConfirmInput: false,
          showPasswordInput: false,
          showPinInput: false,
          onSubmit: _handleUserCreation,
          onUsernameChange: _setUsername,
        ),
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
