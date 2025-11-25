import 'package:sharpvendor/core/models/categories_model.dart';
import 'package:sharpvendor/core/models/restaurant_model.dart';

import 'item_file_model.dart';

class MenuItemModel {
  final int id;
  final String name;
  final CategoryModel category;
  final double price;
  final String duration;
  final RestaurantModel restaurant;
  final String image;
  final int isAvailable;
  final int availableQuantity;
  final String? description;
  final String? plateSize;
  final List<ItemFileModel> files;
  final bool? showOnCustomerApp;
  final List<MenuItemModel> addons;
  final double? packagingPrice;

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
    required this.restaurant,
    this.plateSize,
    this.showOnCustomerApp,
    required this.files,
    this.addons = const [],
    this.packagingPrice,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    // Handle files with null safety
    final filesJson = json['files'] as List<dynamic>? ?? [];

    // Try both 'addons' and 'addon_menus' keys with proper null safety
    List<dynamic> addonsJson = [];
    try {
      addonsJson =
          (json['addon_menus'] as List<dynamic>?) ??
          (json['addons'] as List<dynamic>?) ??
          [];
    } catch (e) {
      addonsJson = [];
    }

    // Parse addons with error handling to prevent circular reference issues
    List<MenuItemModel> addonsList = [];
    try {
      addonsList = addonsJson
          .where((e) => e != null && e is Map<String, dynamic>)
          .map((e) {
            try {
              return MenuItemModel.fromJson(e as Map<String, dynamic>);
            } catch (addonError) {
              // Skip invalid addon entries
              return null;
            }
          })
          .where((e) => e != null)
          .cast<MenuItemModel>()
          .toList();
    } catch (e) {
      addonsList = [];
    }

    return MenuItemModel(
      id: json['id'] ?? 1,
      name: json['name']?.toString() ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : CategoryModel(id: 0, name: 'Unknown', description: ''),
      restaurant: json['restaurant'] != null
          ? RestaurantModel.fromJson(json['restaurant'])
          : RestaurantModel(
              id: 0,
              name: 'Unknown',
              email: '',
              phone: '',
              cuisineType: '',
              isActive: false,
              isFeatured: false,
              commissionRate: 0.0,
              status: '',
              userId: 0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      duration: json['prep_time_minutes']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isAvailable: json['is_available'] is bool
          ? (json['is_available'] ? 1 : 0)
          : (int.tryParse(json['is_available']?.toString() ?? '1') ?? 1),
      availableQuantity:
          int.tryParse(json['available_quantity']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      plateSize: json['plate_size']?.toString(),
      showOnCustomerApp: json['show_on_customer_app'] is bool
          ? json['show_on_customer_app']
          : (json['show_on_customer_app']?.toString() == 'true' ||
                json['show_on_customer_app']?.toString() == '1'),
      files: filesJson
          .where((e) => e != null)
          .map((e) {
            try {
              return ItemFileModel.fromJson(e);
            } catch (fileError) {
              return null;
            }
          })
          .where((e) => e != null)
          .cast<ItemFileModel>()
          .toList(),
      addons: addonsList,
      packagingPrice: json['packaging_price'] != null
          ? double.tryParse(json['packaging_price']?.toString() ?? '0')
          : null,
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
      'files': files,
      'addons': addons.map((e) => e.toJson()).toList(),
      'packaging_price': packagingPrice,
    };
  }
}
