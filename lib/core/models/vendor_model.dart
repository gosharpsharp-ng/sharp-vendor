import 'package:sharpvendor/core/config/vendor_config.dart';
import 'vendor_location_model.dart';
import 'vendor_wallet_model.dart';
import 'vendor_schedule_model.dart';
import 'bank_account_model.dart';
import 'commission_formula_model.dart';

class VendorModel {
  final int id;
  final String? banner;
  final String? bannerUrl;
  final String? logo;
  final String? logoUrl;
  final String name;
  final String? description;
  final String email;
  final String phone;

  /// The type/category of this vendor (e.g., cuisine type for restaurants,
  /// pharmacy type for pharmacies, store type for grocery stores)
  final String businessCategory;

  /// The vendor type (restaurant, pharmacy, grocery store, etc.)
  final VendorType vendorType;

  final bool isActive;
  final bool isFeatured;
  final bool isVerified;
  final bool freeDelivery;
  final bool isNew;
  final int featuredPriority;
  final String averageRating;
  final int totalOrders;
  final int totalReviews;
  final int viewsCount;
  final int favoritesCount;
  final DateTime? verifiedAt;
  final double commissionRate;
  final String? businessRegistrationNumber;
  final String? taxIdentificationNumber;
  final String status;
  final int userId;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VendorLocation? location;
  final VendorWallet? wallet;
  final BankAccount? bankAccount;
  final List<VendorSchedule> schedules;
  final List<dynamic> deliveryZones;
  final CommissionFormula? commissionFormula;

  VendorModel({
    required this.id,
    this.banner,
    this.bannerUrl,
    this.logo,
    this.logoUrl,
    required this.name,
    this.description,
    required this.email,
    required this.phone,
    required this.businessCategory,
    this.vendorType = VendorType.restaurant,
    required this.isActive,
    required this.isFeatured,
    this.isVerified = false,
    this.freeDelivery = false,
    this.isNew = false,
    this.featuredPriority = 0,
    this.averageRating = '0.00',
    this.totalOrders = 0,
    this.totalReviews = 0,
    this.viewsCount = 0,
    this.favoritesCount = 0,
    this.verifiedAt,
    required this.commissionRate,
    this.businessRegistrationNumber,
    this.taxIdentificationNumber,
    required this.status,
    required this.userId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.wallet,
    this.bankAccount,
    this.schedules = const [],
    this.deliveryZones = const [],
    this.commissionFormula,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    // Parse schedules list
    List<VendorSchedule> schedulesList = [];
    if (json['schedules'] != null) {
      schedulesList = (json['schedules'] as List)
          .map((schedule) => VendorSchedule.fromJson(schedule))
          .toList();
    }

    // Determine vendor type from API response
    VendorType vendorType = VendorTypeExtension.fromString(
      json['vendor_type'] ?? json['type'] ?? 'restaurant',
    );

    return VendorModel(
      id: json['id'] ?? 0,
      banner: json['banner'],
      bannerUrl: json['banner_url'],
      logo: json['logo'],
      logoUrl: json['logo_url'],
      name: json['name'] ?? '',
      description: json['description'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      // Support both new 'business_category' and legacy 'cuisine_type'
      businessCategory: json['business_category'] ?? json['cuisine_type'] ?? '',
      vendorType: vendorType,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      freeDelivery: json['free_delivery'] == true || json['free_delivery'] == 1,
      isNew: json['is_new'] == true || json['is_new'] == 1,
      featuredPriority: json['featured_priority'] ?? 0,
      averageRating: json['average_rating']?.toString() ?? '0.00',
      totalOrders: json['total_orders'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      favoritesCount: json['favorites_count'] ?? 0,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'])
          : null,
      commissionRate:
          double.tryParse(json['commission_rate']?.toString() ?? '0') ?? 0.0,
      businessRegistrationNumber: json['business_registration_number'],
      taxIdentificationNumber: json['tax_identification_number'],
      status: json['status'] ?? '',
      userId: json['user_id'] ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      location: json['location'] != null
          ? VendorLocation.fromJson(json['location'])
          : null,
      wallet: json['wallet'] != null
          ? VendorWallet.fromJson(json['wallet'])
          : null,
      bankAccount: json['bank_account'] != null
          ? BankAccount.fromJson(json['bank_account'])
          : null,
      schedules: schedulesList,
      deliveryZones: json['delivery_zones'] as List<dynamic>? ?? [],
      commissionFormula: json['commission_formula'] != null
          ? CommissionFormula.fromJson(json['commission_formula'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner': banner,
      'banner_url': bannerUrl,
      'logo': logo,
      'logo_url': logoUrl,
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'business_category': businessCategory,
      'cuisine_type': businessCategory, // For backward compatibility with API
      'vendor_type': vendorType.toApiString(),
      'is_active': isActive ? 1 : 0,
      'is_featured': isFeatured ? 1 : 0,
      'is_verified': isVerified ? 1 : 0,
      'free_delivery': freeDelivery ? 1 : 0,
      'is_new': isNew ? 1 : 0,
      'featured_priority': featuredPriority,
      'average_rating': averageRating,
      'total_orders': totalOrders,
      'total_reviews': totalReviews,
      'views_count': viewsCount,
      'favorites_count': favoritesCount,
      'verified_at': verifiedAt?.toIso8601String(),
      'commission_rate': commissionRate.toStringAsFixed(2),
      'business_registration_number': businessRegistrationNumber,
      'tax_identification_number': taxIdentificationNumber,
      'status': status,
      'user_id': userId,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'location': location?.toJson(),
      'wallet': wallet?.toJson(),
      'bank_account': bankAccount?.toJson(),
      'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
      'delivery_zones': deliveryZones,
      'commission_formula': commissionFormula?.toJson(),
    };
  }

  // ============ Backward Compatibility Getters ============

  /// Backward compatibility getter for cuisineType
  String get cuisineType => businessCategory;

  /// Get the display label for the business category field
  String get businessCategoryLabel => vendorType.categoryTypeLabel;
}

/// Type alias for backward compatibility
typedef RestaurantModel = VendorModel;
