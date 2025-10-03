import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/models/restaurant_analytics_model.dart';
import 'package:sharpvendor/core/services/restaurant/analytics/analytics_service.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';

class DashboardController extends GetxController {
  late final AnalyticsService _analyticsService;
  late final SettingsController _settingsController;

  // State variables
  RestaurantAnalytics? _analytics;
  bool _isLoadingAnalytics = false;
  String _analyticsError = '';

  // Getters
  RestaurantAnalytics? get analytics => _analytics;
  bool get isLoadingAnalytics => _isLoadingAnalytics;
  String get analyticsError => _analyticsError;
  bool get hasAnalyticsData => _analytics != null;

  // Wallet balance getter
  String get walletBalance {
    return _settingsController.userProfile?.restaurant?.wallet?.formattedBalance ?? '₦0.00';
  }

  // Chart data for dashboard
  List<ChartData> get dashboardChartData {
    if (_analytics?.dailyOrders.isEmpty ?? true) {
      // Return default data if no analytics
      return [
        ChartData('Mon', 0),
        ChartData('Tue', 0),
        ChartData('Wed', 0),
        ChartData('Thu', 0),
        ChartData('Fri', 0),
        ChartData('Sat', 0),
        ChartData('Sun', 0),
      ];
    }

    return _analytics!.dailyOrders.map((day) {
      return ChartData(day.shortDayName, day.ordersCount.toDouble());
    }).toList();
  }

  // Quick stats getters
  int get newOrders => _analytics?.newOrders ?? 0;
  int get completedOrders => _analytics?.completedOrders ?? 0;
  int get pendingOrders => _analytics?.pendingOrders ?? 0;
  int get totalOrders => _analytics?.totalOrders ?? 0;

  @override
  void onInit() {
    super.onInit();
    // Initialize dependencies
    _analyticsService = Get.find<AnalyticsService>();
    _settingsController = Get.find<SettingsController>();

    loadDashboardData();
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    await Future.wait<void>([
      loadAnalytics(),
      _settingsController.getProfile(),
    ]);
  }

  // Load analytics data
  Future<void> loadAnalytics() async {
    try {
      _setAnalyticsLoading(true);
      _setAnalyticsError('');

      final response = await _analyticsService.getRestaurantAnalytics();

      if (response.status == "success" && response.data != null) {
        _analytics = RestaurantAnalytics.fromJson(response.data);
        _setAnalyticsError('');
      } else {
        _setAnalyticsError(response.message ?? 'Failed to load analytics');
      }
    } catch (e) {
      _setAnalyticsError('Error loading analytics data');
    } finally {
      _setAnalyticsLoading(false);
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  // Private helper methods
  void _setAnalyticsLoading(bool loading) {
    _isLoadingAnalytics = loading;
    update();
  }

  void _setAnalyticsError(String error) {
    _analyticsError = error;
    update();
  }
}
