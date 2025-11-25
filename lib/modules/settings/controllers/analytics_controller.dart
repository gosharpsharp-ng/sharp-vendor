import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/models/restaurant_analytics_model.dart';
import 'package:sharpvendor/core/services/restaurant/analytics/analytics_service.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';
import 'package:intl/intl.dart';

enum DateFilterOption {
  today,
  yesterday,
  last7Days,
  last30Days,
  thisMonth,
  lastMonth,
  custom,
}

class AnalyticsController extends GetxController {
  final AnalyticsService _analyticsService = Get.find<AnalyticsService>();

  // State variables for new stats
  RestaurantAnalyticsStats? _stats;
  bool _isLoading = false;
  String _errorMessage = '';

  // Date filter state
  DateFilterOption _selectedFilter = DateFilterOption.last7Days;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  // Getters
  RestaurantAnalyticsStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasData => _stats != null;
  bool get hasError => _errorMessage.isNotEmpty;
  DateFilterOption get selectedFilter => _selectedFilter;
  DateTime? get customStartDate => _customStartDate;
  DateTime? get customEndDate => _customEndDate;

  // Chart data for the combo chart widget (revenue + orders)
  List<ChartData> get revenueChartData {
    if (_stats?.dailyBreakdown.isEmpty ?? true) return [];

    return _stats!.dailyBreakdown.map((day) {
      return ChartData(day.shortDayName, day.revenue);
    }).toList();
  }

  List<ChartData> get ordersChartData {
    if (_stats?.dailyBreakdown.isEmpty ?? true) return [];

    return _stats!.dailyBreakdown.map((day) {
      return ChartData(day.shortDayName, day.orders.toDouble());
    }).toList();
  }

  // Get date range display text
  String get dateRangeText {
    if (_stats?.dailyBreakdown.isEmpty ?? true) return '';

    try {
      final firstDay = _stats!.dailyBreakdown.first;
      final lastDay = _stats!.dailyBreakdown.last;

      final startDate = DateTime.parse(firstDay.date);
      final endDate = DateTime.parse(lastDay.date);

      final dateFormat = DateFormat('MMM d');
      return '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}';
    } catch (e) {
      return '';
    }
  }

  // Get filter label
  String get filterLabel {
    switch (_selectedFilter) {
      case DateFilterOption.today:
        return 'Today';
      case DateFilterOption.yesterday:
        return 'Yesterday';
      case DateFilterOption.last7Days:
        return 'Last 7 Days';
      case DateFilterOption.last30Days:
        return 'Last 30 Days';
      case DateFilterOption.thisMonth:
        return 'This Month';
      case DateFilterOption.lastMonth:
        return 'Last Month';
      case DateFilterOption.custom:
        if (_customStartDate != null && _customEndDate != null) {
          final dateFormat = DateFormat('MMM d');
          return '${dateFormat.format(_customStartDate!)} - ${dateFormat.format(_customEndDate!)}';
        }
        return 'Custom Range';
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  // Load stats data based on current filter
  Future<void> loadStats() async {
    final dates = _getDateRangeForFilter(_selectedFilter);
    await _fetchStats(dates['start']!, dates['end']!);
  }

  // Fetch stats from API
  Future<void> _fetchStats(String startDate, String endDate) async {
    try {
      _setLoading(true);
      _setError('');

      print('📊 ==================== FETCHING STATS DATA ====================');
      print('📊 Date Range: $startDate to $endDate');

      final response = await _analyticsService.getRestaurantStats(
        startDate: startDate,
        endDate: endDate,
      );

      print('📊 Response Status: ${response.status}');
      print('📊 Response Message: ${response.message}');
      print('📊 Response Data: ${response.data}');

      if (response.status == "success" && response.data != null) {
        print('📊 Parsing stats data...');

        // Check if response has the new format with 'summary' key
        if (response.data is Map && response.data.containsKey('summary')) {
          _stats = RestaurantAnalyticsStats.fromJson(response.data);
          print('📊 ✅ Stats parsed successfully');
          print('📊 Total Revenue: ${_stats?.summary.totalRevenue}');
          print('📊 Total Orders: ${_stats?.summary.totalOrders}');
          print('📊 Daily Breakdown Count: ${_stats?.dailyBreakdown.length}');
          _setError('');
        } else {
          // Old format detected - needs backend update
          print('📊 ⚠️ Old response format detected');
          _setError(
              'The analytics endpoint needs to be updated.\n\nCurrent response is missing required fields:\n- summary (with revenue, orders, AOV, etc.)\n- daily_breakdown (with revenue per day)\n- order_status_breakdown\n- top_performing_days\n- peak_performance\n\nPlease update the backend to return the new format.');
        }
      } else {
        print('📊 ❌ Stats request failed');
        print('📊 Error: ${response.message}');

        // Show more detailed error message
        String errorMsg = response.message ?? 'Failed to load stats data';
        if (errorMsg.toLowerCase().contains('not found') ||
            errorMsg.toLowerCase().contains('404')) {
          errorMsg =
              'Stats endpoint returned an error.\n\nEndpoint: GET /restaurants/analytics\nWith date parameters\n\nError: ${response.message}';
        }
        _setError(errorMsg);
      }
      print('📊 ================================================================');
    } catch (e, stackTrace) {
      print('📊 ❌ Exception loading stats: $e');
      print('📊 Stack trace: $stackTrace');
      _setError('An error occurred while loading stats data');
    } finally {
      _setLoading(false);
    }
  }

  // Change date filter
  Future<void> changeFilter(DateFilterOption filter) async {
    _selectedFilter = filter;
    update();
    await loadStats();
  }

  // Set custom date range
  Future<void> setCustomDateRange(DateTime startDate, DateTime endDate) async {
    _customStartDate = startDate;
    _customEndDate = endDate;
    _selectedFilter = DateFilterOption.custom;
    update();
    await loadStats();
  }

  // Get date range based on filter
  Map<String, String> _getDateRangeForFilter(DateFilterOption filter) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (filter) {
      case DateFilterOption.today:
        startDate = DateTime(now.year, now.month, now.day);
        endDate = DateTime(now.year, now.month, now.day);
        break;

      case DateFilterOption.yesterday:
        final yesterday = now.subtract(const Duration(days: 1));
        startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        endDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
        break;

      case DateFilterOption.last7Days:
        endDate = DateTime(now.year, now.month, now.day);
        startDate = endDate.subtract(const Duration(days: 6));
        break;

      case DateFilterOption.last30Days:
        endDate = DateTime(now.year, now.month, now.day);
        startDate = endDate.subtract(const Duration(days: 29));
        break;

      case DateFilterOption.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month, now.day);
        break;

      case DateFilterOption.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        startDate = lastMonth;
        endDate = DateTime(now.year, now.month, 0); // Last day of previous month
        break;

      case DateFilterOption.custom:
        startDate = _customStartDate ?? now.subtract(const Duration(days: 6));
        endDate = _customEndDate ?? now;
        break;
    }

    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      'start': dateFormat.format(startDate),
      'end': dateFormat.format(endDate),
    };
  }

  // Refresh stats data
  Future<void> refreshStats() async {
    await loadStats();
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

  // Formatted getters for UI
  String get formattedTotalRevenue {
    if (_stats == null) return '₦0.00';
    return '₦${_stats!.summary.totalRevenue.toStringAsFixed(2)}';
  }

  String get formattedAverageOrderValue {
    if (_stats == null) return '₦0.00';
    return '₦${_stats!.summary.averageOrderValue.toStringAsFixed(2)}';
  }

  String get formattedCompletionRate {
    if (_stats == null) return '0%';
    return '${_stats!.summary.completionRate.toStringAsFixed(1)}%';
  }

  String get formattedCancellationRate {
    if (_stats == null) return '0%';
    return '${_stats!.summary.cancellationRate.toStringAsFixed(1)}%';
  }

  // Get percentage change with sign
  String getPercentageChangeText(double change) {
    if (change == 0) return '0%';
    final sign = change > 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(1)}%';
  }

  bool isPositiveChange(double change) => change > 0;
  bool isNegativeChange(double change) => change < 0;

  // Peak performance getters
  String get bestDayOfWeek => _stats?.peakPerformance.bestDayOfWeek ?? 'N/A';
  String get bestTimeOfDay => _stats?.peakPerformance.bestTimeOfDay ?? 'N/A';
}
