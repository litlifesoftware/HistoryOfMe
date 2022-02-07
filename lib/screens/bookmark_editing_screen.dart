import 'package:flutter/material.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/controllers.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

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
  late TextEditingController _quoteController;
  late TextEditingController _authorController;

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

  // /// Stores the current [UserData.quote] value.
  // late String _quote;

  /// Stores the current [UserData.animated] value.
  late bool _animated;

  /// Stores the current [UserData.designPatternIndex] value.
  late int _designPattern;

  // /// Stores the current [UserData.quoteAuthor] value.
  // late String _quoteAuthor;

  late AnimationController _appearAnimation;

  late LitSnackbarController _colorErrorSnackbar;

  late LitSnackbarController _autosaveSnackbar;

  late ScrollController _scrollController;

  late LitRouteController _routeController;

  late AutosaveController _autosaveController;

  late AppAPI _api;

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

  // /// Sets the [_quote]. The will not be used on the view, therefore the
  // /// setState is not necessary.
  // void setQuote(String quote) {
  //   _quote = quote;
  // }

  // /// Sets the [_quoteAuthor]. The will not be used on the view, therefore the
  // /// setState is not necessary.
  // void setQuoteAuthor(String author) {
  //   _quoteAuthor = author;
  // }

  /// Maps the state value into an [UserData] object.
  UserData _mapUserData(int lastUpdated) {
    return UserData(
      name: _name,
      primaryColor: _primaryColor,
      secondaryColor: _secondaryColor,
      stripeCount: _stripeCount,
      dotSize: _dotSize,
      animated: _animated,
      quote: _quoteController.text,
      designPatternIndex: _designPattern,
      quoteAuthor: _authorController.text,
      lastUpdated: lastUpdated,
      created: widget.initialUserDataModel!.created,
    );
  }

  /// Checks whether the user submitted any unsaved changes.
  bool _isUnsaved(UserData other) {
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
    if (_quoteController.text != other.quote) {
      return true;
    }
    if (_authorController.text != other.quoteAuthor) {
      return true;
    }
    return false;
  }

  /// Updates the Hive database using the latest changes.
  void _saveChanges() {
    final data = _mapUserData(DateTime.now().millisecondsSinceEpoch);
    _api.updateUserData(data);
  }

  /// Updates the Hive database using the latest changes.
  void _onAutosave() {
    _saveChanges();
    _autosaveSnackbar.showSnackBar();
  }

  /// Shows the [DiscardDraftDialog].
  void _handleDiscardDraft() {
    showDialog(
      context: context,
      builder: (_) => DiscardDraftDialog(
        // titleText: HOMLocalizations(context).unsaved,
        // infoDescription: HOMLocalizations(context).unsavedBookmarkDescr,
        // discardText: HOMLocalizations(context).discardChanges,
        // cancelButtonLabel: HOMLocalizations(context).cancel,
        // discardButtonLabel: HOMLocalizations(context).discard,
        onDiscard: () {
          _routeController.closeDialog();
          _routeController.navigateBack();
        },
      ),
    );
  }

  void _onAddColorError() {
    _colorErrorSnackbar.showSnackBar();
  }

  Future<bool> handlePopAction(bool isChanged) {
    if (isChanged) {
      _handleDiscardDraft();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();
    _quoteController =
        TextEditingController(text: widget.initialUserDataModel!.quote);
    _authorController =
        TextEditingController(text: widget.initialUserDataModel!.quoteAuthor);
    _colorErrorSnackbar = LitSnackbarController();
    _autosaveSnackbar = LitSnackbarController();
    _scrollController = ScrollController();
    _routeController = LitRouteController(context);
    _appearAnimation = AnimationController(
      duration: Duration(
        milliseconds: 230,
      ),
      vsync: this,
    );
    _autosaveController = AutosaveController(
      _onAutosave,
      duration: Duration(seconds: 180),
    );
    _api = AppAPI();
    // Inital state variables using the provided user data object.
    _name = widget.initialUserDataModel!.name;
    _animated = widget.initialUserDataModel!.animated;
    _primaryColor = widget.initialUserDataModel!.primaryColor;
    _secondaryColor = widget.initialUserDataModel!.secondaryColor;
    _stripeCount = widget.initialUserDataModel!.stripeCount;
    _dotSize = widget.initialUserDataModel!.dotSize;
    // _quote = widget.initialUserDataModel!.quote;
    // _quoteAuthor = widget.initialUserDataModel!.quoteAuthor;
    _designPattern = widget.initialUserDataModel!.designPatternIndex;
    // Play the animation.
    _appearAnimation.forward();
  }

  @override
  void dispose() {
    _appearAnimation.dispose();
    _colorErrorSnackbar.dispose();
    _autosaveSnackbar.dispose();
    _scrollController.dispose();
    _autosaveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserDataProvider(
      api: _api,
      builder: (context, updatedUserData) {
        return WillPopScope(
          onWillPop: () => handlePopAction(
            _isUnsaved(updatedUserData!),
          ),
          child: LitScaffold(
            appBar: FixedOnScrollAppbar(
              scrollController: _scrollController,
              backgroundColor: Colors.white,
              child: EditableItemMetaInfo(
                lastUpdateTimestamp: updatedUserData!.lastUpdated,
                showUnsavedBadge: _isUnsaved(updatedUserData),
              ),
              shouldNavigateBack: !_isUnsaved(updatedUserData),
              onInvalidNavigation: _handleDiscardDraft,
            ),
            snackbars: [
              LitIconSnackbar(
                snackBarController: _colorErrorSnackbar,
                text: AppLocalizations.of(context).duplicateColorDescr,
                iconData: LitIcons.info,
              ),
              LitIconSnackbar(
                snackBarController: _autosaveSnackbar,
                text: AppLocalizations.of(context).bookmarkSavedDescr,
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
                                      label: AppLocalizations.of(context)
                                          .stripesLabel,
                                      value: 0,
                                    ),
                                    LitToggleButtonGroupItemData(
                                      label: AppLocalizations.of(context)
                                          .dotsLabel,
                                      value: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          UserCreatedColorProvider(
                            builder: (context, userColors) {
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
                                      onStripeSliderChange:
                                          onStripeSliderChange,
                                      onDotsSliderChange: onDotsSliderChange,
                                    ),
                                    QuoteCard(
                                      authorController: _authorController,
                                      quoteController: _quoteController,
                                    ),
                                    PrimaryColorSelectorCard(
                                      selectedColorValue: _primaryColor,
                                      onSelectPrimaryColor: _setPrimaryColor,
                                      userCreatedColors: userColors,
                                      cardTitle: AppLocalizations.of(context)
                                          .mainColorLabel
                                          .capitalize(),
                                      onAddColorError: _onAddColorError,
                                    ),
                                    SecondaryColorSelectorCard(
                                      userCreatedColors: userColors,
                                      selectedSecondaryColorValue:
                                          _secondaryColor,
                                      onSelectSecondaryColor:
                                          _setSecondaryColor,
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
                      disabled: !_isUnsaved(updatedUserData),
                      onSaveChanges: _saveChanges,
                    )
                  ],
                );
              },
            ),
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
          //patternLabel: HOMLocalizations(context).striped,
          patternValue: stripeCount,
          onPatternSliderChange: onStripeSliderChange,
          min: 1,
          max: 32,
        );
      case 1:
        return PatternConfigCard(
          designPattern: designPattern,
          //patternLabel: HOMLocalizations(context).dotted,
          patternValue: dotSize,
          onPatternSliderChange: onDotsSliderChange,
          min: 12,
          max: 32,
        );
      default:
        return PatternConfigCard(
          designPattern: designPattern,
          //patternLabel: HOMLocalizations(context).striped,
          patternValue: stripeCount,
          onPatternSliderChange: onStripeSliderChange,
          min: 1,
          max: 32,
        );
    }
  }
}
