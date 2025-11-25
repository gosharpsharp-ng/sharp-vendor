import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';

class MenuBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodMenuController>(
      () => FoodMenuController(),
      fenix: true, // Recreates the controller if it was removed from memory
    );
  }
}
