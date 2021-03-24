import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/routes/screen_router.dart';
import 'package:history_of_me/lit_ui_kit_temp/lit_bubble_button.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/shared/bookmark_back_preview.dart';
import 'package:history_of_me/view/widgets/shared/bookmark_front_preview.dart';
import 'package:history_of_me/view/widgets/profile_screen/settings_footer.dart';
import 'package:history_of_me/view/widgets/profile_screen/statistics_card.dart';
import 'package:hive/hive.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  ScreenRouter _screenRouter;
  ScrollController _scrollController;

  void _onEditBookmark(UserData userData) {
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
    _screenRouter = ScreenRouter(context);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return LitScaffold(
      appBar: FixedOnScrollAppbar(
        scrollController: _scrollController,
        backgroundColor: Colors.white,
        child: Center(
          child: ClippedText(
            "How are you today?",
            textAlign: TextAlign.center,
            style: LitTextStyles.sansSerif.copyWith(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: HiveDBService().getUserData(),
              builder:
                  (BuildContext context, Box<dynamic> userDataBox, Widget _) {
                UserData userData = userDataBox.getAt(0) as UserData;
                return ScrollableColumn(
                  controller: _scrollController,
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            IndexedPageView(
                              height: 180.0,
                              indicatorSpacingTop: 0.0,
                              children: [
                                BookmarkFrontPreview(
                                  userData: userData,
                                  padding: const EdgeInsets.only(
                                    top: 16.0,
                                    left: 16.0,
                                    right: 32.0,
                                  ),
                                ),
                                BookmarkBackPreview(
                                  userData: userData,
                                  padding: const EdgeInsets.only(
                                    top: 32.0,
                                    left: 32.0,
                                    right: 32.0,
                                  ),
                                ),
                              ],
                              indicatorColor: LitColors.mediumGrey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 160.0,
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: isPortraitMode(
                                          MediaQuery.of(context).size)
                                      ? MediaQuery.of(context).size.width
                                      : MediaQuery.of(context).size.width / 2,
                                  child: Align(
                                    alignment: isPortraitMode(
                                            MediaQuery.of(context).size)
                                        ? Alignment.centerRight
                                        : Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: LitBubbleButton(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 12.0),
                                          child: Icon(
                                            LitIcons.pencil,
                                            color: Colors.white,
                                            size: 20.0,
                                          ),
                                        ),
                                        onPressed: () =>
                                            _onEditBookmark(userData),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatisticsCard(),
                    SettingsFooter(
                      userData: userData,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
