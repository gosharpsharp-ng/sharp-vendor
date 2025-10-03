import 'restaurant_location_model.dart';
import 'restaurant_wallet_model.dart';
import 'restaurant_schedule_model.dart';
import 'bank_account_model.dart';

class RestaurantModel {
  final int id;
  final String? banner;
  final String? logo;
  final String name;
  final String? description;
  final String email;
  final String phone;
  final String cuisineType;
  final bool isActive;
  final bool isFeatured;
  final double commissionRate;
  final String? businessRegistrationNumber;
  final String? taxIdentificationNumber;
  final String status;
  final int userId;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RestaurantLocation? location;
  final RestaurantWallet? wallet;
  final BankAccount? bankAccount;
  final List<RestaurantSchedule> schedules;

  RestaurantModel({
    required this.id,
    this.banner,
    this.logo,
    required this.name,
    this.description,
    required this.email,
    required this.phone,
    required this.cuisineType,
    required this.isActive,
    required this.isFeatured,
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
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    // Parse schedules list
    List<RestaurantSchedule> schedulesList = [];
    if (json['schedules'] != null) {
      schedulesList = (json['schedules'] as List)
          .map((schedule) => RestaurantSchedule.fromJson(schedule))
          .toList();
    }

    return RestaurantModel(
      id: json['id'] ?? 0,
      banner: json['banner'],
      logo: json['logo'],
      name: json['name'] ?? '',
      description: json['description'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cuisineType: json['cuisine_type'] ?? '',
      isActive: (json['is_active'] ?? 0) == 1,
      isFeatured: (json['is_featured'] ?? 0) == 1,
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
          ? RestaurantLocation.fromJson(json['location'])
          : null,
      wallet: json['wallet'] != null
          ? RestaurantWallet.fromJson(json['wallet'])
          : null,
      bankAccount: json['bank_account'] != null
          ? BankAccount.fromJson(json['bank_account'])
          : null,
      schedules: schedulesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner': banner,
      'logo': logo,
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'cuisine_type': cuisineType,
      'is_active': isActive ? 1 : 0,
      'is_featured': isFeatured ? 1 : 0,
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
      'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
    };
  }
}
