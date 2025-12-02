import 'package:sharpvendor/core/models/categories_model.dart';
import 'package:sharpvendor/core/models/vendor_model.dart';

import 'item_file_model.dart';

/// Generic product model that can represent items from any vendor type
/// (menu items for restaurants, medicines for pharmacies, products for stores, etc.)
class ProductModel {
  final int id;
  final String name;
  final CategoryModel category;
  final double price;

  /// Processing/preparation time in minutes
  /// For restaurants: prep time, for pharmacies: processing time, etc.
  final String duration;

  /// The vendor this product belongs to
  final VendorModel vendor;

  final String image;
  final int isAvailable;
  final int availableQuantity;
  final String? description;

  /// Size/portion information (e.g., plate size for restaurants, pack size for pharmacies)
  final String? size;

  final List<ItemFileModel> files;
  final bool? showOnCustomerApp;

  /// Add-ons or variants for this product
  final List<ProductModel> addons;

  /// Additional packaging or handling price
  final double? packagingPrice;

  /// SKU or product code (useful for pharmacies and grocery stores)
  final String? sku;

  /// Unit of measurement (e.g., "piece", "kg", "bottle", "pack")
  final String? unit;

  /// Whether this product requires a prescription (for pharmacies)
  final bool? requiresPrescription;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.duration,
    required this.image,
    required this.isAvailable,
    required this.availableQuantity,
    this.description,
    required this.vendor,
    this.size,
    this.showOnCustomerApp,
    required this.files,
    this.addons = const [],
    this.packagingPrice,
    this.sku,
    this.unit,
    this.requiresPrescription,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
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
    List<ProductModel> addonsList = [];
    try {
      addonsList = addonsJson
          .where((e) => e != null && e is Map<String, dynamic>)
          .map((e) {
            try {
              return ProductModel.fromJson(e as Map<String, dynamic>);
            } catch (addonError) {
              // Skip invalid addon entries
              return null;
            }
          })
          .where((e) => e != null)
          .cast<ProductModel>()
          .toList();
    } catch (e) {
      addonsList = [];
    }

    return ProductModel(
      id: json['id'] ?? 1,
      name: json['name']?.toString() ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : CategoryModel(id: 0, name: 'Unknown', description: ''),
      // Support both 'vendor' and 'restaurant' keys for backward compatibility
      vendor: json['vendor'] != null
          ? VendorModel.fromJson(json['vendor'])
          : json['restaurant'] != null
              ? VendorModel.fromJson(json['restaurant'])
              : VendorModel(
                  id: 0,
                  name: 'Unknown',
                  email: '',
                  phone: '',
                  businessCategory: '',
                  isActive: false,
                  isFeatured: false,
                  commissionRate: 0.0,
                  status: '',
                  userId: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      duration: json['prep_time_minutes']?.toString() ?? json['duration']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isAvailable: json['is_available'] is bool
          ? (json['is_available'] ? 1 : 0)
          : (int.tryParse(json['is_available']?.toString() ?? '1') ?? 1),
      availableQuantity:
          int.tryParse(json['available_quantity']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      // Support both 'size' and 'plate_size' for backward compatibility
      size: json['size']?.toString() ?? json['plate_size']?.toString(),
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
      sku: json['sku']?.toString(),
      unit: json['unit']?.toString(),
      requiresPrescription: json['requires_prescription'] is bool
          ? json['requires_prescription']
          : (json['requires_prescription']?.toString() == 'true' ||
                json['requires_prescription']?.toString() == '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toJson(),
      'price': price,
      'prep_time_minutes': duration,
      'duration': duration,
      'image': image,
      'is_available': isAvailable,
      'available_quantity': availableQuantity,
      'description': description,
      'size': size,
      'plate_size': size, // For backward compatibility
      'show_on_customer_app': showOnCustomerApp,
      'files': files.map((f) => f.toJson()).toList(),
      'addons': addons.map((e) => e.toJson()).toList(),
      'packaging_price': packagingPrice,
      'sku': sku,
      'unit': unit,
      'requires_prescription': requiresPrescription,
    };
  }

  // ============ Backward Compatibility Getters ============

  /// Backward compatibility getter for restaurant
  VendorModel get restaurant => vendor;

  /// Backward compatibility getter for plateSize
  String? get plateSize => size;
}

/// Type alias for backward compatibility
typedef MenuItemModel = ProductModel;
