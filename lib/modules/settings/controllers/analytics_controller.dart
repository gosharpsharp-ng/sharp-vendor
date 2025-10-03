import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/models/restaurant_analytics_model.dart';
import 'package:sharpvendor/core/services/restaurant/analytics/analytics_service.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';

class AnalyticsController extends GetxController {
  final AnalyticsService _analyticsService = Get.find<AnalyticsService>();

  // State variables
  RestaurantAnalytics? _analytics;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  RestaurantAnalytics? get analytics => _analytics;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasData => _analytics != null;
  bool get hasError => _errorMessage.isNotEmpty;

  // Chart data for the area chart widget
  List<ChartData> get chartData {
    if (_analytics?.dailyOrders.isEmpty ?? true) return [];

    return _analytics!.dailyOrders.map((day) {
      return ChartData(day.shortDayName, day.ordersCount.toDouble());
    }).toList();
  }

  // Get week range display text
  String get weekRangeText {
    if (_analytics == null) return 'This Week';

    try {
      final startDate = DateTime.parse(_analytics!.weekStart);
      final endDate = DateTime.parse(_analytics!.weekEnd);

      final startFormatted = '${startDate.day}/${startDate.month}';
      final endFormatted = '${endDate.day}/${endDate.month}';

      return '$startFormatted - $endFormatted';
    } catch (e) {
      return 'This Week';
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadAnalytics();
  }

  // Load analytics data
  Future<void> loadAnalytics() async {
    try {
      _setLoading(true);
      _setError('');

      final response = await _analyticsService.getRestaurantAnalytics();

      if (response.status=="success" && response.data != null) {
        _analytics = RestaurantAnalytics.fromJson(response.data);
        _setError('');
      } else {
        _setError(response.message ?? 'Failed to load analytics data');
      }
    } catch (e) {
      // logger.e('Error loading analytics: $e');
      _setError('An error occurred while loading analytics data');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh analytics data
  Future<void> refreshAnalytics() async {
    await loadAnalytics();
  }

  // Load analytics for specific date range
  Future<void> loadAnalyticsForDateRange({
    required String startDate,
    required String endDate,
  }) async {
    try {
      _setLoading(true);
      _setError('');

      final response = await _analyticsService.getRestaurantAnalyticsForDateRange({
        'start_date': startDate,
        'end_date': endDate,
      });

      if (response.status=="success" && response.data != null) {
        _analytics = RestaurantAnalytics.fromJson(response.data);
        _setError('');
      } else {
        _setError(response.message ?? 'Failed to load analytics data');
      }
    } catch (e) {
      // logger.e('Error loading analytics for date range: $e');
      _setError('An error occurred while loading analytics data');
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    update();
  }

  void _setError(String error) {
    _errorMessage = error;
    update();
  }

  // Clear error message
  void clearError() {
    _setError('');
  }

  // Get formatted completion rate
  String get formattedCompletionRate {
    if (_analytics == null) return '0%';
    return '${_analytics!.completionRate.toStringAsFixed(1)}%';
  }

  // Get peak day information
  String get peakDayInfo {
    final peakDay = _analytics?.peakDay;
    if (peakDay == null || peakDay.ordersCount == 0) {
      return 'No peak day';
    }
    return '${peakDay.dayName} (${peakDay.ordersCount} orders)';
  }

  // Get average daily orders
  String get averageDailyOrdersText {
    if (_analytics == null) return '0';
    return _analytics!.averageDailyOrders.toStringAsFixed(1);
  }
}