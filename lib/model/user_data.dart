import 'package:hive/hive.dart';

part 'user_data.g.dart';

/// A model class storing user-specific data as well as the currently edited
/// bookmark configuration.
@HiveType(typeId: 0)
class UserData {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int primaryColor;
  @HiveField(2)
  final int secondaryColor;
  @HiveField(3)
  final int stripeCount;
  @HiveField(4)
  final int dotSize;
  @HiveField(5)
  final bool animated;
  @HiveField(6)
  final String quote;
  @HiveField(7)
  final int designPatternIndex;
  @HiveField(8)
  final String quoteAuthor;
  @HiveField(9)
  final int lastUpdated;
  @HiveField(10)
  final int created;

  /// Creates an [UserData] object.
  const UserData({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.stripeCount,
    required this.dotSize,
    required this.animated,
    required this.quote,
    required this.designPatternIndex,
    required this.quoteAuthor,
    required this.lastUpdated,
    required this.created,
  });

  /// Creates an [UserData] object by serializing the provided `Map` data.
  ///
  /// `JSON` decoding must be done before serialization.
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] as String,
      primaryColor: json['primaryColor'] as int,
      secondaryColor: json['secondaryColor'] as int,
      stripeCount: json['stripeCount'] as int,
      dotSize: json['dotSize'] as int,
      animated: json['animated'] as bool,
      quote: json['quote'] as String,
      designPatternIndex: json['designPatternIndex'] as int,
      quoteAuthor: json['quoteAuthor'] as String,
      lastUpdated: json['lastUpdated'] as int,
      created: json['created'] as int,
    );
  }

  /// Creates a `Map` object based on this [UserData] object.
  ///
  /// `JSON` encoding must be done after serialization.
  Map<String, dynamic> toJson() => {
        'name': name,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'stripeCount': stripeCount,
        'dotSize': dotSize,
        'animated': animated,
        'quote': quote,
        'designPatternIndex': designPatternIndex,
        'quoteAuthor': quoteAuthor,
        'lastUpdated': lastUpdated,
        'created': created,
      };
}
