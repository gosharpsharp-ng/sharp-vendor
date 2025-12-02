import 'vendor_model.dart';

class UserProfile {
  final int id;
  final String? avatar;
  final String? avatarUrl;
  final String fname;
  final String lname;
  final String phone;
  final String? dob;
  final String? deviceTokenUpdatedAt;
  final String email;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String status;
  final String referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int failedLoginAttempts;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VendorModel? vendor;
  final List<dynamic> ratings;
  final dynamic bankAccount;

  UserProfile({
    required this.id,
    this.avatar,
    this.avatarUrl,
    required this.fname,
    required this.lname,
    required this.phone,
    this.dob,
    this.deviceTokenUpdatedAt,
    required this.email,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    required this.status,
    required this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.vendor,
    this.ratings = const [],
    this.bankAccount,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Support both 'vendor' and legacy 'restaurant' keys from API
    final vendorJson = json['vendor'] ?? json['restaurant'];

    return UserProfile(
      id: json['id'] ?? 0,
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      phone: json['phone'] ?? '',
      dob: json['dob'],
      deviceTokenUpdatedAt: json['device_token_updated_at'],
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      phoneVerifiedAt: json['phone_verified_at'],
      status: json['status'] ?? '',
      referralCode: json['referral_code'] ?? '',
      referredBy: json['referred_by'],
      lastLoginAt: json['last_login_at'],
      failedLoginAttempts: json['failed_login_attempts'] ?? 0,
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      vendor: vendorJson != null ? VendorModel.fromJson(vendorJson) : null,
      ratings: json['ratings'] ?? [],
      bankAccount: json['bank_account'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'dob': dob,
      'device_token_updated_at': deviceTokenUpdatedAt,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'phone_verified_at': phoneVerifiedAt,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'deleted_at': deletedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'vendor': vendor?.toJson(),
      'restaurant': vendor?.toJson(), // For backward compatibility with API
      'ratings': ratings,
      'bank_account': bankAccount,
    };
  }

  // ============ Backward Compatibility ============

  /// Backward compatibility getter for restaurant
  VendorModel? get restaurant => vendor;

  // Convenience getter for full name
  String get fullName => '$fname $lname';

  // Convenience getter to check if user is verified
  bool get isVerified => status == 'verified';

  // Convenience getter to check if user is active (not deleted)
  bool get isActive => deletedAt == null;
}