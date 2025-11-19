import 'package:sharpvendor/core/services/core_service.dart';
import 'package:sharpvendor/core/services/models/api_response.dart';

class DiscountService extends CoreService {
  Future<DiscountService> init() async => this;

  /// Create a new discount for a menu item
  Future<APIResponse> createDiscount(int menuId, Map<String, dynamic> data) async {
    return await send("/restaurants/menus/$menuId/discounts", data);
  }

  /// Update an existing discount
  Future<APIResponse> updateDiscount(int menuId, int discountId, Map<String, dynamic> data) async {
    return await update("/restaurants/menus/$menuId/discounts/$discountId", data);
  }

  /// Get all discounts for a specific menu item
  Future<APIResponse> getMenuDiscounts(int menuId, {int page = 1, int perPage = 15}) async {
    return await fetch("/restaurants/menus/$menuId/discounts?page=$page&per_page=$perPage");
  }

  /// Get a single discount by ID
  Future<APIResponse> getDiscountById(int menuId, int discountId) async {
    return await fetch("/restaurants/menus/$menuId/discounts/$discountId");
  }

  /// Delete a discount
  Future<APIResponse> deleteDiscount(int menuId, int discountId) async {
    return await remove("/restaurants/menus/$menuId/discounts/$discountId", null);
  }

  // ============ Restaurant-level Discounts ============

  /// Create a new discount for the restaurant
  Future<APIResponse> createRestaurantDiscount(Map<String, dynamic> data) async {
    return await send("/restaurants/discounts", data);
  }

  /// Update an existing restaurant discount
  Future<APIResponse> updateRestaurantDiscount(int discountId, Map<String, dynamic> data) async {
    return await update("/restaurants/discounts/$discountId", data);
  }

  /// Get all discounts for the restaurant
  Future<APIResponse> getRestaurantDiscounts({int page = 1, int perPage = 15}) async {
    return await fetch("/restaurants/discounts?page=$page&per_page=$perPage");
  }

  /// Get a single restaurant discount by ID
  Future<APIResponse> getRestaurantDiscountById(int discountId) async {
    return await fetch("/restaurants/discounts/$discountId");
  }

  /// Delete a restaurant discount
  Future<APIResponse> deleteRestaurantDiscount(int discountId) async {
    return await remove("/restaurants/discounts/$discountId", null);
  }
}
