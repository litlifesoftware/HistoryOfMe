import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'user_created_color.g.dart';

@HiveType(typeId: 1)
class UserCreatedColor {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final int alpha;
  @HiveField(2)
  final int red;
  @HiveField(3)
  final int green;
  @HiveField(4)
  final int blue;

  const UserCreatedColor({
    @required this.uid,
    @required this.alpha,
    @required this.red,
    @required this.green,
    @required this.blue,
  });
}
