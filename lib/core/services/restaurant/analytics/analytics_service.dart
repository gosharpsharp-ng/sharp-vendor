import 'package:sharpvendor/core/utils/exports.dart';

class AnalyticsService extends CoreService {
  Future<AnalyticsService> init() async => this;

  // Get restaurant analytics data
  Future<APIResponse> getRestaurantAnalytics() async {
    return await fetch("/restaurants/analytics");
  }

  // Get analytics for specific date range (optional future enhancement)
  Future<APIResponse> getRestaurantAnalyticsForDateRange(dynamic data) async {
    return await fetch(
      "/restaurants/analytics?start_date=${data['start_date']}&end_date=${data['end_date']}",
    );
  }
}