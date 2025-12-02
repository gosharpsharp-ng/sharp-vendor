/// Vendor type enum representing different types of businesses
/// that can use this application
enum VendorType {
  restaurant,
  pharmacy,
  groceryStore,
  supermarket,
  bakery,
  other,
}

/// Extension to provide vendor-specific configurations
extension VendorTypeExtension on VendorType {
  /// API endpoint prefix for this vendor type
  String get apiEndpoint {
    switch (this) {
      case VendorType.restaurant:
        return 'restaurants';
      case VendorType.pharmacy:
        return 'pharmacies';
      case VendorType.groceryStore:
        return 'grocery-stores';
      case VendorType.supermarket:
        return 'supermarkets';
      case VendorType.bakery:
        return 'bakeries';
      case VendorType.other:
        return 'vendors';
    }
  }

  /// Display name for this vendor type (singular)
  String get displayName {
    switch (this) {
      case VendorType.restaurant:
        return 'Restaurant';
      case VendorType.pharmacy:
        return 'Pharmacy';
      case VendorType.groceryStore:
        return 'Grocery Store';
      case VendorType.supermarket:
        return 'Supermarket';
      case VendorType.bakery:
        return 'Bakery';
      case VendorType.other:
        return 'Business';
    }
  }

  /// Display name for this vendor type (plural)
  String get displayNamePlural {
    switch (this) {
      case VendorType.restaurant:
        return 'Restaurants';
      case VendorType.pharmacy:
        return 'Pharmacies';
      case VendorType.groceryStore:
        return 'Grocery Stores';
      case VendorType.supermarket:
        return 'Supermarkets';
      case VendorType.bakery:
        return 'Bakeries';
      case VendorType.other:
        return 'Businesses';
    }
  }

  /// Label for product/item in this vendor type
  String get productLabel {
    switch (this) {
      case VendorType.restaurant:
        return 'Menu Item';
      case VendorType.pharmacy:
        return 'Medicine';
      case VendorType.groceryStore:
      case VendorType.supermarket:
        return 'Product';
      case VendorType.bakery:
        return 'Baked Good';
      case VendorType.other:
        return 'Item';
    }
  }

  /// Label for products/items (plural) in this vendor type
  String get productLabelPlural {
    switch (this) {
      case VendorType.restaurant:
        return 'Menu Items';
      case VendorType.pharmacy:
        return 'Medicines';
      case VendorType.groceryStore:
      case VendorType.supermarket:
        return 'Products';
      case VendorType.bakery:
        return 'Baked Goods';
      case VendorType.other:
        return 'Items';
    }
  }

  /// Label for the catalog/menu section
  String get catalogLabel {
    switch (this) {
      case VendorType.restaurant:
        return 'Menu';
      case VendorType.pharmacy:
        return 'Inventory';
      case VendorType.groceryStore:
      case VendorType.supermarket:
        return 'Products';
      case VendorType.bakery:
        return 'Menu';
      case VendorType.other:
        return 'Catalog';
    }
  }

  /// Category type label for this vendor
  String get categoryTypeLabel {
    switch (this) {
      case VendorType.restaurant:
        return 'Cuisine Type';
      case VendorType.pharmacy:
        return 'Pharmacy Type';
      case VendorType.groceryStore:
      case VendorType.supermarket:
        return 'Store Type';
      case VendorType.bakery:
        return 'Bakery Type';
      case VendorType.other:
        return 'Business Type';
    }
  }

  /// Order statuses specific to this vendor type
  List<String> get orderStatuses {
    switch (this) {
      case VendorType.restaurant:
        return [
          'pending',
          'confirmed',
          'preparing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
      case VendorType.pharmacy:
        return [
          'pending',
          'confirmed',
          'processing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
      case VendorType.groceryStore:
      case VendorType.supermarket:
        return [
          'pending',
          'confirmed',
          'packing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
      case VendorType.bakery:
        return [
          'pending',
          'confirmed',
          'baking',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
      case VendorType.other:
        return [
          'pending',
          'confirmed',
          'processing',
          'ready',
          'picked_up',
          'delivered',
          'cancelled',
        ];
    }
  }

  /// Preparation status label for this vendor type
  String get preparationStatusLabel {
    switch (this) {
      case VendorType.restaurant:
        return 'Preparing';
      case VendorType.pharmacy:
        return 'Processing';
      case VendorType.groceryStore:
      case VendorType.supermarket:
        return 'Packing';
      case VendorType.bakery:
        return 'Baking';
      case VendorType.other:
        return 'Processing';
    }
  }

  /// Whether this vendor type typically has delivery
  bool get supportsDelivery => true;

  /// Whether this vendor type has preparation time for items
  bool get hasPreparationTime {
    switch (this) {
      case VendorType.restaurant:
      case VendorType.bakery:
        return true;
      case VendorType.pharmacy:
      case VendorType.groceryStore:
      case VendorType.supermarket:
      case VendorType.other:
        return false;
    }
  }

  /// Whether this vendor type uses portion/plate sizes
  bool get hasPortionSizes {
    switch (this) {
      case VendorType.restaurant:
      case VendorType.bakery:
        return true;
      case VendorType.pharmacy:
      case VendorType.groceryStore:
      case VendorType.supermarket:
      case VendorType.other:
        return false;
    }
  }

  /// Whether this vendor type supports add-ons
  bool get supportsAddons {
    switch (this) {
      case VendorType.restaurant:
      case VendorType.bakery:
        return true;
      case VendorType.pharmacy:
      case VendorType.groceryStore:
      case VendorType.supermarket:
      case VendorType.other:
        return false;
    }
  }

  /// Label for the preparation time field
  String get preparationTimeLabel {
    switch (this) {
      case VendorType.restaurant:
        return 'Prep Time';
      case VendorType.bakery:
        return 'Baking Time';
      case VendorType.pharmacy:
      case VendorType.groceryStore:
      case VendorType.supermarket:
      case VendorType.other:
        return 'Processing Time';
    }
  }

  /// Icon name for this vendor type
  String get iconName {
    switch (this) {
      case VendorType.restaurant:
        return 'restaurant';
      case VendorType.pharmacy:
        return 'local_pharmacy';
      case VendorType.groceryStore:
        return 'local_grocery_store';
      case VendorType.supermarket:
        return 'store';
      case VendorType.bakery:
        return 'bakery_dining';
      case VendorType.other:
        return 'storefront';
    }
  }

  /// Parse vendor type from string (API response)
  static VendorType fromString(String? value) {
    if (value == null) return VendorType.restaurant;

    switch (value.toLowerCase()) {
      case 'restaurant':
        return VendorType.restaurant;
      case 'pharmacy':
        return VendorType.pharmacy;
      case 'grocery_store':
      case 'grocerystore':
      case 'grocery-store':
        return VendorType.groceryStore;
      case 'supermarket':
        return VendorType.supermarket;
      case 'bakery':
        return VendorType.bakery;
      default:
        return VendorType.other;
    }
  }

  /// Convert to string for API requests
  String toApiString() {
    switch (this) {
      case VendorType.restaurant:
        return 'restaurant';
      case VendorType.pharmacy:
        return 'pharmacy';
      case VendorType.groceryStore:
        return 'grocery_store';
      case VendorType.supermarket:
        return 'supermarket';
      case VendorType.bakery:
        return 'bakery';
      case VendorType.other:
        return 'other';
    }
  }
}

/// Global vendor configuration manager
class VendorConfigManager {
  static final VendorConfigManager _instance = VendorConfigManager._internal();
  factory VendorConfigManager() => _instance;
  VendorConfigManager._internal();

  /// Current vendor type - defaults to restaurant for backward compatibility
  VendorType currentVendorType = VendorType.restaurant;

  /// Get the API endpoint prefix for the current vendor
  String get apiEndpoint => currentVendorType.apiEndpoint;

  /// Get display name for current vendor type
  String get displayName => currentVendorType.displayName;

  /// Get product label for current vendor type
  String get productLabel => currentVendorType.productLabel;

  /// Get catalog label for current vendor type
  String get catalogLabel => currentVendorType.catalogLabel;

  /// Get category type label for current vendor
  String get categoryTypeLabel => currentVendorType.categoryTypeLabel;

  /// Get order statuses for current vendor type
  List<String> get orderStatuses => currentVendorType.orderStatuses;

  /// Check if current vendor type supports add-ons
  bool get supportsAddons => currentVendorType.supportsAddons;

  /// Check if current vendor type has preparation time
  bool get hasPreparationTime => currentVendorType.hasPreparationTime;

  /// Check if current vendor type has portion sizes
  bool get hasPortionSizes => currentVendorType.hasPortionSizes;
}

/// Convenience getter for vendor config manager
VendorConfigManager get vendorConfig => VendorConfigManager();
