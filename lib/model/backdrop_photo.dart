class BackdropPhoto {
  final int? id;
  final String? assetUrl;
  final String? location;
  final String? photographer;
  final String? published;
  final String? description;
  const BackdropPhoto({
    required this.id,
    required this.assetUrl,
    required this.location,
    required this.photographer,
    required this.published,
    this.description,
  });

  factory BackdropPhoto.fromJson(Map<String, dynamic> json) {
    return BackdropPhoto(
      id: json['id'] as int?,
      assetUrl: json['assetUrl'] as String?,
      location: json['location'] as String?,
      photographer: json['photographer'] as String?,
      published: json['published'] as String?,
      description: json['description'] as String?,
    );
  }
}
