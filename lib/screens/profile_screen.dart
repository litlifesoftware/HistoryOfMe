import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/controllers.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

class ProfileScreen extends StatefulWidget {
  final AnimationController bookmarkAnimation;

  const ProfileScreen({
    Key? key,
    required this.bookmarkAnimation,
  }) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late HOMNavigator _screenRouter;
  late ScrollController _scrollController;
  late LitSnackbarController _snackbarController;

  void _onEditBookmark(UserData? userData) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => BookmarkEditingScreen(
    //       initialUserDataModel: userData,
    //     ),
    //   ),
    // );
    _screenRouter.toBookmarkEditingScreen(userData: userData);
  }

  @override
  void initState() {
    super.initState();
    _screenRouter = HOMNavigator(context);
    _scrollController = ScrollController();
    _snackbarController = LitSnackbarController();
  }

  @override
  Widget build(BuildContext context) {
    return AllDataProvider(
      builder: (
        context,
        appSettings,
        userData,
        diaryEntries,
        userCreatedColors,
      ) {
        return LitScaffold(
          appBar: FixedOnScrollAppbar(
            scrollController: _scrollController,
            backgroundColor: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClippedText(
                  AppLocalizations.of(context).customizeBookmarkTitle,
                  maxLines: 1,
                ),
                LitBubbleButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 12.0,
                    ),
                    child: Icon(
                      LitIcons.pencil,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  onPressed: () => _onEditBookmark(userData),
                )
              ],
            ),
            requiredOffset: 92.0,
          ),
          snackbars: [
            LitIconSnackbar(
              snackBarController: _snackbarController,
              title: userData!.name,
              text: AppLocalizations.of(context).welcomeBackLabel +
                  ", " +
                  userData.name +
                  "!",
              iconData: LitIcons.diary,
            ),
          ],
          body: SafeArea(
            child: LitScrollbar(
              child: ScrollableColumn(
                controller: _scrollController,
                children: [
                  Stack(
                    children: [
                      BookmarkPageView(
                        animationController: widget.bookmarkAnimation,
                        userData: userData,
                        padding: const EdgeInsets.only(
                          top: 0,
                          bottom: 32.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                      ),
                      _EditBookmarkButton(
                        onPressed: () => _onEditBookmark(userData),
                      ),
                    ],
                  ),
                  UserProfileCard(
                    userData: userData,
                    onPressedUserIcon: () => _snackbarController.showSnackBar(),
                  ),
                  StatisticsCard(),
                  SettingsFooter(
                    userData: userData,
                    appSettings: appSettings,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A button allowing displayed on top of the bookmark to allow its editing.
class _EditBookmarkButton extends StatelessWidget {
  final void Function() onPressed;

  /// Creates a [_EditBookmarkButton].
  const _EditBookmarkButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 160.0,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: isPortraitMode(MediaQuery.of(context).size)
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width / 2,
          child: Align(
            alignment: isPortraitMode(MediaQuery.of(context).size)
                ? Alignment.centerRight
                : Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: LitBubbleButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 12.0,
                  ),
                  child: Icon(
                    LitIcons.pencil,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
