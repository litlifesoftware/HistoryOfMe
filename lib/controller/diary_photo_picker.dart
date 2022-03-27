part of controllers;

// TODO: Empty out all previous photos on '.../files/ of a diary entry before
// picking new photos like it's already done with cached files.
// Make sure not to delete photos that are used by other diary entries.
class DiaryPhotoPicker {
  final void Function() onPickedUnsupportedFile;
  final void Function(DiaryEntry) onDeleteAllPhotos;
  DiaryPhotoPicker({
    required this.onPickedUnsupportedFile,
    required this.onDeleteAllPhotos,
  });

  void init() {
    _initPath();
  }

  final ImagePicker picker = ImagePicker();

  //List<XFile> images = [];
  bool unsupportedFile = false;

  Directory? storageDir;
  Directory? cacheDir;

  AppAPI _api = AppAPI();

  void _initPath() async {
    storageDir = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    cacheDir = await getTemporaryDirectory();

    if (storageDir != null && cacheDir != null) {
      print("app path according to path prov " + storageDir!.path);
      print("temp path according to path prov " + cacheDir!.path);
    }
  }

  /// Returns whether the provided diary photo has an image file stored on the
  /// device using the photo's path.
  ///
  /// If not, the corresponding photo cannot be displayed.
  bool imageFileExists(DiaryPhoto photo) {
    return File(
      photo.path,
    ).existsSync();
  }

  final String _dirErrorMessage = "Directories not initialized." +
      " " +
      "Ensure to call 'init()' to initialize all required objects.";

  /// Doesn't update the provided diary entry and therefore will not ask
  /// whether to apply an empty list of photos.
  Future<List<DiaryPhoto>> pickImagesWithoutUpdating(DiaryEntry entry) async {
    List<XFile?>? pickedImages = [];
    List<DiaryPhoto> diaryPhotos = [];
    List<XFile> images = [];

    if (storageDir == null) {
      print(_dirErrorMessage);
      return diaryPhotos;
    }

    try {
      pickedImages = await picker.pickMultiImage();
      if (pickedImages != null && pickedImages.length != 0) {
        images = [];
      }
    } catch (e) {
      unsupportedFile = true;
      onPickedUnsupportedFile();
    }

    if (pickedImages != null) {
      pickedImages.forEach(
        (XFile? element) async {
          if (element == null)
            return;
          else {
            //setState(() {
            images.add(element);
            //});
            // element.openRead();
            // Future<Uint8List> ele = await element.readAsBytes();
            // print(ele);
            //TODO: Store on app directory
            //TODO: copy to media directory to backup photos
            //maybe store photos as base64 string
            //TODO: make sure it will work on all version apps / error handling
            // TODO: include the base64 string in the photo model
            // TODO: extend backuping to backup photos.

            String uid = _api.generateUid();
            String fileName = uid + p.extension(element.path);
            String filePath = storageDir!.path + '/' + fileName;
            // Directory('/data/user/0/com.litlifesoftware.historyofme/images/')
            //     .create();

            //TODO: PICK STORE AND RETRIVE
            // Pick file, get path, genereate image name using uid, copy image to
            // app dir using custom image name (APPDIR/images/imagename.ext)
            // store list of image names on diary entry (we already know the
            // app dir path)
            // TODO: BACKUP and restore
            // Backup: Copy all images on APPDIR/images/ to Download/LitLifeSoftware/HistoryOfMe/images (loop all entries then loop all
            // images of the entry to get its image file paths)
            // Restore: Copy all images on Download/../images to APPDir/images/
            // (loop all entries then loop all images of the entry to get its image file path).
            try {
              element.saveTo(filePath).then((_) {
                try {
                  print("Trying to delete cached file on: " + element.path);
                  File(element.path).delete();
                } catch (e) {}
              });
            } catch (e) {
              print("Not saved propely");
            }

            print(filePath);

            // final dir = Directory(dirPath);
            // dir.deleteSync(recursive: true);

            diaryPhotos.add(
              DiaryPhoto(
                uid: uid,
                date: entry.date,
                created: new DateTime.now().millisecondsSinceEpoch,
                name: fileName,
                path: filePath,
              ),
            );
          }
        },
      );

      // Delete image cache.
      // if (cachePath != null) {
      //   cachePath!.deleteSync(recursive: true);
      //   print("Cached images deleted.");
      // } else {
      //   print("Cached images not delete, dir is null");
      // }
    }

    return diaryPhotos;
  }

  void pickImages(DiaryEntry entry) async {
    if (storageDir == null) {
      print(_dirErrorMessage);
      return;
    }

    //final ImagePicker _picker = ImagePicker();
    // final

    // setState(() {
    //   images = [];
    // })

    List<XFile?>? pickedImages = [];
    List<DiaryPhoto> diaryPhotos = [];
    List<XFile> images = [];

    try {
      pickedImages = await picker.pickMultiImage();
      if (pickedImages != null && pickedImages.length != 0) {
        images = [];
      }
    } catch (e) {
      unsupportedFile = true;
      onPickedUnsupportedFile();
    }

    if (pickedImages != null) {
      pickedImages.forEach(
        (XFile? element) async {
          if (element == null)
            return;
          else {
            //setState(() {
            images.add(element);
            //});
            // element.openRead();
            // Future<Uint8List> ele = await element.readAsBytes();
            // print(ele);
            //TODO: Store on app directory
            //TODO: copy to media directory to backup photos
            //maybe store photos as base64 string
            //TODO: make sure it will work on all version apps / error handling
            // TODO: include the base64 string in the photo model
            // TODO: extend backuping to backup photos.

            String uid = _api.generateUid();
            String fileName = uid + p.extension(element.path);
            String filePath = storageDir!.path + '/' + fileName;
            // Directory('/data/user/0/com.litlifesoftware.historyofme/images/')
            //     .create();

            //TODO: PICK STORE AND RETRIVE
            // Pick file, get path, genereate image name using uid, copy image to
            // app dir using custom image name (APPDIR/images/imagename.ext)
            // store list of image names on diary entry (we already know the
            // app dir path)
            // TODO: BACKUP and restore
            // Backup: Copy all images on APPDIR/images/ to Download/LitLifeSoftware/HistoryOfMe/images (loop all entries then loop all
            // images of the entry to get its image file paths)
            // Restore: Copy all images on Download/../images to APPDir/images/
            // (loop all entries then loop all images of the entry to get its image file path).
            try {
              element.saveTo(filePath).then((_) {
                try {
                  print("Trying to delete cached file on: " + element.path);
                  File(element.path).delete();
                } catch (e) {}
              });
            } catch (e) {
              print("Not saved propely");
            }

            print(filePath);

            // final dir = Directory(dirPath);
            // dir.deleteSync(recursive: true);

            diaryPhotos.add(
              DiaryPhoto(
                uid: uid,
                date: entry.date,
                created: new DateTime.now().millisecondsSinceEpoch,
                name: fileName,
                path: filePath,
              ),
            );
          }
        },
      );

      // Delete image cache.
      // if (cachePath != null) {
      //   cachePath!.deleteSync(recursive: true);
      //   print("Cached images deleted.");
      // } else {
      //   print("Cached images not delete, dir is null");
      // }
    }

    images.forEach((element) {
      print(element.path);
    });

    if (diaryPhotos.length != 0) {
      int nowTimestamp = new DateTime.now().millisecondsSinceEpoch;

      DiaryEntry updated = DiaryEntry(
        uid: entry.uid,
        date: entry.date,
        created: entry.created,
        // Update 'updated' timestamp
        lastUpdated: nowTimestamp,
        title: entry.title,
        content: entry.content,
        moodScore: entry.moodScore,
        favorite: entry.favorite,
        backdropPhotoId: entry.backdropPhotoId,
        // Include picked photos.
        photos: diaryPhotos,
      );

      _api.updateDiaryEntry(updated);

      // Delete image cache.
      // deleteCachedFiles();
    } else {
      if (!unsupportedFile) {
        onDeleteAllPhotos(entry);
      }
    }
  }

  // void deleteCachedFiles() async {
  //   await cacheDir.delete(recursive: true);
  //   print("Cached files deleted.");
  // }
}
