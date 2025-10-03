class Transaction {
  final int id;
  final int userId;
  final String paymentReference;
  final String amount;
  final String type;
  final String description;
  final String status;
  final int? currencyId;
  final int? paymentMethodId;
  final int? gatewayId;
  final String payableType;
  final int payableId;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final Payable? payable;
  final dynamic currency;
  final dynamic paymentMethod;
  final dynamic gateway;

  Transaction({
    required this.id,
    required this.userId,
    required this.paymentReference,
    required this.amount,
    required this.type,
    required this.description,
    required this.status,
    this.currencyId,
    this.paymentMethodId,
    this.gatewayId,
    required this.payableType,
    required this.payableId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.payable,
    this.currency,
    this.paymentMethod,
    this.gateway,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    userId: json['user_id'],
    paymentReference: json['payment_reference'],
    amount: json['amount'],
    type: json['type'],
    description: json['description'],
    status: json['status'],
    currencyId: json['currency_id'],
    paymentMethodId: json['payment_method_id'],
    gatewayId: json['gateway_id'],
    payableType: json['payable_type'],
    payableId: json['payable_id'],
    deletedAt: json['deleted_at'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    payable:
    json['payable'] != null ? Payable.fromJson(json['payable']) : null,
    currency: json['currency'],
    paymentMethod: json['payment_method'],
    gateway: json['gateway'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'payment_reference': paymentReference,
    'amount': amount,
    'type': type,
    'description': description,
    'status': status,
    'currency_id': currencyId,
    'payment_method_id': paymentMethodId,
    'gateway_id': gatewayId,
    'payable_type': payableType,
    'payable_id': payableId,
    'deleted_at': deletedAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'payable': payable?.toJson(),
    'currency': currency,
    'payment_method': paymentMethod,
    'gateway': gateway,
  };

  // Convenience getters for better data handling
  double get amountDouble => double.tryParse(amount) ?? 0.0;

  bool get isCredit => type.toLowerCase() == 'credit';
  bool get isDebit => type.toLowerCase() == 'debit';

  bool get isSuccessful => status.toLowerCase() == 'successful';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';

  DateTime? get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  DateTime? get updatedAtDateTime {
    try {
      return DateTime.parse(updatedAt);
    } catch (e) {
      return null;
    }
  }

  String get formattedCreatedAt {
    final date = createdAtDateTime;
    if (date == null) return createdAt;

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class Payable {
  final int id;
  final String? banner;
  final String? logo;
  final String name;
  final String description;
  final String email;
  final String phone;
  final String cuisineType;
  final int isActive;
  final int isFeatured;
  final String commissionRate;
  final String businessRegistrationNumber;
  final String taxIdentificationNumber;
  final String status;
  final int userId;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  Payable({
    required this.id,
    this.banner,
    this.logo,
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.cuisineType,
    required this.isActive,
    required this.isFeatured,
    required this.commissionRate,
    required this.businessRegistrationNumber,
    required this.taxIdentificationNumber,
    required this.status,
    required this.userId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payable.fromJson(Map<String, dynamic> json) => Payable(
    id: json['id'],
    banner: json['banner'],
    logo: json['logo'],
    name: json['name'],
    description: json['description'],
    email: json['email'],
    phone: json['phone'],
    cuisineType: json['cuisine_type'],
    isActive: json['is_active'],
    isFeatured: json['is_featured'],
    commissionRate: json['commission_rate'],
    businessRegistrationNumber: json['business_registration_number'],
    taxIdentificationNumber: json['tax_identification_number'],
    status: json['status'],
    userId: json['user_id'],
    deletedAt: json['deleted_at'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'banner': banner,
    'logo': logo,
    'name': name,
    'description': description,
    'email': email,
    'phone': phone,
    'cuisine_type': cuisineType,
    'is_active': isActive,
    'is_featured': isFeatured,
    'commission_rate': commissionRate,
    'business_registration_number': businessRegistrationNumber,
    'tax_identification_number': taxIdentificationNumber,
    'status': status,
    'user_id': userId,
    'deleted_at': deletedAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
