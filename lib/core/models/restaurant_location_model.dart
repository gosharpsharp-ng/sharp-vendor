class RestaurantLocation {
  final int id;
  final String name;
  final String latitude;
  final String longitude;
  final String locationableType;
  final int locationableId;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  RestaurantLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.locationableType,
    required this.locationableId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantLocation.fromJson(Map<String, dynamic> json) {
    return RestaurantLocation(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      latitude: json['latitude'] ?? '0.0',
      longitude: json['longitude'] ?? '0.0',
      locationableType: json['locationable_type'] ?? '',
      locationableId: json['locationable_id'] ?? 0,
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'locationable_type': locationableType,
      'locationable_id': locationableId,
      'deleted_at': deletedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convenience getters
  double get latitudeDouble => double.tryParse(latitude) ?? 0.0;
  double get longitudeDouble => double.tryParse(longitude) ?? 0.0;
}