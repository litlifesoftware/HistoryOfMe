import 'package:hive_flutter/hive_flutter.dart';

part 'diary_photo.g.dart';

/// A `model` class storing data of a image file linked to a diary entry.
@HiveType(typeId: 4)
class DiaryPhoto {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String date;
  @HiveField(2)
  final int created;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String path;

  /// Creates a [DiaryPhoto].
  const DiaryPhoto({
    required this.uid,
    required this.date,
    required this.created,
    required this.name,
    required this.path,
  });

  /// Creates an [DiaryPhoto] object by serializing the provided `Map`
  /// data.
  ///
  /// `JSON` decoding must be done before serialization.
  factory DiaryPhoto.fromJson(Map<String, dynamic> json) => DiaryPhoto(
        uid: json['uid'] as String,
        date: json['date'] as String,
        created: json['created'] as int,
        name: json['name'] as String,
        path: json['path'] as String,
      );

  /// Creates a `Map` object based on this [UserCreatedColor] object.
  ///
  /// `JSON` encoding must be done after serialization.
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'date': date,
        'created': created,
        'name': name,
        'path': path,
      };
}
