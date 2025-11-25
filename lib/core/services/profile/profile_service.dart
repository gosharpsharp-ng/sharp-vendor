import 'package:sharpvendor/core/utils/exports.dart';

class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/restaurants/profile");
  }

  Future<APIResponse> getPayoutHistory() async {
    return await fetch("/restaurants/payout/history");
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await update("/restaurants/profile", data);
  }

  Future<APIResponse> updateBankAccount(dynamic data) async {
    return await send("/restaurants/bank-account", data);
  }

  Future<APIResponse> submitPayoutRequest(dynamic data) async {
    return await send("/restaurants/payout/request", data);
  }

  Future<APIResponse> getNotifications(dynamic data) async {
    return await fetch(
      "/restaurants/notification?page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getNotificationById(dynamic data) async {
    return await fetch("/restaurants/notification/${data['id']}");
  }

  Future<APIResponse> changePassword(dynamic data) async {
    return await send("/restaurants/change-password", data);
  }

  Future<APIResponse> deleteAccount(dynamic data) async {
    return await remove("/me", data);
  }

  // Orders integration
  Future<APIResponse> getAllOrders() async {
    return await fetch("/restaurants/order");
  }

  Future<APIResponse> getOrderById(dynamic data) async {
    return await fetch("/restaurants/order/${data['id']}");
  }

  Future<APIResponse> updateOrderStatus(String action, String orderNumber, {String? reason}) async {
    final Map<String, dynamic> data = {
      "action": action,
    };

    // Add reason if provided (required for cancelled action)
    if (reason != null) {
      data["reason"] = reason;
    }

    return await send("/restaurants/order/$orderNumber/trigger", data);
  }

  // Transactions integration
  Future<APIResponse> getAllTransactions(dynamic data) async {
    return await fetch(
      "/restaurants/transactions?page=${data['page']}&page_size=${data['per_page']}",
    );
  }

  Future<APIResponse> getTransactionById(dynamic data) async {
    return await fetch("/restaurants/transactions/${data['id']}");
  }
}
