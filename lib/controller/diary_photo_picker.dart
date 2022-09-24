part of controllers;

/// A `controller` class to pick image files and create [DiaryPhoto] objects
/// based on the selected image files.
class DiaryPhotoPicker {
  /// The total number of photos per entry.
  final int maxPhotos;

  /// Handles the action once `unsupported` file types are selected.
  final void Function() onPickedUnsupportedFile;

  /// Handles the `delete all photos` action.
  final void Function(DiaryEntry) onDeleteAllPhotos;

  /// Creates a [DiaryPhotoPicker].
  DiaryPhotoPicker({
    this.maxPhotos = _defaultMaxPhotos,
    required this.onPickedUnsupportedFile,
    required this.onDeleteAllPhotos,
  }) {
    init();
  }

  static const int _defaultMaxPhotos = 8;

  /// The error message displayed if the [Directory] instances failed to
  /// initialize.
  final String _dirErrMsg = "Directories not initialized." +
      " " +
      "Ensure to call 'init()' to initialize all required objects.";

  /// The [ImagePicker] instace used for picking image files using the system
  /// file explorer.
  final ImagePicker picker = ImagePicker();

  /// States whether the in the latest image picking action at least on
  /// file type is not supported.
  ///
  /// This will render the whole sequence of images invalid.
  bool unsupportedFile = false;

  /// The `storage` [Directory] instance, where picked images are copied to
  /// for persisting image files.
  Directory? storageDir;

  /// The `cache` [Directory] instance, where picked images are temporarily
  /// stored by the [ImagePicker].
  Directory? cacheDir;

  /// The [AppAPI] instance.
  AppAPI _api = AppAPI();

  /// Initiates the [Directory] instances.
  void _initPath() async {
    storageDir = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    cacheDir = await getTemporaryDirectory();
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

  /// Picks a list of image files using the System File Explorer and returns a
  /// [List] of selected [DiaryPhoto] elements.
  Future<List<DiaryPhoto>> pickPhotos(DiaryEntry entry) async {
    List<XFile?>? pickedImages = [];
    List<DiaryPhoto> diaryPhotos = [];
    List<XFile> images = [];
    int totalPhotosSelected = 0;

    if (storageDir == null) {
      print(_dirErrMsg);
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
          if (element == null) return;
          if (totalPhotosSelected > (maxPhotos - 1)) {
            return;
          } else {
            images.add(element);

            String uid = _api.generateUid();
            String fileName = uid + p.extension(element.path);
            String filePath = storageDir!.path + '/' + fileName;

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

            diaryPhotos.add(
              DiaryPhoto(
                uid: uid,
                date: entry.date,
                created: new DateTime.now().millisecondsSinceEpoch,
                name: fileName,
                path: filePath,
              ),
            );
            totalPhotosSelected++;
          }
        },
      );
    }

    return diaryPhotos;
  }

  /// Picks a list of image files using the System File Explorer and updates
  /// the provided [DiaryEntry] instance using the [List] of selected
  /// [DiaryPhoto] elements.
  Future<void> pickPhotosAndSave(DiaryEntry entry) async {
    List<DiaryPhoto> diaryPhotos = await pickPhotos(entry);

    if (diaryPhotos.length != 0) {
      int now = new DateTime.now().millisecondsSinceEpoch;

      DiaryEntry updated = DiaryEntry(
        uid: entry.uid,
        date: entry.date,
        created: entry.created,
        // Update 'updated' timestamp
        lastUpdated: now,
        title: entry.title,
        content: entry.content,
        moodScore: entry.moodScore,
        favorite: entry.favorite,
        backdropPhotoId: entry.backdropPhotoId,
        // Include picked photos.
        photos: diaryPhotos,
        visitCount: entry.visitCount,
        editCount: entry.editCount,
      );

      _api.updateDiaryEntry(updated);
    } else {
      if (!unsupportedFile) {
        onDeleteAllPhotos(entry);
      }
    }
  }

  /// Initalizes the [DiaryPhotoPicker].
  void init() {
    _initPath();
  }
}
