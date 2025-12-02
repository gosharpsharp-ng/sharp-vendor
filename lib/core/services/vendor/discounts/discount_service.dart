import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/services/core_service.dart';
import 'package:sharpvendor/core/services/models/api_response.dart';

/// Generic discount service that handles discounts for any vendor type.
class VendorDiscountService extends CoreService {
  Future<VendorDiscountService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  // ============ Product-level Discounts ============

  /// Create a new discount for a product/menu item
  Future<APIResponse> createProductDiscount(int productId, Map<String, dynamic> data) async {
    return await send("/$_endpoint/menus/$productId/discounts", data);
  }

  /// Update an existing product discount
  Future<APIResponse> updateProductDiscount(int productId, int discountId, Map<String, dynamic> data) async {
    return await update("/$_endpoint/menus/$productId/discounts/$discountId", data);
  }

  /// Get all discounts for a specific product
  Future<APIResponse> getProductDiscounts(int productId, {int page = 1, int perPage = 15}) async {
    return await fetch("/$_endpoint/menus/$productId/discounts?page=$page&per_page=$perPage");
  }

  /// Get a single product discount by ID
  Future<APIResponse> getProductDiscountById(int productId, int discountId) async {
    return await fetch("/$_endpoint/menus/$productId/discounts/$discountId");
  }

  /// Delete a product discount
  Future<APIResponse> deleteProductDiscount(int productId, int discountId) async {
    return await remove("/$_endpoint/menus/$productId/discounts/$discountId", null);
  }

  // ============ Vendor-level Discounts ============

  /// Create a new discount for the vendor
  Future<APIResponse> createVendorDiscount(Map<String, dynamic> data) async {
    return await send("/$_endpoint/discounts", data);
  }

  /// Update an existing vendor discount
  Future<APIResponse> updateVendorDiscount(int discountId, Map<String, dynamic> data) async {
    return await update("/$_endpoint/discounts/$discountId", data);
  }

  /// Get all discounts for the vendor
  Future<APIResponse> getVendorDiscounts({int page = 1, int perPage = 15}) async {
    return await fetch("/$_endpoint/discounts?page=$page&per_page=$perPage");
  }

  /// Get a single vendor discount by ID
  Future<APIResponse> getVendorDiscountById(int discountId) async {
    return await fetch("/$_endpoint/discounts/$discountId");
  }

  /// Delete a vendor discount
  Future<APIResponse> deleteVendorDiscount(int discountId) async {
    return await remove("/$_endpoint/discounts/$discountId", null);
  }

  // ============ Backward Compatibility Methods ============

  /// Alias for createProductDiscount (backward compatibility)
  Future<APIResponse> createDiscount(int menuId, Map<String, dynamic> data) =>
      createProductDiscount(menuId, data);

  /// Alias for updateProductDiscount (backward compatibility)
  Future<APIResponse> updateDiscount(int menuId, int discountId, Map<String, dynamic> data) =>
      updateProductDiscount(menuId, discountId, data);

  /// Alias for getProductDiscounts (backward compatibility)
  Future<APIResponse> getMenuDiscounts(int menuId, {int page = 1, int perPage = 15}) =>
      getProductDiscounts(menuId, page: page, perPage: perPage);

  /// Alias for getProductDiscountById (backward compatibility)
  Future<APIResponse> getDiscountById(int menuId, int discountId) =>
      getProductDiscountById(menuId, discountId);

  /// Alias for deleteProductDiscount (backward compatibility)
  Future<APIResponse> deleteDiscount(int menuId, int discountId) =>
      deleteProductDiscount(menuId, discountId);

  /// Alias for createVendorDiscount (backward compatibility)
  Future<APIResponse> createRestaurantDiscount(Map<String, dynamic> data) =>
      createVendorDiscount(data);

  /// Alias for updateVendorDiscount (backward compatibility)
  Future<APIResponse> updateRestaurantDiscount(int discountId, Map<String, dynamic> data) =>
      updateVendorDiscount(discountId, data);

  /// Alias for getVendorDiscounts (backward compatibility)
  Future<APIResponse> getRestaurantDiscounts({int page = 1, int perPage = 15}) =>
      getVendorDiscounts(page: page, perPage: perPage);

  /// Alias for getVendorDiscountById (backward compatibility)
  Future<APIResponse> getRestaurantDiscountById(int discountId) =>
      getVendorDiscountById(discountId);

  /// Alias for deleteVendorDiscount (backward compatibility)
  Future<APIResponse> deleteRestaurantDiscount(int discountId) =>
      deleteVendorDiscount(discountId);
}

/// Type alias for backward compatibility
typedef DiscountService = VendorDiscountService;
