import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/controller/localization/hom_localizations.dart';
import 'package:history_of_me/view/shared/shared.dart';
import 'package:leitmotif/leitmotif.dart';
import 'package:history_of_me/controller/database/hive_db_service.dart';
import 'package:history_of_me/config/config.dart';
import 'package:history_of_me/model/user_created_color.dart';
import 'package:history_of_me/model/user_data.dart';
import 'package:hive/hive.dart';

import 'pattern_config_card.dart';
import 'primary_color_selector_card.dart';
import 'quote_card.dart';
import 'secondary_color_selector_card.dart';

/// A screen widget allowing to edit the user's bookmark using several input
/// elements.
///
/// The initially provided [UserData] will be edited and submitted to the
/// Hive database.
class BookmarkEditingScreen extends StatefulWidget {
  /// Creates a [BookmarkEditingScreen].
  const BookmarkEditingScreen({
    Key? key,
    required this.initialUserDataModel,
  }) : super(key: key);

  /// The inital user data, whose values can be edited by the user.
  final UserData? initialUserDataModel;

  @override
  _BookmarkEditingScreenState createState() => _BookmarkEditingScreenState();
}

class _BookmarkEditingScreenState extends State<BookmarkEditingScreen>
    with TickerProviderStateMixin {
  /// Stores the current [UserData.name] value.
  late String _name;

  /// Stores the current [UserData.primaryColor] value.
  late int _primaryColor;

  /// Stores the current [UserData.secondaryColor] value.
  late int _secondaryColor;

  /// Stores the current [UserData.stripeCount] value.
  late int _stripeCount;

  /// Stores the current [UserData.dotSize] value.
  late int _dotSize;

  /// Stores the current [UserData.quote] value.
  late String _quote;

  /// Stores the current [UserData.animated] value.
  late bool _animated;

  /// Stores the current [UserData.designPatternIndex] value.
  late int _designPattern;

  /// Stores the current [UserData.quoteAuthor] value.
  late String _quoteAuthor;

  late AnimationController _appearAnimation;

  late LitSnackbarController _snackbarController;

  late ScrollController _scrollController;

  late LitRouteController _routeController;

  /// Sets the [_designPattern] using the setState method.
  void setDesignPattern(int value) {
    setState(
      () {
        _designPattern = value;
      },
    );
  }

  /// Sets the [_stripeCount] using the setState method.
  void onStripeSliderChange(double value) {
    setState(
      () {
        _stripeCount = value.round();
      },
    );
  }

  /// Sets the [_dotSize] using the setState method.
  void onDotsSliderChange(double value) {
    setState(
      () {
        _dotSize = value.round();
      },
    );
  }

  /// Sets the [_primaryColor] using the setState method.
  void _setPrimaryColor(Color color) {
    setState(
      () {
        _primaryColor = color.value;
      },
    );
  }

  /// Sets the [_secondaryColor] using the setState method.
  void _setSecondaryColor(Color color) {
    setState(
      () {
        _secondaryColor = color.value;
      },
    );
  }

  /// Sets the [_quote]. The will not be used on the view, therefore the
  /// setState is not necessary.
  void setQuote(String quote) {
    _quote = quote;
  }

  /// Sets the [_quoteAuthor]. The will not be used on the view, therefore the
  /// setState is not necessary.
  void setQuoteAuthor(String author) {
    _quoteAuthor = author;
  }

  /// Maps the state value into an [UserData] object.
  UserData _mapUserData(int lastUpdated) {
    return UserData(
      name: _name,
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
      stripeCount: _stripeCount,
      dotSize: _dotSize,
      animated: _animated,
      quote: _quote,
      designPatternIndex: _designPattern,
      quoteAuthor: _quoteAuthor,
      lastUpdated: lastUpdated,
      created: widget.initialUserDataModel!.created,
    );
  }

  /// Checks if there has been changes submitted by the user.
  ///
  /// Evaluates whether the state values are diffenent from the provided
  /// [UserData] object.
  bool _userDataChanged(UserData other) {
    if (_primaryColor != other.primaryColor) {
      return true;
    }
    if (_secondaryColor != other.secondaryColor) {
      return true;
    }
    if (_designPattern != other.designPatternIndex) {
      return true;
    }
    if (_dotSize != other.dotSize) {
      return true;
    }
    if (_stripeCount != other.stripeCount) {
      return true;
    }
    if (_name != other.name) {
      return true;
    }
    if (_quote != other.quote) {
      return true;
    }
    if (_quoteAuthor != other.quoteAuthor) {
      return true;
    }
    return false;
  }

  /// Updates the Hive database using the latest changes.
  void _saveChanges() {
    HiveDBService(debug: DEBUG)
        .updateUserData(_mapUserData(DateTime.now().millisecondsSinceEpoch));
  }

  /// Shows the [DiscardDraftDialog].
  void _handleDiscardDraft() {
    showDialog(
      context: context,
      builder: (_) => DiscardDraftDialog(
        titleText: HOMLocalizations(context).unsaved,
        infoDescription: HOMLocalizations(context).unsavedBookmarkDescr,
        discardText: HOMLocalizations(context).discardChanges,
        cancelButtonLabel: HOMLocalizations(context).cancel,
        discardButtonLabel: HOMLocalizations(context).discard,
        onDiscard: () {
          _routeController.closeDialog();
          _routeController.navigateBack();
        },
      ),
    );
  }

  void _onAddColorError() {
    _snackbarController.showSnackBar();
  }

  @override
  void initState() {
    super.initState();
    // Initialize all controllers.
    _snackbarController = LitSnackbarController();
    _scrollController = ScrollController();
    _routeController = LitRouteController(context);
    _appearAnimation = AnimationController(
      duration: Duration(
        milliseconds: 230,
      ),
      vsync: this,
    );
    // Inital state variables using the provided user data object.
    _name = widget.initialUserDataModel!.name;
    _animated = widget.initialUserDataModel!.animated;
    _primaryColor = widget.initialUserDataModel!.primaryColor;
    _secondaryColor = widget.initialUserDataModel!.secondaryColor;
    _stripeCount = widget.initialUserDataModel!.stripeCount;
    _dotSize = widget.initialUserDataModel!.dotSize;
    _quote = widget.initialUserDataModel!.quote;
    _quoteAuthor = widget.initialUserDataModel!.quoteAuthor;
    _designPattern = widget.initialUserDataModel!.designPatternIndex;
    // Play the animation.
    _appearAnimation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveDBService().getUserData(),
      builder: (BuildContext context, Box<UserData> userDataBox, Widget? _) {
        UserData updatedUserData = userDataBox.getAt(0)!;
        return LitScaffold(
          appBar: FixedOnScrollAppbar(
            scrollController: _scrollController,
            backgroundColor: Colors.white,
            child: EditableItemMetaInfo(
              lastUpdateTimestamp: updatedUserData.lastUpdated,
              showUnsavedBadge: _userDataChanged(updatedUserData),
            ),
            shouldNavigateBack: !_userDataChanged(updatedUserData),
            onInvalidNavigation: _handleDiscardDraft,
          ),
          snackbars: [
            LitIconSnackbar(
              snackBarController: _snackbarController,
              text: HOMLocalizations(context).colorAlreadyExists,
              iconData: LitIcons.info,
            ),
          ],
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  LitScrollbar(
                    child: ScrollableColumn(
                      controller: _scrollController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16.0,
                          ),
                          child: Column(
                            children: [
                              IndexedPageView(
                                height: 148.0,
                                indicatorSpacingTop: 0.0,
                                indicatorColor: LitColors.mediumGrey,
                                children: [
                                  BookmarkFrontPreview(
                                    transformed: false,
                                    userData: _mapUserData(
                                        updatedUserData.lastUpdated),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 4.0,
                                    ),
                                  ),
                                  BookmarkBackPreview(
                                    transformed: false,
                                    userData: _mapUserData(
                                        updatedUserData.lastUpdated),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 4.0,
                                    ),
                                  )
                                ],
                              ),
                              LitToggleButtonGroup(
                                selectedValue: _designPattern,
                                onSelectCallback: setDesignPattern,
                                items: [
                                  LitToggleButtonGroupItemData(
                                    label: HOMLocalizations(context).striped,
                                    value: 0,
                                  ),
                                  LitToggleButtonGroupItemData(
                                    label: HOMLocalizations(context).dotted,
                                    value: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable:
                              HiveDBService().getUserCreatedColors(),
                          builder: (BuildContext context,
                              Box<UserCreatedColor> colorsBox, Widget? _) {
                            List<UserCreatedColor> userColors =
                                colorsBox.values.toList();

                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height),
                              child: Column(
                                children: [
                                  _ConfigCardBuilder(
                                    designPattern: _designPattern,
                                    dotSize: _dotSize,
                                    stripeCount: _stripeCount,
                                    onStripeSliderChange: onStripeSliderChange,
                                    onDotsSliderChange: onDotsSliderChange,
                                  ),
                                  PrimaryColorSelectorCard(
                                    selectedColorValue: _primaryColor,
                                    onSelectPrimaryColor: _setPrimaryColor,
                                    userCreatedColors: userColors,
                                    cardTitle:
                                        HOMLocalizations(context).mainColor,
                                    onAddColorError: _onAddColorError,
                                  ),
                                  QuoteCard(
                                    initialAuthor: _quoteAuthor,
                                    initialQuote: _quote,
                                    onAuthorChanged: setQuoteAuthor,
                                    onQuoteChanged: setQuote,
                                  ),
                                  SecondaryColorSelectorCard(
                                    cardTitle:
                                        HOMLocalizations(context).accentColor,
                                    userCreatedColors: userColors,
                                    selectedSecondaryColorValue:
                                        _secondaryColor,
                                    onSelectSecondaryColor: _setSecondaryColor,
                                  ),
                                  SizedBox(height: 32.0),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  PurplePinkSaveButton(
                    disabled: !_userDataChanged(updatedUserData),
                    onSaveChanges: _saveChanges,
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}

/// A builder widget returning the [PatternConfigCard] using the `Stripes` or
/// the `Dots` configuration.
class _ConfigCardBuilder extends StatelessWidget {
  final int designPattern;
  final int dotSize;
  final int stripeCount;
  final void Function(double) onStripeSliderChange;
  final void Function(double) onDotsSliderChange;
  const _ConfigCardBuilder({
    Key? key,
    required this.designPattern,
    required this.dotSize,
    required this.stripeCount,
    required this.onStripeSliderChange,
    required this.onDotsSliderChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (designPattern) {
      case 0:
        return PatternConfigCard(
          designPattern: designPattern,
          patternLabel: HOMLocalizations(context).striped,
          patternValue: stripeCount,
          onPatternSliderChange: onStripeSliderChange,
          min: 1,
          max: 32,
        );
      case 1:
        return PatternConfigCard(
          designPattern: designPattern,
          patternLabel: HOMLocalizations(context).dotted,
          patternValue: dotSize,
          onPatternSliderChange: onDotsSliderChange,
          min: 12,
          max: 32,
        );
      default:
        return PatternConfigCard(
          designPattern: designPattern,
          patternLabel: HOMLocalizations(context).striped,
          patternValue: stripeCount,
          onPatternSliderChange: onStripeSliderChange,
          min: 1,
          max: 32,
        );
    }
  }
}
