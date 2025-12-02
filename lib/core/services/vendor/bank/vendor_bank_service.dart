import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/utils/exports.dart';

/// Generic bank service that handles bank account operations for any vendor type.
class VendorBankService extends CoreService {
  Future<VendorBankService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  /// Get list of banks
  Future<APIResponse> getBankList() async {
    return await fetch("/banks/list");
  }

  /// Verify bank account details
  Future<APIResponse> verifyBankAccount(dynamic data) async {
    return await send("/banks/verify-account", data);
  }

  /// Update vendor bank account
  Future<APIResponse> updateVendorBankAccount(dynamic data) async {
    return await send("/$_endpoint/bank-account", data);
  }

  /// Get vendor bank account details
  Future<APIResponse> getVendorBankAccount() async {
    return await fetch("/$_endpoint/bank-account");
  }

  // ============ Backward Compatibility Methods ============

  /// Alias for updateVendorBankAccount (backward compatibility)
  Future<APIResponse> updateRestaurantBankAccount(dynamic data) =>
      updateVendorBankAccount(data);

  /// Alias for getVendorBankAccount (backward compatibility)
  Future<APIResponse> getRestaurantBankAccount() => getVendorBankAccount();
}

/// Type alias for backward compatibility
typedef RestaurantBankService = VendorBankService;
