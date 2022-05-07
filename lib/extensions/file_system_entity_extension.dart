part of extensions;

/// Extends the abstract [FileSystemEntity] class using additional methods and
/// properties.
extension FileSystemEntityExtention on FileSystemEntity {
  String get _splitPattern => "/";

  String get name {
    return this.path.split(_splitPattern).last;
  }
}
