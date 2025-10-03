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
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final filesJson = json['files'] as List<dynamic>? ?? [];
    // Try both 'addons' and 'addon_menus' keys
    final addonsJson = (json['addon_menus'] as List<dynamic>?) ??
                       (json['addons'] as List<dynamic>?) ??
                       [];

    return MenuItemModel(
      id: json['id']??1 ,
      name: json['name']?.toString() ?? '',
      category: CategoryModel.fromJson(json['category']),
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      duration: json['duration']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isAvailable: json['is_available'] is bool
          ? (json['is_available'] ? 1 : 0)
          : (int.tryParse(json['is_available']?.toString() ?? '1') ?? 1),
      availableQuantity: int.tryParse(json['available_quantity']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      plateSize: json['plate_size']?.toString(),
      showOnCustomerApp: json['show_on_customer_app'],
      files: filesJson.map((e) => ItemFileModel.fromJson(e)).toList(),
      addons: addonsJson.map((e) => MenuItemModel.fromJson(e)).toList(),
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
    };
  }


}

