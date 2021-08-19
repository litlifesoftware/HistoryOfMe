import 'package:hive/hive.dart';

part 'user_data.g.dart';

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

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      primaryColor: json['primaryColor'],
      secondaryColor: json['secondaryColor'],
      stripeCount: json['stripeCount'],
      dotSize: json['dotSize'],
      animated: json['animated'],
      quote: json['quote'],
      designPatternIndex: json['designPatternIndex'],
      quoteAuthor: json['quoteAuthor'],
      lastUpdated: json['lastUpdated'],
      created: json['created'],
    );
  }

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
