import 'package:hive/hive.dart';

part 'user_created_color.g.dart';

/// A model class storing an user-created `Color` object.
///
/// Each color channel is extracted into its own property.
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

  /// Creates an [UserCreatedColor] object.
  const UserCreatedColor({
    required this.uid,
    required this.alpha,
    required this.red,
    required this.green,
    required this.blue,
  });

  /// Creates an [UserCreatedColor] object by serializing the provided `Map`
  /// data.
  ///
  /// `JSON` decoding must be done before serialization.
  factory UserCreatedColor.fromJson(Map<String, dynamic> json) {
    return UserCreatedColor(
      uid: json['uid'] as String,
      alpha: json['alpha'] as int,
      red: json['red'] as int,
      green: json['green'] as int,
      blue: json['blue'] as int,
    );
  }

  /// Creates a `Map` object based on this [UserCreatedColor] object.
  ///
  /// `JSON` encoding must be done after serialization.
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'alpha': alpha,
        'red': red,
        'green': green,
        'blue': blue,
      };
}
