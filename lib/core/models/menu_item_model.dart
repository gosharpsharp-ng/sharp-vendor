class MenuItemModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String duration;
  final String image;
  final bool isAvailable;
  final int availableQuantity;
  final String? description;
  final String? plateSize;
  final bool? showOnCustomerApp;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.duration,
    required this.image,
    required this.isAvailable,
    required this.availableQuantity,
    this.description,
    this.plateSize,
    this.showOnCustomerApp,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      duration: json['duration']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isAvailable: json['is_available'] ?? true,
      availableQuantity: int.tryParse(json['available_quantity']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      plateSize: json['plate_size']?.toString(),
      showOnCustomerApp: json['show_on_customer_app'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'duration': duration,
      'image': image,
      'is_available': isAvailable,
      'available_quantity': availableQuantity,
      'description': description,
      'plate_size': plateSize,
      'show_on_customer_app': showOnCustomerApp,
    };
  }
}