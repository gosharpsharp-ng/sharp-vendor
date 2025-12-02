import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/utils/exports.dart';

class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  Future<APIResponse> getProfile() async {
    return await fetch("/$_endpoint/profile");
  }

  Future<APIResponse> getPayoutHistory() async {
    return await fetch("/$_endpoint/payout/history");
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await update("/$_endpoint/profile", data);
  }

  Future<APIResponse> updateBankAccount(dynamic data) async {
    return await send("/$_endpoint/bank-account", data);
  }

  Future<APIResponse> submitPayoutRequest(dynamic data) async {
    return await send("/$_endpoint/payout/request", data);
  }

  Future<APIResponse> getNotifications(dynamic data) async {
    return await fetch(
      "/$_endpoint/notification?page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getNotificationById(dynamic data) async {
    return await fetch("/$_endpoint/notification/${data['id']}");
  }

  Future<APIResponse> changePassword(dynamic data) async {
    return await send("/$_endpoint/change-password", data);
  }

  Future<APIResponse> deleteAccount(dynamic data) async {
    return await remove("/me", data);
  }

  // Orders integration
  Future<APIResponse> getAllOrders() async {
    return await fetch("/$_endpoint/order");
  }

  Future<APIResponse> getOrderById(dynamic data) async {
    return await fetch("/$_endpoint/order/${data['id']}");
  }

  Future<APIResponse> updateOrderStatus(String action, String orderNumber, {String? reason}) async {
    final Map<String, dynamic> data = {
      "action": action,
    };

    // Add reason if provided (required for cancelled action)
    if (reason != null) {
      data["reason"] = reason;
    }

    return await send("/$_endpoint/order/$orderNumber/trigger", data);
  }

  // Transactions integration
  Future<APIResponse> getAllTransactions(dynamic data) async {
    return await fetch(
      "/$_endpoint/transactions?page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getTransactionById(dynamic data) async {
    return await fetch("/$_endpoint/transactions/${data['id']}");
  }

  // Rating stats
  Future<APIResponse> getRatingStats({String? startDate, String? endDate}) async {
    String url = "/$_endpoint/stats/ratings";
    if (startDate != null && endDate != null) {
      url += "?start_date=$startDate&end_date=$endDate";
    }
    return await fetch(url);
  }
}
