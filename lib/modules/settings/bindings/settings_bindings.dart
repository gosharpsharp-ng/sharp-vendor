import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/services/restaurant/analytics/analytics_service.dart';
import 'package:sharpvendor/modules/settings/controllers/analytics_controller.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
    );

    // Analytics dependencies
    Get.lazyPut<AnalyticsService>(
          () => AnalyticsService(),
    );
    Get.lazyPut<AnalyticsController>(
          () => AnalyticsController(),
    );
  }
}
