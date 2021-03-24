import 'package:flutter/material.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_plain_label_button.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_settings_footer.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/screens/intro_screen.dart';
import 'package:history_of_me/view/widgets/profile_screen/change_name_dialog.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class SettingsFooter extends StatefulWidget {
  final UserData userData;

  const SettingsFooter({
    Key key,
    @required this.userData,
  }) : super(key: key);
  @override
  _SettingsFooterState createState() => _SettingsFooterState();
}

class _SettingsFooterState extends State<SettingsFooter> {
  LitRouteController _routeController;
  void _showAboutThisAppDialog() {}

  void _openPrivacyPolicy() {}

  void _openDeveloperProfile() {}

  void _showDeleteDataDialog() {}

  void _showChangeNameDialog() {
    _routeController.showDialogWidget(ChangeNameDialog(
      userData: widget.userData,
    ));
  }

  void _takeTour() {
    LitRouteController(context).pushMaterialWidget(
      IntroScreen(
        onStartCallback: LitRouteController(context).navigateBack,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _routeController = LitRouteController(context);
  }

  @override
  Widget build(BuildContext context) {
    return LitSettingsFooter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: LitRoundedElevatedButton(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 16.0,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 13.0,
                  color: Colors.black12,
                  offset: Offset(-1, 1),
                  spreadRadius: 1.0,
                )
              ],
              color: LitColors.mintGreen,
              child: Text(
                "Change name",
                style: LitTextStyles.sansSerif.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              onPressed: _showChangeNameDialog,
            ),
          ),
          LitPlainLabelButton(
            label: "Take the tour",
            onPressed: _takeTour,
            textAlign: TextAlign.center,
          ),
          LitPlainLabelButton(
            label: "About this app",
            onPressed: _showAboutThisAppDialog,
            textAlign: TextAlign.center,
          ),
          LitPlainLabelButton(
            label: "View Privacy",
            onPressed: _openPrivacyPolicy,
            textAlign: TextAlign.center,
          ),
          LitPlainLabelButton(
            label: "Delete all data",
            onPressed: _showDeleteDataDialog,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
