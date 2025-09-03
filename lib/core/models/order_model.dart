// order_model.dart
class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final double total;
  final String status;
  final int totalItems;
  final DateTime orderDate;
  final String estimatedDeliveryTime;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.total,
    required this.status,
    required this.totalItems,
    required this.orderDate,
    required this.estimatedDeliveryTime,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customer_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      total: (json['total'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Pending',
      totalItems: json['total_items'] ?? 0,
      orderDate: DateTime.tryParse(json['order_date'] ?? '') ?? DateTime.now(),
      estimatedDeliveryTime: json['estimated_delivery_time'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItemModel.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'total': total,
      'status': status,
      'total_items': totalItems,
      'order_date': orderDate.toIso8601String(),
      'estimated_delivery_time': estimatedDeliveryTime,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? deliveryAddress,
    double? total,
    String? status,
    int? totalItems,
    DateTime? orderDate,
    String? estimatedDeliveryTime,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      total: total ?? this.total,
      status: status ?? this.status,
      totalItems: totalItems ?? this.totalItems,
      orderDate: orderDate ?? this.orderDate,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      items: items ?? this.items,
    );
  }
}

// order_item_model.dart
class OrderItemModel {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String image;
  final String specialInstructions;

  OrderItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
    required this.specialInstructions,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0.0).toDouble(),
      image: json['image'] ?? '',
      specialInstructions: json['special_instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image': image,
      'special_instructions': specialInstructions,
    };
  }

  OrderItemModel copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? image,
    String? specialInstructions,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      image: image ?? this.image,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  double get totalPrice => price * quantity;
}