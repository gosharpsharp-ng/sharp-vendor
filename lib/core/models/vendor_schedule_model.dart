class VendorSchedule {
  final int id;
  final int vendorId;
  final String dayOfWeek;
  final DateTime openTime;
  final DateTime closeTime;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  VendorSchedule({
    required this.id,
    required this.vendorId,
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VendorSchedule.fromJson(Map<String, dynamic> json) {
    return VendorSchedule(
      id: json['id'] ?? 0,
      // Support both 'vendor_id' and 'restaurant_id' for backward compatibility
      vendorId: json['vendor_id'] ?? json['restaurant_id'] ?? 0,
      dayOfWeek: json['day_of_week'] ?? '',
      openTime: DateTime.parse(json['open_time']),
      closeTime: DateTime.parse(json['close_time']),
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor_id': vendorId,
      'day_of_week': dayOfWeek,
      'open_time': openTime.toIso8601String(),
      'close_time': closeTime.toIso8601String(),
      'deleted_at': deletedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Convenience getters
  String get formattedOpenTime {
    return "${openTime.hour.toString().padLeft(2, '0')}:${openTime.minute.toString().padLeft(2, '0')}";
  }

  String get formattedCloseTime {
    return "${closeTime.hour.toString().padLeft(2, '0')}:${closeTime.minute.toString().padLeft(2, '0')}";
  }

  String get timeRange => "$formattedOpenTime - $formattedCloseTime";

  /// Backward compatibility getter
  int get restaurantId => vendorId;
}

/// Type alias for backward compatibility
typedef RestaurantSchedule = VendorSchedule;
