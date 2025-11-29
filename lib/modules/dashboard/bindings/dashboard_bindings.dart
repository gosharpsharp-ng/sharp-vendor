import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/services/restaurant/analytics/analytics_service.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    // Analytics service dependency - must be registered before controller
    Get.lazyPut<AnalyticsService>(
      () => AnalyticsService(),
      fenix: true,
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(),
      fenix: true,
    );
  }
}
