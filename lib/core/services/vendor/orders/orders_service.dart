import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/utils/exports.dart';

/// Generic orders service that handles orders for any vendor type.
class VendorOrdersService extends CoreService {
  Future<VendorOrdersService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  /// Get all orders for the vendor
  Future<APIResponse> getAllOrders(dynamic data) async {
    return await fetch("/$_endpoint/order");
  }

  /// Get a specific order by ID
  Future<APIResponse> getOrderById(dynamic data) async {
    return await fetch("/$_endpoint/order/${data['id']}");
  }

  /// Update order status
  Future<APIResponse> updateOrder(dynamic data, int orderId) async {
    return await generalPatch("/$_endpoint/order/$orderId/status", data);
  }

  /// Trigger order action (confirm, prepare, ready, etc.)
  Future<APIResponse> triggerOrderAction(String action, String orderNumber, {String? reason}) async {
    final Map<String, dynamic> data = {
      "action": action,
    };

    // Add reason if provided (required for cancelled action)
    if (reason != null) {
      data["reason"] = reason;
    }

    return await send("/$_endpoint/order/$orderNumber/trigger", data);
  }
}

/// Type alias for backward compatibility
typedef OrdersService = VendorOrdersService;
