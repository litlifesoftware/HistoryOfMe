import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/controller/database/hive_query_controller.dart';
import 'package:history_of_me/lit_route_controller/focus/route_controller.dart';
import 'package:history_of_me/lit_ui_kit_temp/exclamation_rectangle.dart';
import 'package:history_of_me/model/diary_entry.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:history_of_me/view/widgets/shared/bookmark_front_preview.dart';
import 'package:history_of_me/view/widgets/diary_screen/create_entry_dialog.dart';
import 'package:history_of_me/view/widgets/diary_screen/diary_list_view.dart';
import 'package:history_of_me/view/widgets/shared/purple_pink_button.dart';
import 'package:hive/hive.dart';
import 'package:lit_localization_service/lit_localization_service.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';

class DiaryScreen extends StatefulWidget {
  /// Creates a [DiaryScreen].
  ///
  /// Specify the [actionButtonAccentColorMixer] and [actionButtonMainColorMixer]
  /// to change how the action button's color are generated using the [UserData]'s
  /// bookmark color.
  const DiaryScreen({
    Key? key,
  }) : super(key: key);
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with TickerProviderStateMixin {
  late LitRouteController _routeController;
  ScrollController? _scrollController;
  bool? _showFavoriteEntriesOnly;

  AnimationController? _listViewAnimation;

  late AnimationController _animateLabelOnScroll;

  void _showCreateEntryDialog() {
    _routeController.showDialogWidget(CreateEntryDialog());
    //createDummyUserData();
  }

  /// Toggles the [_showFavoriteEntriesOnly] state value while replaying the animation controller
  /// to animate the list view tiles again.
  void toggleShowFavoritesOnly() {
    setState(() {
      _showFavoriteEntriesOnly = !_showFavoriteEntriesOnly!;
    });
    //_animationController.reverse().then((_) => _animationController.forward());
  }

  List<DiaryEntry> _getDiaryEntriesSorted(Box entriesBox) {
    return entriesBox.values.toList() as List<DiaryEntry>
      ..sort(HiveQueryController().sortEntriesByDateAscending);
  }

  void _animateButtonOnScroll() {
    const double threshold = 125.0;
    if (_scrollController!.offset > 0.0) {
      if (_scrollController!.offset < threshold) {
        if (!_animateLabelOnScroll.isAnimating) {
          _animateLabelOnScroll.reverse();
        }
      }
    } else {
      if (!_animateLabelOnScroll.isAnimating) {
        _animateLabelOnScroll.forward();
      }
    }
  }

  @override
  void initState() {
    _showFavoriteEntriesOnly = false;
    _scrollController = ScrollController()..addListener(_animateButtonOnScroll);
    _listViewAnimation =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animateLabelOnScroll =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _routeController = LitRouteController(context);
    _animateLabelOnScroll.forward();
    super.initState();
  }

  @override
  void dispose() {
    _listViewAnimation!.dispose();
    _animateLabelOnScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(DateTime.now().millisecondsSinceEpoch.toRadixString(16));
    return LitScaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: HiveDBService().getUserData(),
          builder: (BuildContext context, Box<UserData> userDataBox, Widget? _) {
            print("user data box length: ${userDataBox.length}");
            // Hive-retrieved user data object.
            //
            // Initialize using fallback constant object if there isn't an entry
            // in the database.
            final UserData? userData = userDataBox.getAt(0);
            return ValueListenableBuilder(
              valueListenable: HiveDBService().getDiaryEntries(),
              builder:
                  (BuildContext context, Box<DiaryEntry> entriesBox, Widget? _) {
                // Diary entries sorted ascending.
                List<DiaryEntry> diaryEntriesListSorted =
                    _getDiaryEntriesSorted(entriesBox);
                return diaryEntriesListSorted.isNotEmpty
                    ? Stack(
                        children: [
                          DiaryListView(
                            animationController: _listViewAnimation,
                            diaryEntriesListSorted: diaryEntriesListSorted,
                            scrollController: _scrollController,
                            showFavoriteEntriesOnly: _showFavoriteEntriesOnly,
                            toggleShowFavoritesOnly: toggleShowFavoritesOnly,
                            userData: userData,
                          ),
                          _ComposeActionButton(
                            userData: userData,
                            onPressed: _showCreateEntryDialog,
                            //labelAnimation: _animateLabelOnScroll,
                            scrollController: _scrollController,
                          )
                        ],
                      )
                    : _NoEntriesCallToAction(
                        userData: userData,
                        showCreateEntryDialog: _showCreateEntryDialog,
                      );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ComposeActionButton extends StatefulWidget {
  final UserData? userData;
  final void Function() onPressed;
  //final AnimationController labelAnimation;
  final ScrollController? scrollController;

  /// The mixer [Color] used to generate the action button's accent color.
  final Color actionButtonAccentColorMixer;
  const _ComposeActionButton({
    Key? key,
    required this.userData,
    required this.onPressed,
    //@required this.labelAnimation,
    required this.scrollController,
    this.actionButtonAccentColorMixer = Colors.grey,
  }) : super(key: key);

  @override
  __ComposeActionButtonState createState() => __ComposeActionButtonState();
}

class __ComposeActionButtonState extends State<_ComposeActionButton>
    with TickerProviderStateMixin {
  late AnimationController _actionButtonAnimation;
  late AnimationOnScrollController _animationOnScrollController;
  Color? get buttonAccentColor {
    final Color bookmarkColor = Color(widget.userData!.bookmarkColor!);
    final int contrastingColorValue = (0xFFFFFFFF - bookmarkColor.value);
    final Color? contrastingColor =
        Color.lerp(Color(contrastingColorValue), bookmarkColor, 0.75);
    return Color.lerp(
        bookmarkColor, contrastingColor, _actionButtonAnimation.value);
  }

  Color? get buttonMainColor {
    final Color bookmarkColor = Color(widget.userData!.bookmarkColor!);
    return Color.lerp(bookmarkColor, widget.actionButtonAccentColorMixer,
        _actionButtonAnimation.value);
  }

  AnimationController get _scrollAnimation {
    return _animationOnScrollController.animationController;
  }

  @override
  void initState() {
    _actionButtonAnimation = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _actionButtonAnimation.repeat(reverse: true);
    _animationOnScrollController = AnimationOnScrollController(
      scrollController: widget.scrollController,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _actionButtonAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _actionButtonAnimation,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: isPortraitMode(MediaQuery.of(context).size) ? 82.0 : 24.0,
            horizontal: 24.0,
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: LitGradientButton(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 22.0,
              ),
              accentColor: buttonMainColor!,
              color: buttonAccentColor!,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _scrollAnimation,
                    builder: (context, _) {
                      return Opacity(
                        opacity: (1.0 - _scrollAnimation.value),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: (1.0 - _scrollAnimation.value) * 6.0,
                          ),
                          child: Text(
                            LitLocalizations.of(context)!
                                .getLocalizedValue('compose')
                                .toUpperCase(),
                            style: LitTextStyles.sansSerif.copyWith(
                              color: Colors.white,
                              fontSize: (1.0 - _scrollAnimation.value) * 15.0,
                              letterSpacing: 0.75,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Icon(
                    LitIcons.plus,
                    color: Colors.white,
                    size: 15.0,
                  ),
                ],
              ),
              onPressed: widget.onPressed,
            ),
          ),
        );
      },
    );
  }
}

class _NoEntriesCallToAction extends StatelessWidget {
  final UserData? userData;
  final void Function() showCreateEntryDialog;
  const _NoEntriesCallToAction({
    Key? key,
    required this.userData,
    required this.showCreateEntryDialog,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: ScrollableColumn(
        mainAxisSize: MainAxisSize.max,
        children: [
          BookmarkFrontPreview(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 32.0,
              bottom: 16.0,
            ),
            userData: userData,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
            ),
            child: LitConstrainedSizedBox(
              landscapeWidthFactor: 0.55,
              child: LitGradientCard(
                // padding: EdgeInsets.only(
                //   left: 32.0,
                //   right: 32.0,
                //   bottom:
                //       isPortraitMode(MediaQuery.of(context).size) ? 16.0 : 64.0,
                //   top: 16.0,
                // ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(
                //       15.0,
                //     ),
                //   ),
                //   gradient: LinearGradient(

                //   ),
                //   boxShadow: [
                //     BoxShadow(
                //       blurRadius: 12.0,
                //       color: Colors.black38,
                //       offset: Offset(
                //         2.0,
                //         2.0,
                //       ),
                //     ),
                //   ],
                // ),
                // margin: EdgeInsets.symmetric(
                //   vertical: 24.0,
                //   horizontal: 24.0,
                // ),
                padding: EdgeInsets.only(
                  left: 32.0,
                  right: 32.0,
                  bottom:
                      isPortraitMode(MediaQuery.of(context).size) ? 16.0 : 64.0,
                  top: 16.0,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 24.0,
                ),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HexColor('#FFFBF4'),
                  HexColor('#FFFBFB'),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    15.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "No Entries Found",
                      style: LitTextStyles.sansSerif.copyWith(
                        color: HexColor('#8A8A8A'),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: ExclamationRectangle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        "There are no entries available. Do you want to create your first entry?",
                        textAlign: TextAlign.center,
                        style: LitTextStyles.sansSerif.copyWith(
                          color: HexColor('#8A8A8A'),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                    PurplePinkButton(
                      label: "create entry",
                      onPressed: showCreateEntryDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
