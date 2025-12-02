import 'package:sharpvendor/core/config/vendor_config.dart';
import 'package:sharpvendor/core/utils/exports.dart';

/// Generic analytics service that handles analytics for any vendor type.
class VendorAnalyticsService extends CoreService {
  Future<VendorAnalyticsService> init() async => this;

  /// Get the API endpoint prefix based on current vendor type
  String get _endpoint => vendorConfig.apiEndpoint;

  /// Get vendor analytics data
  Future<APIResponse> getVendorAnalytics() async {
    return await fetch("/$_endpoint/analytics");
  }

  /// Get analytics for specific date range
  Future<APIResponse> getVendorAnalyticsForDateRange(dynamic data) async {
    return await fetch(
      "/$_endpoint/analytics?start_date=${data['start_date']}&end_date=${data['end_date']}",
    );
  }

  /// Get detailed vendor statistics with date range
  Future<APIResponse> getVendorStats({
    required String startDate,
    required String endDate,
  }) async {
    return await fetch(
      "/$_endpoint/analytics?start_date=$startDate&end_date=$endDate",
    );
  }

  // ============ Backward Compatibility Methods ============

  /// Alias for getVendorAnalytics (backward compatibility)
  Future<APIResponse> getRestaurantAnalytics() => getVendorAnalytics();

  /// Alias for getVendorAnalyticsForDateRange (backward compatibility)
  Future<APIResponse> getRestaurantAnalyticsForDateRange(dynamic data) =>
      getVendorAnalyticsForDateRange(data);

  /// Alias for getVendorStats (backward compatibility)
  Future<APIResponse> getRestaurantStats({
    required String startDate,
    required String endDate,
  }) =>
      getVendorStats(startDate: startDate, endDate: endDate);
}

/// Type alias for backward compatibility
typedef AnalyticsService = VendorAnalyticsService;
