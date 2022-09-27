import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/static.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

/// The main Flutter widget of `HistoryOfMe`.
///
/// It's main purpose is to initialize the [MaterialApp] widget and to load the
/// read-only content from the local storage and to provide basic meta data such
/// as the app name.
///
/// It also provides the option to restart the whole app if required using
/// its `restartApp()` method.
class App extends StatefulWidget {
  /// States whether the app runs in debug mode.
  ///
  /// This will prevent debug output to be printed.
  static const bool DEBUG = false;

  /// The application's name.
  static const String appName = "History Of Me";

  /// The application's slogan.
  static const String appSlogan = "Your own personal diary.";

  /// The application's developer.
  static const String appDeveloper = "LitLifeSoftware";

  static const supportedLocales = AppLocalizations.supportedLocales;

  static const supportedLanguages = const [
    EN.languageCode,
    DE.languageCode,
  ];

  /// Restarts the whole application by creating a new [UniqueKey] on the
  /// uppermost widget ([MaterialApp]).
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_AppState>()!.restartApp();
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Key _key = UniqueKey();

  /// The background photos fetched from local storage.
  List<String?> backdropPhotoUrlList = [];

  /// The list of images required to load from local storage.
  final List<String> utilityImagesUrlList = const [
    AppAssets.keyLogo256px,
    AppAssets.keyIcon,
    AppAssets.curtainLeftImg,
    AppAssets.curtainRightImg,
    AppAssets.windowImg,
    AppAssets.cloudImg,
    AppAssets.historyOfMeArtworkSmall,
  ];

  /// Restart the app globally by creating a new [UniqueKey].
  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    ImageCacheController(
      context: context,
      assetImages: utilityImagesUrlList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: MaterialApp(
        debugShowCheckedModeBanner: App.DEBUG,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          primaryColor: Colors.grey[50],
          useMaterial3: true,
          textTheme: LitSansSerifStyles.theme,
          iconTheme: IconThemeData(
            color: LitColors.grey500,
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: LitColors.grey500),
            actionsIconTheme: IconThemeData(
              color: LitColors.grey500,
            ),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          LeitmotifLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        /// Supported languages
        supportedLocales: App.supportedLocales,
        title: App.appName,
        home: DatabaseStateScreenBuilder(),
      ),
    );
  }
}
