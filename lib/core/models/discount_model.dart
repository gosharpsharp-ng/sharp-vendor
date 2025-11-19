class DiscountModel {
  final int id;
  final String discountableType;
  final int discountableId;
  final String name;
  final String? code;
  final String? description;
  final String type;
  final double value;
  final double? maxDiscountAmount;
  final double? minOrderAmount;
  final int? buyQuantity;
  final int? getQuantity;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int? usageLimit;
  final int usageCount;
  final int? usageLimitPerUser;
  final String? applicableDays;
  final String? applicableTimeStart;
  final String? applicableTimeEnd;
  final String? applicableCategories;
  final String? excludedCategories;
  final String? badgeText;
  final String? badgeColor;
  final int priority;
  final bool isFeatured;
  final bool showOnListing;
  final String? termsAndConditions;
  final int createdBy;
  final int? updatedBy;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DiscountModel({
    required this.id,
    required this.discountableType,
    required this.discountableId,
    required this.name,
    this.code,
    this.description,
    required this.type,
    required this.value,
    this.maxDiscountAmount,
    this.minOrderAmount,
    this.buyQuantity,
    this.getQuantity,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.usageLimit,
    required this.usageCount,
    this.usageLimitPerUser,
    this.applicableDays,
    this.applicableTimeStart,
    this.applicableTimeEnd,
    this.applicableCategories,
    this.excludedCategories,
    this.badgeText,
    this.badgeColor,
    required this.priority,
    required this.isFeatured,
    required this.showOnListing,
    this.termsAndConditions,
    required this.createdBy,
    this.updatedBy,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] ?? 0,
      discountableType: json['discountable_type']?.toString() ?? '',
      discountableId: json['discountable_id'] ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
      description: json['description']?.toString(),
      type: json['type']?.toString() ?? 'percentage',
      value: double.tryParse(json['value']?.toString() ?? '0') ?? 0.0,
      maxDiscountAmount: json['max_discount_amount'] != null
          ? double.tryParse(json['max_discount_amount']?.toString() ?? '0')
          : null,
      minOrderAmount: json['min_order_amount'] != null
          ? double.tryParse(json['min_order_amount']?.toString() ?? '0')
          : null,
      buyQuantity: json['buy_quantity'] != null
          ? int.tryParse(json['buy_quantity']?.toString() ?? '0')
          : null,
      getQuantity: json['get_quantity'] != null
          ? int.tryParse(json['get_quantity']?.toString() ?? '0')
          : null,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now(),
      isActive: json['is_active'] is bool
          ? json['is_active']
          : (json['is_active']?.toString() == 'true' ||
              json['is_active']?.toString() == '1'),
      usageLimit: json['usage_limit'] != null
          ? int.tryParse(json['usage_limit']?.toString() ?? '0')
          : null,
      usageCount: int.tryParse(json['usage_count']?.toString() ?? '0') ?? 0,
      usageLimitPerUser: json['usage_limit_per_user'] != null
          ? int.tryParse(json['usage_limit_per_user']?.toString() ?? '0')
          : null,
      applicableDays: json['applicable_days']?.toString(),
      applicableTimeStart: json['applicable_time_start']?.toString(),
      applicableTimeEnd: json['applicable_time_end']?.toString(),
      applicableCategories: json['applicable_categories']?.toString(),
      excludedCategories: json['excluded_categories']?.toString(),
      badgeText: json['badge_text']?.toString(),
      badgeColor: json['badge_color']?.toString(),
      priority: int.tryParse(json['priority']?.toString() ?? '0') ?? 0,
      isFeatured: json['is_featured'] is bool
          ? json['is_featured']
          : (json['is_featured']?.toString() == 'true' ||
              json['is_featured']?.toString() == '1'),
      showOnListing: json['show_on_listing'] is bool
          ? json['show_on_listing']
          : (json['show_on_listing']?.toString() == 'true' ||
              json['show_on_listing']?.toString() == '1'),
      termsAndConditions: json['terms_and_conditions']?.toString(),
      createdBy: int.tryParse(json['created_by']?.toString() ?? '0') ?? 0,
      updatedBy: json['updated_by'] != null
          ? int.tryParse(json['updated_by']?.toString() ?? '0')
          : null,
      deletedAt:
          json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discountable_type': discountableType,
      'discountable_id': discountableId,
      'name': name,
      'code': code,
      'description': description,
      'type': type,
      'value': value,
      'max_discount_amount': maxDiscountAmount,
      'min_order_amount': minOrderAmount,
      'buy_quantity': buyQuantity,
      'get_quantity': getQuantity,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'usage_limit': usageLimit,
      'usage_count': usageCount,
      'usage_limit_per_user': usageLimitPerUser,
      'applicable_days': applicableDays,
      'applicable_time_start': applicableTimeStart,
      'applicable_time_end': applicableTimeEnd,
      'applicable_categories': applicableCategories,
      'excluded_categories': excludedCategories,
      'badge_text': badgeText,
      'badge_color': badgeColor,
      'priority': priority,
      'is_featured': isFeatured,
      'show_on_listing': showOnListing,
      'terms_and_conditions': termsAndConditions,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayValue {
    if (type == 'percentage') {
      return '${value.toStringAsFixed(0)}%';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }

  String get displayBadge {
    if (badgeText != null && badgeText!.isNotEmpty) {
      return badgeText!;
    }
    if (type == 'percentage') {
      return '${value.toStringAsFixed(0)}% OFF';
    } else {
      return '\$${value.toStringAsFixed(2)} OFF';
    }
  }

  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }

  bool get isNotStarted {
    return DateTime.now().isBefore(startDate);
  }

  bool get isCurrentlyActive {
    return isActive && !isExpired && !isNotStarted;
  }
}
