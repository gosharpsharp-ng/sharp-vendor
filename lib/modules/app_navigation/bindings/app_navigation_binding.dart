import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AppNavigationController(),
    );
    Get.put(
      DashboardController(),
    ); Get.put(
      FoodMenuController(),
    );
    Get.put(
      DeliveriesController(),
    );
    Get.put(
      OrdersController(),
    ); Get.put(
      WalletController(),
    );
    Get.put(
      SettingsController(),
    );
    Get.put(
      NotificationsController(),
    );
  }
}
