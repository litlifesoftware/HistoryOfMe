# History of Me

## ![History of Me Feature Graphic](assets/misc/Google_Playstore_Promo_Image_2.png "History of Me Feature Graphic")

**Your own personal diary**

History of Me wants to be your own personal diary in the digital age. Browse through all of your diary entries and organize your writings. Create, edit and read individual entries and relive your memories. Track your mood and feelings. History of Me offers a digital bookmark you can customize yourself. This app will store your data only on your device. No one else but you will be able to read your diary!

## Screenshots

| Browse through your memories                                                                               | Read your diary entries                                                                          |
| ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| ![Browse through your memories](assets/misc/History_Of_Me_Screenshot_1.png "Browse through your memories") | ![Read your diary entries](assets/misc/History_Of_Me_Screenshot_2.png "Read your diary entries") |

| Edit your entry                                                                  | Customize your bookmark                                                                          |
| -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| ![Edit your entry](assets/misc/History_Of_Me_Screenshot_5.png "Edit your entry") | ![Customize your bookmark](assets/misc/History_Of_Me_Screenshot_4.png "Customize your bookmark") |

## Getting Started with Flutter

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build from Source

To build this project, Flutter should be installed on your computer. Visit the [install guide](https://flutter.io/docs/get-started/install) available on the Flutter website to get started.

Clone the repository and run the app using the Flutter Engine on your local device:

```
git clone https://github.com/litlifesoftware/HistoryOfMe.git
cd HistoryOfMe
flutter run
```

## Signature

In order to create signed APK files to upload to various app stores, you have to specify a keystore location inside the `android\key.properties` file. This file should link to a keystore stored on your local hard drive. Follow [Flutter's deployment guidelines](https://flutter.dev/docs/deployment/android#create-a-keystore) to create your own keystore required to generate verified APK files.

## Localization

There are **English** and **German** localizations available for this app. These strings are stored in the `assets\json\localized_strings.json` and read on the app's start up.

## Photography Assets

The photographs displayed as 'diary entry backdrop image' are stored on disk and were downloaded from [Unsplash](https://www.unsplash.com/).

Special thanks to the photographers whose photos were used:

**Niilo Isotalo**: "Kuopio, Finland", published on `2017-10-16`

**Peiwen Yu**: "Hanzhong, China", published on `2017-4-10`

**Greg Rakozy**: "Spiral Jetty, United States", published on `2015-10-15`

Consider checking out their profiles and photos.

## Dependencies

History Of Me uses the following Dart dependencies in order to implement certain
features and functionality:

- [lit_ui_kit](https://pub.dev/packages/lit_ui_kit)
  > LitUIKit enables you to create unique user interfaces in less time. [More information](https://www.github.com/litlifesoftware/lit_ui_kit)
- [lit_localization_service](https://pub.dev/packages/lit_localization_service)
  > LitLocalizationService enables you to parse JSON files storing your localization data. [More information](https://www.github.com/litlifesoftware/lit_localization_service)
- [lit_relative_date_time](https://pub.dev/packages/lit_relative_date_time)
  > LitRelativeDateTime enables you to display differences in Time in human-readable format. [More information](https://www.github.com/litlifesoftware/lit_relative_date_time)
- [intl](https://pub.dev/packages/intl) (Used for localization)
- [package_info](https://pub.dev/packages/package_info) (Used to detect the platform)
- [url_launcher](https://pub.dev/packages/url_launcher) (Used to
  redirect users to websites)
- [hive](https://pub.dev/packages/hive) (Used as persistent storage)
- [hive_flutter](https://pub.dev/packages/hive_flutter) (Flutter Addon for Hive)
- [hive_generator](https://pub.dev/packages/hive_generator) (Addon for Hive)
- [build_runner](https://pub.dev/packages/build_runner) (Used to generate Adapter classes for Hive data models)
- [flutter_launcher_icon](https://pub.dev/packages/flutter_launcher_icons) (Used to generate Android/iOS Launcher Icons)

## Status

History of Me is still under **early development**. The first release will probably be published in **mid 2021**. Crucial features are implemented, but need to be polished. German localization will be implemented soon.

## License

All images in the `assets/images` folder are licensed under the **CC-BY**.

Everything else in this repository including the source code is distributed under the
**BSD 3-Clause** license as specified in the `LICENSE` file.