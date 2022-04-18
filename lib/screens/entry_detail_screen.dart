import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:history_of_me/api.dart';
import 'package:history_of_me/app.dart';
import 'package:history_of_me/controllers.dart';
import 'package:history_of_me/localization.dart';
import 'package:history_of_me/models.dart';
import 'package:history_of_me/widgets.dart';
import 'package:leitmotif/leitmotif.dart';

/// A `History of Me` `screen` widget showing details and properties of a
/// specific [DiaryEntry] object while providing options to edit or delete
/// the entry.
class EntryDetailScreen extends StatefulWidget {
  /// The entry's index on the chronological list of diary entries.
  final int listIndex;

  /// The entry's uid.
  final String? diaryEntryUid;

  /// Creates a [EntryDetailScreen].
  const EntryDetailScreen({
    Key? key,
    required this.listIndex,
    required this.diaryEntryUid,
  }) : super(key: key);

  @override
  _EntryDetailScreenState createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen>
    with TickerProviderStateMixin {
  List<BackdropPhoto> _photoAssets = [];
  late QueryController _queryController;
  ScrollController? _scrollController;
  bool _assetsLoading = false;
  late HOMNavigator _screenRouter;
  late LitSettingsPanelController _settingsPanelController;

  late DiaryPhotoPicker _diaryPhotoPicker;

  // bool unsupportedFile = false;

  // late Directory storageDir;
  // late Directory cacheDir;

  /// Toggles the [_assetsLoading] value.
  void _toggleAssetsLoading() {
    setState(() {
      _assetsLoading = !_assetsLoading;
    });
  }

  /// Adds the provided object to the [_photoAssets] list.
  void _addAsset(dynamic json) {
    setState(() => _photoAssets.add(BackdropPhoto.fromJson(json)));
  }

  /// Decodes the json provided string data.
  void _decode(String assetData) {
    final parsed = jsonDecode(assetData).cast<Map<String, dynamic>>();
    parsed.forEach((json) => _addAsset(json));
    _toggleAssetsLoading();
  }

  /// Loads the json assets from storage into memory.
  Future<void> _loadAssets() async {
    String data = await rootBundle.loadString(App.imageCollectionPath);

    return _decode(data);
  }

  /// Shows the [ChangePhotoDialog].
  // void _showChangePhotoDialog(DiaryEntry diaryEntry) {
  //   showDialog(
  //     context: context,
  //     builder: (_) => ChangePhotoDialog(
  //       backdropPhotos: _photoAssets,
  //       diaryEntry: diaryEntry,
  //       // imageNames: imageNames,
  //     ),
  //   );
  // }

  void _onDeleteEntry() {
    LitRouteController(context).clearNavigationStack();
    AppAPI().deleteDiaryEntry(widget.diaryEntryUid);
  }

  void _showConfirmDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        onDelete: _onDeleteEntry,
      ),
    );
  }

  bool _shouldShowNextButton(DiaryEntry diaryEntry) {
    return _queryController.nextEntryExistsByUID(diaryEntry.uid);
  }

  bool _shouldShowPreviousButton(DiaryEntry diaryEntry) {
    return _queryController.previousEntryExistsByUID(diaryEntry.uid);
  }

  void _onEdit(DiaryEntry diaryEntry) {
    if (_settingsPanelController.isShown)
      _settingsPanelController.dismissSettingsPanel();
    _screenRouter.toEntryEditingScreen(diaryEntry: diaryEntry);
  }

  /// Delays the [_onEdit] call by the button animation duration to allow the
  /// animation to fully play back before transitioning to the next screen.
  void _onEditDelayed(DiaryEntry diaryEntry) {
    Future.delayed(LitAnimationDurations.button).then(
      (_) => _onEdit(diaryEntry),
    );
  }

  //final ImagePicker picker = ImagePicker();

  //List<XFile> images = [];

  // void pickImage(DiaryEntry entry) async {
  //   //final ImagePicker _picker = ImagePicker();
  //   // final

  //   // setState(() {
  //   //   images = [];
  //   // })

  //   List<XFile?>? pickedImages = [];
  //   List<DiaryPhoto> diaryPhotos = [];

  //   try {
  //     pickedImages = await picker.pickMultiImage();
  //     if (pickedImages != null && pickedImages.length != 0) {
  //       images = [];
  //     }
  //   } catch (e) {
  //     unsupportedFile = true;
  //     showDialog(
  //       context: context,
  //       builder: (context) => LitTitledDialog(
  //         titleText: "Error",
  //         child: Padding(
  //           padding: LitEdgeInsets.dialogMargin,
  //           child: Text(
  //             "Not supported file.",
  //             style: LitSansSerifStyles.body2,
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   if (pickedImages != null) {
  //     pickedImages.forEach(
  //       (XFile? element) async {
  //         if (element == null)
  //           return;
  //         else {
  //           setState(() {
  //             images.add(element);
  //           });
  //           // element.openRead();
  //           // Future<Uint8List> ele = await element.readAsBytes();
  //           // print(ele);
  //           //TODO: Store on app directory
  //           //TODO: copy to media directory to backup photos
  //           //maybe store photos as base64 string
  //           //TODO: make sure it will work on all version apps / error handling
  //           // TODO: include the base64 string in the photo model
  //           // TODO: extend backuping to backup photos.

  //           String uid = AppAPI().generateUid();
  //           String fileName = uid + p.extension(element.path);
  //           String filePath = storageDir.path + '/' + fileName;
  //           // Directory('/data/user/0/com.litlifesoftware.historyofme/images/')
  //           //     .create();

  //           //TODO: PICK STORE AND RETRIVE
  //           // Pick file, get path, genereate image name using uid, copy image to
  //           // app dir using custom image name (APPDIR/images/imagename.ext)
  //           // store list of image names on diary entry (we already know the
  //           // app dir path)
  //           // TODO: BACKUP and restore
  //           // Backup: Copy all images on APPDIR/images/ to Download/LitLifeSoftware/HistoryOfMe/images (loop all entries then loop all
  //           // images of the entry to get its image file paths)
  //           // Restore: Copy all images on Download/../images to APPDir/images/
  //           // (loop all entries then loop all images of the entry to get its image file path).
  //           try {
  //             element.saveTo(filePath).then((_) {
  //               try {
  //                 print("Trying to delete cached file on: " + element.path);
  //                 File(element.path).delete();
  //               } catch (e) {}
  //             });
  //           } catch (e) {
  //             print("Not saved propely");
  //           }

  //           print(filePath);

  //           // final dir = Directory(dirPath);
  //           // dir.deleteSync(recursive: true);

  //           diaryPhotos.add(
  //             DiaryPhoto(
  //               uid: uid,
  //               date: entry.date,
  //               created: new DateTime.now().millisecondsSinceEpoch,
  //               name: fileName,
  //               path: filePath,
  //             ),
  //           );
  //         }
  //       },
  //     );

  //     // Delete image cache.
  //     // if (cachePath != null) {
  //     //   cachePath!.deleteSync(recursive: true);
  //     //   print("Cached images deleted.");
  //     // } else {
  //     //   print("Cached images not delete, dir is null");
  //     // }
  //   }

  //   images.forEach((element) {
  //     print(element.path);
  //   });

  //   if (diaryPhotos.length != 0) {
  //     int nowTimestamp = new DateTime.now().millisecondsSinceEpoch;

  //     DiaryEntry updated = DiaryEntry(
  //       uid: entry.uid,
  //       date: entry.date,
  //       created: entry.created,
  //       // Update 'updated' timestamp
  //       lastUpdated: nowTimestamp,
  //       title: entry.title,
  //       content: entry.content,
  //       moodScore: entry.moodScore,
  //       favorite: entry.favorite,
  //       backdropPhotoId: entry.backdropPhotoId,
  //       // Include picked photos.
  //       photos: diaryPhotos,
  //     );

  //     AppAPI().updateDiaryEntry(updated);

  //     // Delete image cache.
  //     // deleteCachedFiles();
  //   } else {
  //     if (!unsupportedFile) {
  //       showDialog(
  //         context: context,
  //         builder: (context) => LitTitledDialog(
  //           child: Text("delete all images ?"),
  //           titleText: "titleText",
  //           actionButtons: [
  //             DialogActionButton(
  //               data: ActionButtonData(
  //                   title: "Delete",
  //                   onPressed: () {
  //                     DiaryEntry updated = DiaryEntry(
  //                       uid: entry.uid,
  //                       date: entry.date,
  //                       created: entry.created,
  //                       lastUpdated: entry.lastUpdated,
  //                       title: entry.title,
  //                       content: entry.content,
  //                       moodScore: entry.moodScore,
  //                       favorite: entry.favorite,
  //                       backdropPhotoId: entry.backdropPhotoId,
  //                       photos: [],
  //                     );

  //                     AppAPI().updateDiaryEntry(updated);
  //                     Navigator.of(context).pop();
  //                   }),
  //             )
  //           ],
  //         ),
  //       );
  //     }
  //   }
  // }

  // void deleteCachedFiles() async {
  //   await cacheDir.delete(recursive: true);
  //   print("Cached files deleted.");
  // }

  void _onNextPressed(DiaryEntry diaryEntry) {
    Future.delayed(LitAnimationDurations.button).then(
      (_) {
        LitRouteController(context).replaceCurrentCupertinoWidget(
          newWidget: EntryDetailScreen(
            // Decrease the index by one to artificially lower the total
            // entries count and therefore increase the entries number on
            // the label text.
            listIndex: widget.listIndex,
            diaryEntryUid: _queryController.getNextDiaryEntry(diaryEntry).uid,
          ),
        );
      },
    );
  }

  void _onPreviousPressed(DiaryEntry diaryEntry) {
    Future.delayed(LitAnimationDurations.button).then(
      (_) {
        LitRouteController(context).replaceCurrentCupertinoWidget(
          newWidget: EntryDetailScreen(
            // Increase the index by one to artificially higher the total
            // entries count and therefore lower the entries number on
            // the label text.
            listIndex: widget.listIndex,
            diaryEntryUid:
                _queryController.getPreviousDiaryEntry(diaryEntry).uid,
          ),
        );
      },
    );
  }

  // CustomAppBar getAppBar(DiaryEntry diaryEntry) {
  //   if (_scrollController == null) {
  //     return LitAppBar(title: "he");
  //   }

  //   if (_scrollController!.offset > CustomAppBar.height) {}

  //   return LitAppBar(title: "he");
  // }

  void _onPickedUnsupportedFile() {
    showDialog(
      context: context,
      builder: (context) => UnsupportedFileDialog(),
    );
  }

  void _onDeleteAllPhotos(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (context) => DeleteAllPhotosDialog(entry: entry),
    );
  }

  @override
  void initState() {
    super.initState();
    _toggleAssetsLoading();
    _loadAssets();

    _scrollController = ScrollController();
    _settingsPanelController = LitSettingsPanelController();
    _queryController = QueryController();
    _screenRouter = HOMNavigator(context);
    //
    _diaryPhotoPicker = DiaryPhotoPicker(
      onPickedUnsupportedFile: _onPickedUnsupportedFile,
      onDeleteAllPhotos: _onDeleteAllPhotos,
    );
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QueryDiaryEntryProvider(
      diaryEntryUid: widget.diaryEntryUid!,
      builder: (context, diaryEntry, isFirst, isLast, boxLength) {
        /// Verify the entry has not been deleted yet.
        if (diaryEntry != null) {
          return LitScaffold(
            appBar: FixedOnScrollTitledAppbar(
              scrollController: _scrollController,
              title: diaryEntry.title != ""
                  ? diaryEntry.title
                  : AppLocalizations.of(context).untitledLabel,
            ),
            settingsPanel: LitSettingsPanel(
              height: 180.0,
              controller: _settingsPanelController,
              title: AppLocalizations.of(context).optionsLabel.capitalize(),
              children: [
                LitPushedThroughButton(
                  child: Text(
                    AppLocalizations.of(context).editLabel.toUpperCase(),
                    style: LitSansSerifStyles.button,
                  ),
                  accentColor: LitColors.grey100,
                  onPressed: () => _onEditDelayed(diaryEntry),
                ),
                SizedBox(height: 16.0),
                LitDeleteButton(
                  onPressed: _showConfirmDeleteDialog,
                ),
              ],
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              return Container(
                child: Stack(
                  children: [
                    LitScrollbar(
                      child: ScrollableColumn(
                        controller: _scrollController,
                        children: [
                          SizedBox(
                            height: 384.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                EntryDetailBackdrop(
                                  // backdropPhotos: _photoAssets,
                                  // loading: _assetsLoading,
                                  diaryEntry: diaryEntry,
                                  diaryPhotoPicker: _diaryPhotoPicker,
                                  //  images: images,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 64.0 + 16.0,
                                      top: 16.0,
                                      left: 16.0,
                                      right: 20.0,
                                    ),
                                    child: PickPhotosButton(
                                      onPressed: () {
                                        _diaryPhotoPicker
                                            .pickPhotosAndSave(diaryEntry);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform(
                            transform: Matrix4.translationValues(0, -64.0, 0),
                            child: EntryDetailCard(
                              boxLength: boxLength,
                              listIndex: widget.listIndex,
                              isFirst: isFirst,
                              isLast: isLast,
                              diaryEntry: diaryEntry,
                              onEdit: () => _onEdit(diaryEntry),
                              queryController: _queryController,
                            ),
                          ),
                          _Footer(
                            showNextButton: _shouldShowNextButton(diaryEntry),
                            showPreviousButton:
                                _shouldShowPreviousButton(diaryEntry),
                            onPrevious: () => _onPreviousPressed(diaryEntry),
                            onNext: () => _onNextPressed(diaryEntry),
                            moreOptionsPressed:
                                _settingsPanelController.showSettingsPanel,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        }
        return SizedBox();
      },
    );
  }
}

/// A `History of Me` widget showing a row of buttons allowing the user to
/// interact with a diary entry.
///
/// It allows to navigate to the previous and next entry and to delete the
/// entry.
class _Footer extends StatelessWidget {
  final bool showNextButton;
  final bool showPreviousButton;
  final void Function() moreOptionsPressed;
  final void Function() onNext;
  final void Function() onPrevious;

  /// Creates a [_Footer].
  const _Footer({
    Key? key,
    required this.moreOptionsPressed,
    required this.onNext,
    required this.onPrevious,
    required this.showNextButton,
    required this.showPreviousButton,
  }) : super(key: key);

  /// Returns the spacing in pixels that should be applied between the
  /// buttons in the row.
  double get _buttonSpacing => showNextButton && showPreviousButton ? 8.0 : 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 72.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            LitColors.lightGrey,
            Colors.white,
          ],
          stops: [
            0.00,
            0.87,
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            offset: Offset(0, -2),
            color: Colors.black12,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                showPreviousButton
                    ? _PreviousNavigationButton(onPressed: onPrevious)
                    : SizedBox(),
                SizedBox(width: _buttonSpacing),
                showNextButton
                    ? _NextNavigationButton(onPressed: onNext)
                    : SizedBox(),
              ],
            ),
            LitPushedThroughButton(
              margin: LitEdgeInsets.button * 1.5,
              child: EllipseIcon(
                animated: false,
                dotColor: LitColors.grey380,
              ),
              onPressed: moreOptionsPressed,
              accentColor: Colors.white,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

/// A `History of Me` widget allowing to navigate to the next entry using the
/// [onPressed] callback.
class _NextNavigationButton extends StatelessWidget {
  final void Function() onPressed;

  /// Creates a [_NextNavigationButton].
  const _NextNavigationButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NavigationButton(
      label: LeitmotifLocalizations.of(context).nextLabel.toUpperCase(),
      mode: LitLinearNavigationMode.next,
      onPressed: onPressed,
    );
  }
}

/// A `History of Me` widget allowing to navigate to the previous entry using the
/// [onPressed] callback.
class _PreviousNavigationButton extends StatelessWidget {
  final void Function() onPressed;

  /// Creates a [_PreviousNavigationButton].
  const _PreviousNavigationButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _NavigationButton(
      label: LeitmotifLocalizations.of(context).backLabel.toUpperCase(),
      mode: LitLinearNavigationMode.previous,
      onPressed: onPressed,
    );
  }
}

/// A `History of Me` widget displaying a navigation button based on the
/// provided [mode] value.
class _NavigationButton extends StatelessWidget {
  final LitLinearNavigationMode mode;
  final String label;
  final void Function() onPressed;
  const _NavigationButton({
    Key? key,
    required this.label,
    required this.mode,
    required this.onPressed,
  }) : super(key: key);

  static const double _maxWidth = 72.0;

  static const double _spacing = 4.0;

  @override
  Widget build(BuildContext context) {
    return LitPushedThroughButton(
      child: Row(
        children: [
          LinearNavigationIcon(
            mode: mode,
          ),
          const SizedBox(width: _spacing),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _maxWidth,
            ),
            child: ClippedText(
              label,
              style: LitSansSerifStyles.button,
            ),
          ),
          const SizedBox(width: _spacing),
        ],
      ),
      accentColor: LitColors.grey100,
      onPressed: onPressed,
    );
  }
}
