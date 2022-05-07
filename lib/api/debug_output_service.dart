part of api;

/// A class allowing to print debug output on various occasions.
class DebugOutputService {
  /// Prints a debug message stating that a file does not exists anymore.
  static void printImageFileStorageError(String path) {
    print(
      "Diary Photo on " + "'" + path + "'" + " does not exists anymore.",
    );
  }

  /// Prints a debug message stating that a file is already backed up.
  static void printBackedUpImageFileDuplicateError(String path) {
    print("Image File on " + "'" + path + "'" " already backed up.");
  }

  /// Prints a debug message stating that a file has been copied.
  static void printImageFileCopied(String path) {
    print(path + " copied.");
  }

  /// Prints a debug message stating that a file has been linked to a diary
  /// entry.
  static void printImageFileLinked(String path) {
    print("File: " + path + " is linked to a DiaryEntry");
  }

  /// Prints a debug message stating that an unused file has been deleted.
  static void printStorageImageFileDeleted(String path) {
    print("Unused application file on " + path + " " + "deleted.");
  }

  /// Prints a debug message stating that deleting a file has failed.
  static void printStorageImageFileDeletionError(String path) {
    print("Deleting duplicate file on: " + path + " failed.");
  }

  /// Prints a debug message stating that an unused file has been deleted.
  static void printBackedUpImageFileDeleted(String path) {
    print("Unused backed up image file on " + path + " " + "deleted.");
  }

  static void printBackedUpImageFileDeletionError(String path) {
    print("Deleting duplicate file on: " + path + " failed.");
  }
}
