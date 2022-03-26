import 'dart:convert';

import 'diary_photo.dart';
import 'package:hive/hive.dart';
part 'diary_entry.g.dart';

/// A model class storing data specific to an individual diary entry.
///
/// It contains the diaries content as well as meta data.
@HiveType(typeId: 2)
class DiaryEntry {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String date;
  @HiveField(2)
  final int created;
  @HiveField(3)
  final int lastUpdated;
  @HiveField(4)
  final String title;
  @HiveField(5)
  final String content;
  @HiveField(6)
  final double moodScore;
  @HiveField(7)
  final bool favorite;
  @HiveField(8)
  final int backdropPhotoId;
  @HiveField(9)
  final List<DiaryPhoto>? photos;

  /// Creates a [DiaryEntry] object.
  const DiaryEntry({
    required this.uid,
    required this.date,
    required this.created,
    required this.lastUpdated,
    required this.title,
    required this.content,
    required this.moodScore,
    required this.favorite,
    required this.backdropPhotoId,
    required this.photos,
  });

  /// Creates a [DiaryEntry] object by serializing the provided `Map` data.
  ///
  /// `JSON` decoding must be done before serialization.
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    /// Contains all `DiaryPhoto` objects.
    List<DiaryPhoto>? photos = [];

    if (json.containsKey('photos')) {
      photos = List<DiaryPhoto>.from(
        jsonDecode(json['photos']).map(
          (item) => DiaryPhoto.fromJson(item),
        ),
      );
    }

    return DiaryEntry(
      uid: json['uid'] as String,
      date: json['date'] as String,
      created: json['created'] as int,
      lastUpdated: json['lastUpdated'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      moodScore: json['moodScore'] as double,
      favorite: json['favorite'] as bool,
      backdropPhotoId: json['backdropPhotoId'] as int,
      photos: photos,
    );
  }

  /// Creates a `Map` object based on this [DiaryEntry] object.
  ///
  /// `JSON` encoding must be done after serialization.
  Map<String, dynamic> toJson() {
    final photosMap = photos != null
        ? jsonEncode(photos!.map((item) => item.toJson()).toList())
        : Map();
    print(photosMap.toString());

    return {
      'uid': uid,
      'date': date,
      'created': created,
      'lastUpdated': lastUpdated,
      'title': title,
      'content': content,
      'moodScore': moodScore,
      'favorite': favorite,
      'backdropPhotoId': backdropPhotoId,
      'photos': photosMap,
    };
  }
}
