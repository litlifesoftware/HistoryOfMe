part of controllers;

/// Controller class to find the requested backdrop photo based on its id passed
/// on using the [DiaryEntry].
///
/// The [BackdropPhotoController] must not be initialized on state of a stateful widget.
/// Its corresponding methods to find the desired information should be called on
/// separate objects initialized on the build method itself to ensure the backdrop
/// photo will be updated on the view, once the database information is updated.
///
/// Updating the [DiaryEntry] will result in an updated BackdropPhoto, therefore the
/// object will have to be found again on 'build'.
class BackdropPhotoController {
  final List<BackdropPhoto> backdropPhotos;
  final DiaryEntry diaryEntry;

  /// Creates a [BackdropPhotoController].
  ///
  /// * [backdropPhotos] is the list of available photos.
  ///
  /// * [diaryEntry] is the diary entry that contains the backdrop id.
  const BackdropPhotoController(this.backdropPhotos, this.diaryEntry);

  /// Finds and returns the [BackdropPhoto] based on its id.
  ///
  /// If the provided id does not match with any of the available backdrop photos
  /// the first backdrop photo in the list is returned.
  BackdropPhoto findBackdropPhoto() {
    BackdropPhoto backdropPhotoWhere;
    try {
      backdropPhotoWhere = backdropPhotos.firstWhere(
        (photo) => photo.id == diaryEntry.backdropPhotoId,
      );
      return backdropPhotoWhere;
    } catch (e) {
      print("ERROR: Backdrop photo not found... \n$e");
      return backdropPhotos[0];
    }
  }

  /// Finds and returns the [BackdropPhoto]'s assetUrl value  based on its id.
  ///
  /// If the provided id does not match with any of the available backdrop photos
  /// the first backdrop photo in the list is returned.
  String? findBackdropPhotoUrl() {
    return findBackdropPhoto().assetUrl;
  }

  /// Finds and returns the [BackdropPhoto]'s location value  based on its id.
  ///
  /// If the provided id does not match with any of the available backdrop photos
  /// the first backdrop photo in the list is returned.
  String? findBackdropPhotoLocation() {
    return findBackdropPhoto().location;
  }

  /// Finds and returns the [BackdropPhoto]'s photographer value  based on its id.
  ///
  /// If the provided id does not match with any of the available backdrop photos
  /// the first backdrop photo in the list is returned.
  String? findBackdropPhotoPhotographer() {
    return findBackdropPhoto().photographer;
  }
}
