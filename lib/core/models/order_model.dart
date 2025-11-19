import 'package:sharpvendor/core/models/restaurant_model.dart';
import 'package:sharpvendor/core/models/categories_model.dart';
import 'package:sharpvendor/core/models/item_file_model.dart';

// User Model - for order customer details
class UserModel {
  final int id;
  final String? avatar;
  final String fname;
  final String lname;
  final String phone;
  final String? dob;
  final String email;
  final String status;
  final String referralCode;
  final int? referredBy;
  final DateTime? lastLoginAt;
  final int failedLoginAttempts;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'])
          : null,
      failedLoginAttempts: json['failed_login_attempts'] ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
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
      'last_login_at': lastLoginAt?.toIso8601String(),
      'failed_login_attempts': failedLoginAttempts,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper getters
  String get fullName => '$fname $lname';
  String get initials {
    final firstInitial = fname.isNotEmpty ? fname[0].toUpperCase() : '';
    final lastInitial = lname.isNotEmpty ? lname[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }
}

// Payment Method Model
class PaymentMethodModel {
  final int id;
  final String name;
  final String code;
  final String description;
  final bool isActive;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.isActive,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] == 1,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Order Package Model - for grouped items
class OrderPackageModel {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final double total;
  final String? notes;
  final List<OrderPackageItemModel> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderPackageModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
    this.notes,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderPackageModel.fromJson(Map<String, dynamic> json) {
    return OrderPackageModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      notes: json['notes'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderPackageItemModel.fromJson(item))
          .toList() ?? [],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price.toString(),
      'total': total.toString(),
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Order Package Item Model - items within a package
class OrderPackageItemModel {
  final int id;
  final MenuItemModel menu;
  final int quantity;
  final double price;
  final double total;
  final dynamic options;
  final List<dynamic> addons;

  OrderPackageItemModel({
    required this.id,
    required this.menu,
    required this.quantity,
    required this.price,
    required this.total,
    this.options,
    required this.addons,
  });

  factory OrderPackageItemModel.fromJson(Map<String, dynamic> json) {
    // API sends 'orderable' field, but we store it as 'menu'
    final menuData = json['orderable'] ?? json['menu'];

    return OrderPackageItemModel(
      id: json['id'] ?? 0,
      menu: menuData != null ? MenuItemModel.fromJson(menuData) : MenuItemModel.fromJson({}),
      quantity: json['quantity'] ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      options: json['options'],
      addons: json['addons'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menu': menu.toJson(),
      'quantity': quantity,
      'price': price.toString(),
      'total': total.toString(),
      'options': options,
      'addons': addons,
    };
  }
}

// Menu Item Model - nested menu data within package items
class MenuItemModel {
  final int id;
  final int restaurantId;
  final String name;
  final String description;
  final String plateSize;
  final String packaging;
  final int quantity;
  final bool isAvailable;
  final double price;
  final int prepTimeMinutes;
  final int categoryId;
  final bool isPublished;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ItemFileModel> files;
  final CategoryModel? category;
  final RestaurantModel? restaurant;

  MenuItemModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.plateSize,
    required this.packaging,
    required this.quantity,
    required this.isAvailable,
    required this.price,
    required this.prepTimeMinutes,
    required this.categoryId,
    required this.isPublished,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.files,
    this.category,
    this.restaurant,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      plateSize: json['plate_size'] ?? '',
      packaging: json['packaging'] ?? '',
      quantity: json['quantity'] ?? 1,
      isAvailable: json['is_available'] == 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      prepTimeMinutes: json['prep_time_minutes'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      isPublished: json['is_published'] == 1,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => ItemFileModel.fromJson(e))
          .toList() ?? [],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      restaurant: json['restaurant'] != null
          ? RestaurantModel.fromJson(json['restaurant'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'plate_size': plateSize,
      'packaging': packaging,
      'quantity': quantity,
      'is_available': isAvailable ? 1 : 0,
      'price': price.toString(),
      'prep_time_minutes': prepTimeMinutes,
      'category_id': categoryId,
      'is_published': isPublished ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'files': files.map((e) => e.toJson()).toList(),
      'category': category?.toJson(),
      'restaurant': restaurant?.toJson(),
    };
  }
}

// Order Model
class OrderModel {
  final int id;
  final String orderableType;
  final int orderableId;
  final int userId;
  final String orderNumber;
  final String status;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final String deliveryType;
  final bool isDelivery;
  final String? deliveryInstructions;
  final String? scheduledDeliveryTime;
  final int? deliveryAddressId;
  final String notes;
  final int? discountId;
  final double discountAmount;
  final int? paymentMethodId;
  final PaymentMethodModel? paymentMethod;
  final String paymentReference;
  final double total;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? paidAt;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItemModel> items;
  final List<OrderPackageModel> packages;
  final List<OrderItemModel> allItems;
  final RestaurantModel? orderable;
  final DeliveryLocationModel? deliveryLocation;
  final dynamic discount;
  final UserModel? user;

  OrderModel({
    required this.id,
    required this.orderableType,
    required this.orderableId,
    required this.userId,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.deliveryType,
    required this.isDelivery,
    this.deliveryInstructions,
    this.scheduledDeliveryTime,
    this.deliveryAddressId,
    required this.notes,
    this.discountId,
    required this.discountAmount,
    this.paymentMethodId,
    this.paymentMethod,
    required this.paymentReference,
    required this.total,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
    this.paidAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.packages,
    required this.allItems,
    this.orderable,
    this.deliveryLocation,
    this.discount,
    this.user,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderableType: json['orderable_type'] ?? '',
      orderableId: json['orderable_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? 'pending',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0.0,
      deliveryFee: double.tryParse(json['delivery_fee']?.toString() ?? '0') ?? 0.0,
      deliveryType: json['delivery_type'] ?? 'standard',
      isDelivery: json['is_delivery'] == 1,
      deliveryInstructions: json['delivery_instructions'],
      scheduledDeliveryTime: json['scheduled_delivery_time'],
      deliveryAddressId: json['delivery_address_id'],
      notes: json['notes'] ?? '',
      discountId: json['discount_id'],
      discountAmount: double.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0.0,
      paymentMethodId: json['payment_method_id'],
      paymentMethod: json['payment_method'] != null && json['payment_method'] is Map
          ? PaymentMethodModel.fromJson(json['payment_method'])
          : null,
      paymentReference: json['payment_reference'] ?? json['payment_method'] ?? '',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.tryParse(json['confirmed_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.tryParse(json['cancelled_at'])
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItemModel.fromJson(item))
          .toList() ?? [],
      packages: (json['packages'] as List<dynamic>?)
          ?.map((pkg) => OrderPackageModel.fromJson(pkg))
          .toList() ?? [],
      allItems: (json['all_items'] as List<dynamic>?)
          ?.map((item) => OrderItemModel.fromJson(item))
          .toList() ?? [],
      orderable: json['orderable'] != null
          ? RestaurantModel.fromJson(json['orderable'])
          : null,
      deliveryLocation: json['delivery_location'] != null
          ? DeliveryLocationModel.fromJson(json['delivery_location'])
          : null,
      discount: json['discount'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderable_type': orderableType,
      'orderable_id': orderableId,
      'user_id': userId,
      'order_number': orderNumber,
      'status': status,
      'subtotal': subtotal.toString(),
      'tax': tax.toString(),
      'delivery_fee': deliveryFee.toString(),
      'delivery_type': deliveryType,
      'is_delivery': isDelivery ? 1 : 0,
      'delivery_instructions': deliveryInstructions,
      'scheduled_delivery_time': scheduledDeliveryTime,
      'delivery_address_id': deliveryAddressId,
      'notes': notes,
      'discount_id': discountId,
      'discount_amount': discountAmount.toString(),
      'payment_method_id': paymentMethodId,
      'payment_method': paymentMethod?.toJson(),
      'payment_reference': paymentReference,
      'total': total.toString(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'packages': packages.map((pkg) => pkg.toJson()).toList(),
      'all_items': allItems.map((item) => item.toJson()).toList(),
      'orderable': orderable?.toJson(),
      'delivery_location': deliveryLocation?.toJson(),
      'discount': discount,
      'user': user?.toJson(),
    };
  }

  OrderModel copyWith({
    int? id,
    String? orderableType,
    int? orderableId,
    int? userId,
    String? orderNumber,
    String? status,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    String? deliveryType,
    bool? isDelivery,
    String? deliveryInstructions,
    String? scheduledDeliveryTime,
    int? deliveryAddressId,
    String? notes,
    int? discountId,
    double? discountAmount,
    int? paymentMethodId,
    PaymentMethodModel? paymentMethod,
    String? paymentReference,
    double? total,
    DateTime? confirmedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? paidAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemModel>? items,
    List<OrderPackageModel>? packages,
    List<OrderItemModel>? allItems,
    RestaurantModel? orderable,
    DeliveryLocationModel? deliveryLocation,
    dynamic discount,
    UserModel? user,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderableType: orderableType ?? this.orderableType,
      orderableId: orderableId ?? this.orderableId,
      userId: userId ?? this.userId,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryType: deliveryType ?? this.deliveryType,
      isDelivery: isDelivery ?? this.isDelivery,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      scheduledDeliveryTime: scheduledDeliveryTime ?? this.scheduledDeliveryTime,
      deliveryAddressId: deliveryAddressId ?? this.deliveryAddressId,
      notes: notes ?? this.notes,
      discountId: discountId ?? this.discountId,
      discountAmount: discountAmount ?? this.discountAmount,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentReference: paymentReference ?? this.paymentReference,
      total: total ?? this.total,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      paidAt: paidAt ?? this.paidAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      packages: packages ?? this.packages,
      allItems: allItems ?? this.allItems,
      orderable: orderable ?? this.orderable,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      discount: discount ?? this.discount,
      user: user ?? this.user,
    );
  }

  // Helper getters for backward compatibility
  String get customerId => userId.toString();
  String get restaurantName => orderable?.name ?? 'Unknown Restaurant';
  String get deliveryAddress => deliveryLocation?.name ?? '';
  DateTime get orderDate => createdAt;
  String get estimatedDeliveryTime => "25-30 mins"; // You can calculate this based on your logic
  int get totalItems {
    // Calculate from packages if they exist, otherwise from items
    if (packages.isNotEmpty) {
      return packages.fold(0, (sum, pkg) => sum + pkg.items.fold(0, (itemSum, item) => itemSum + item.quantity));
    }
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
  String get ref => orderNumber; // For backward compatibility

  // Customer info from the user object
  String get customerName => user?.fullName ?? "";
  String get customerPhone => user?.phone ?? "";
  String get customerEmail => user?.email ?? "";
  String get customerAvatar => user?.avatar ?? "";
  String get customerInitials => user?.initials ?? "";

  // Payment method name
  String get paymentMethodName => paymentMethod?.name ?? 'N/A';
}

// Order Item Model - Updated to match API structure with menu object
class OrderItemModel {
  final int id;
  final int orderId;
  final int? packageId;
  final MenuItemModel? menu;
  final dynamic options;
  final int quantity;
  final double price;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> addons;

  OrderItemModel({
    required this.id,
    required this.orderId,
    this.packageId,
    this.menu,
    this.options,
    required this.quantity,
    required this.price,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.addons,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      packageId: json['package_id'],
      menu: json['menu'] != null ? MenuItemModel.fromJson(json['menu']) : null,
      options: json['options'],
      quantity: json['quantity'] ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      addons: json['addons'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'package_id': packageId,
      'menu': menu?.toJson(),
      'options': options,
      'quantity': quantity,
      'price': price.toString(),
      'total': total.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'addons': addons,
    };
  }

  OrderItemModel copyWith({
    int? id,
    int? orderId,
    int? packageId,
    MenuItemModel? menu,
    dynamic options,
    int? quantity,
    double? price,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<dynamic>? addons,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      packageId: packageId ?? this.packageId,
      menu: menu ?? this.menu,
      options: options ?? this.options,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      addons: addons ?? this.addons,
    );
  }

  // Helper getters for backward compatibility
  String get name => menu?.name ?? 'Unknown Item';
  String get image => menu?.files.isNotEmpty == true ? menu!.files.first.url : "";
  String get description => menu?.description ?? '';
  String get plateSize => menu?.plateSize ?? '';
  String get specialInstructions => options?.toString() ?? "";
  double get totalPrice => total;
}

// Delivery Location Model - keeping existing structure
class DeliveryLocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String locationableType;
  final int locationableId;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryLocationModel({
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

  factory DeliveryLocationModel.fromJson(Map<String, dynamic> json) {
    return DeliveryLocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      locationableType: json['locationable_type'] ?? '',
      locationableId: json['locationable_id'] ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'locationable_type': locationableType,
      'locationable_id': locationableId,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}