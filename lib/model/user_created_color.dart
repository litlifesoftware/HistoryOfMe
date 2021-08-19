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
    required this.uid,
    required this.alpha,
    required this.red,
    required this.green,
    required this.blue,
  });

  factory UserCreatedColor.fromJson(Map<String, dynamic> json) {
    return UserCreatedColor(
      uid: json['uid'] as String,
      alpha: json['alpha'] as int,
      red: json['red'] as int,
      green: json['green'] as int,
      blue: json['blue'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'alpha': alpha,
        'red': red,
        'green': green,
        'blue': blue,
      };
}
