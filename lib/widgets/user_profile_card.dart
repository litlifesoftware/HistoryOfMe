part of widgets;

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
  /// Shows the [ChangeNameDialog] widgets.
  void _showChangeNameDialog() {
    LitRouteController(context).showDialogWidget(
      ChangeNameDialog(
        userData: widget.userData,
      ),
    );
  }

  /// Returns a localized date string based the provided `created` timestamp.
  String get localizedCreatedLabel => DateTime.fromMillisecondsSinceEpoch(
        widget.userData.created,
      ).formatAsLocalizedDate(context);

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
              onPressed: widget.onPressedUserIcon,
            ),
            Padding(
              padding: LitEdgeInsets.card,
              child: ClippedText(
                widget.userData.name,
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
                                LeitmotifLocalizations.of(context)
                                    .createdOnLabel,
                                style: LitSansSerifStyles.caption,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: ClippedText(
                                localizedCreatedLabel,
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
                child: LitPushedThroughButton(
                  backgroundColor: LitColors.green100,
                  accentColor: LitColors.green200,
                  child: ClippedText(
                    AppLocalizations.of(context).changeNameLabel.toUpperCase(),
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
