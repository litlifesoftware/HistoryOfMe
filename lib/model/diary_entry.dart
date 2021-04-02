import 'package:hive/hive.dart';

part 'diary_entry.g.dart';

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
  });
}
