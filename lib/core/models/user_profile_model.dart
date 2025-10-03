import 'restaurant_model.dart';

class UserProfile {
  final int id;
  final String? avatar;
  final String fname;
  final String lname;
  final String phone;
  final String? dob;
  final String email;
  final String status;
  final String referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int failedLoginAttempts;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RestaurantModel? restaurant;
  final List<dynamic> ratings;

  UserProfile({
    required this.id,
    this.avatar,
    required this.fname,
    required this.lname,
    required this.phone,
    this.dob,
    required this.email,
    required this.status,
    required this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.restaurant,
    this.ratings = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      avatar: json['avatar'],
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      phone: json['phone'] ?? '',
      dob: json['dob'],
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      referralCode: json['referral_code'] ?? '',
      referredBy: json['referred_by'],
      lastLoginAt: json['last_login_at'],
      failedLoginAttempts: json['failed_login_attempts'] ?? 0,
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      restaurant: json['restaurant'] != null ? RestaurantModel.fromJson(json['restaurant']) : null,
      ratings: json['ratings'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'dob': dob,
      'email': email,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'deleted_at': deletedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'restaurant': restaurant?.toJson(),
      'ratings': ratings,
    };
  }

  // Convenience getter for full name
  String get fullName => '$fname $lname';

  // Convenience getter to check if user is verified
  bool get isVerified => status == 'verified';

  // Convenience getter to check if user is active (not deleted)
  bool get isActive => deletedAt == null;
}