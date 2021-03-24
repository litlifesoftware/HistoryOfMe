import 'package:flutter/foundation.dart';

class BackdropPhoto {
  final int id;
  final String assetUrl;
  final String location;
  final String photographer;
  final String published;
  const BackdropPhoto({
    @required this.id,
    @required this.assetUrl,
    @required this.location,
    @required this.photographer,
    @required this.published,
  });

  factory BackdropPhoto.fromJson(Map<String, dynamic> json) {
    return BackdropPhoto(
      id: json['id'] as int,
      assetUrl: json['assetUrl'] as String,
      location: json['location'] as String,
      photographer: json['photographer'] as String,
      published: json['published'] as String,
    );
  }
}
