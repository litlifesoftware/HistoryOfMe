import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:history_of_me/model/backdrop_photo.dart';
import 'package:history_of_me/view/builder/database_state_screen_builder.dart';
import 'package:lit_localization_service/delegate/lit_localization_service_delegate.dart';
import 'package:lit_localization_service/lit_localization_service.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The background photos fetched from local storage.
  List<String?> backdropPhotoUrlList = [];

  /// The list of images required to load from local storage.
  final List<String> utilityImagesUrlList = const [
    "assets/images/History_Of_Me_Key_Icon_256px-01.png",
    "assets/images/Key.png",
    "assets/images/Curtain_Left.png",
    "assets/images/Curtain_Right.png",
    "assets/images/Window.png",
    "assets/images/Cloud.png",
    "assets/images/History_Of_Me_Window_Artwork_Small.png"
  ];

  /// Parses the
  void parseBackdropPhotos(String assetData) {
    final parsed = jsonDecode(assetData).cast<Map<String, dynamic>>();
    parsed.forEach((json) => setState(
        () => backdropPhotoUrlList.add(BackdropPhoto.fromJson(json).assetUrl)));
    print(backdropPhotoUrlList.length);
    // return parsed
    //     .map<void>((json) => backdropPhotos.add(BackdropPhoto.fromJson(json)));
  }

  Future<void> loadPhotosFromJson() async {
    String data =
        await rootBundle.loadString('assets/json/image_collection_data.json');

    return parseBackdropPhotos(data);
  }

  @override
  void initState() {
    super.initState();
    ImageCacheController(
      context: context,
      assetImages: utilityImagesUrlList,
    );
    loadPhotosFromJson().then(
      (value) => ImageCacheController(
        context: context,
        assetImages: backdropPhotoUrlList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,

        primarySwatch: Colors.grey,
        primaryColor: Colors.grey[50],
        primaryColorBrightness: Brightness.light,

        //Sliver scroll physics color
        accentColor: Colors.transparent,
        accentColorBrightness: Brightness.light,
      ),
      localizationsDelegates: [
        LitLocalizationServiceDelegate(
          jsonAssetURL: 'assets/json/localized_strings.json',
          supportedLanguages: ['en', 'de'],
          debug: true,
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// Supported languages
      supportedLocales: [
        // English (no contry code)
        const Locale('en', ''),
        // German (no contry code)
        const Locale('de', ''),
        // Russian (no contry code)
        const Locale('ru', ''),
      ],
      title: 'History of Me',
      home: DatabaseStateScreenBuilder(
        localizationsAssetURL: 'assets/json/localized_strings.json',
      ),
    );
  }
}
