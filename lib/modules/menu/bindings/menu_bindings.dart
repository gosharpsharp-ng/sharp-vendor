import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';

class MenuBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      FoodMenuController(),
    );
  }
}
