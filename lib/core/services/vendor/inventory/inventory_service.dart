import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/utils/exports.dart';

/// Generic inventory service that handles products/items for any vendor type.
/// For restaurants: menu items, for pharmacies: medicines, for stores: products.
class InventoryService extends CoreService {
  Future<InventoryService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  Future<APIResponse> getProfile() async {
    return await fetch("/me");
  }

  /// Create a new product/menu item
  Future<APIResponse> createProduct(dynamic data) async {
    return await send("/$_endpoint/menus", data);
  }

  /// Update an existing product/menu item
  Future<APIResponse> updateProduct(dynamic data, int id) async {
    return await update("/$_endpoint/menus/$id", data);
  }

  /// Get all product categories
  Future<APIResponse> getCategories(dynamic data) async {
    return await fetch(
      "/$_endpoint/menu-categories?page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  /// Get a specific category by ID
  Future<APIResponse> getCategoryById(dynamic data) async {
    return await fetch("/$_endpoint/menu-categories/${data['id']}");
  }

  /// Get all products/menu items
  Future<APIResponse> getAllProducts(dynamic data) async {
    return await fetch(
      "/$_endpoint/menus?fresh=${data['fresh']}&${data['page']}&page_size=${data['per_page']}",
    );
  }

  /// Get a specific product/menu item by ID
  Future<APIResponse> getProductById(dynamic data) async {
    return await fetch("/$_endpoint/menus/${data['id']}");
  }

  /// Delete a product/menu item
  Future<APIResponse> deleteProduct(int id) async {
    return await remove("/$_endpoint/menus/$id", null);
  }

  // ============ Backward Compatibility Methods ============

  /// Alias for createProduct (backward compatibility with MenuService)
  Future<APIResponse> createMenu(dynamic data) => createProduct(data);

  /// Alias for updateProduct (backward compatibility with MenuService)
  Future<APIResponse> updateMenu(dynamic data, int id) => updateProduct(data, id);

  /// Alias for getCategories (backward compatibility with MenuService)
  Future<APIResponse> getMenuCategories(dynamic data) => getCategories(data);

  /// Alias for getCategoryById (backward compatibility with MenuService)
  Future<APIResponse> getMenuCategoryById(dynamic data) => getCategoryById(data);

  /// Alias for getAllProducts (backward compatibility with MenuService)
  Future<APIResponse> getAllMenu(dynamic data) => getAllProducts(data);

  /// Alias for getProductById (backward compatibility with MenuService)
  Future<APIResponse> getMenuById(dynamic data) => getProductById(data);
}

/// Type alias for backward compatibility
typedef MenuService = InventoryService;
