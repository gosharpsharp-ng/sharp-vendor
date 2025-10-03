import 'package:sharpvendor/core/utils/exports.dart';
import '../controllers/restaurant_details_controller.dart';

class RestaurantBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurantDetailsController>(
      () => RestaurantDetailsController(),
    );
  }
}