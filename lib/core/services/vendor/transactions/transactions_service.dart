import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/utils/exports.dart';

/// Generic transactions service that handles transaction operations for any vendor type.
class VendorTransactionsService extends CoreService {
  Future<VendorTransactionsService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  /// Get all transactions for the vendor
  Future<APIResponse> getAllTransactions(dynamic data) async {
    return await fetch(
        "/$_endpoint/transaction?${data['page']}&page_size=${data['per_page']}");
  }

  /// Get a specific transaction by ID
  Future<APIResponse> getTransactionById(dynamic data) async {
    return await fetch("/$_endpoint/transactions/${data['id']}");
  }
}

/// Type alias for backward compatibility
typedef TransactionsService = VendorTransactionsService;
