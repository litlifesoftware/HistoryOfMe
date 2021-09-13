import 'package:flutter/material.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';

import 'change_name_dialog.dart';

/// A widget displaying the user's analytics and basic customization options.
///
/// This includes an user icon, a button allowing to change the username and a
/// card listing the user's statistics.
class UserProfileCard extends StatefulWidget {
  /// The provided [UserData].
  final UserData userData;

  /// A callback to handle the 'on pressed' action.
  final void Function() onPressedUserIcon;

  /// Creates a [UserProfileCard].
  const UserProfileCard({
    Key? key,
    required this.userData,
    required this.onPressedUserIcon,
  }) : super(key: key);
  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  void _showChangeNameDialog() {
    LitRouteController(context).showDialogWidget(ChangeNameDialog(
      userData: widget.userData,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return LitConstrainedSizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserIcon(
              size: 96.0,
              userData: widget.userData,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 22.0,
                bottom: 12.0,
              ),
              child: ClippedText(
                "${widget.userData.name}",
                style: LitSansSerifStyles.h6,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: ClippedText(
                                HOMLocalizations(context).diaryCreated + ":",
                                style: LitSansSerifStyles.caption,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: ClippedText(
                                DateTime.fromMillisecondsSinceEpoch(
                                  widget.userData.created,
                                ).formatAsLocalizedDate(context),
                                style: LitSansSerifStyles.subtitle2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
              child: Align(
                alignment: Alignment.center,
                child: LitRoundedElevatedButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
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
                  child: ClippedText(
                    HOMLocalizations(context).changeName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: LitSansSerifStyles.button,
                  ),
                  onPressed: _showChangeNameDialog,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
