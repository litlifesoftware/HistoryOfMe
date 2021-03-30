import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final int? bookmarkColor;
  @HiveField(2)
  final int? stripeCount;
  @HiveField(3)
  final int? dotSize;
  @HiveField(4)
  final bool? animated;
  @HiveField(5)
  final String? quote;
  @HiveField(6)
  final int? designPatternIndex;
  @HiveField(7)
  final String? quoteAuthor;
  @HiveField(8)
  final int? lastUpdated;
  const UserData({
    required this.name,
    required this.bookmarkColor,
    required this.stripeCount,
    required this.dotSize,
    required this.animated,
    required this.quote,
    required this.designPatternIndex,
    required this.quoteAuthor,
    required this.lastUpdated,
  });
}
