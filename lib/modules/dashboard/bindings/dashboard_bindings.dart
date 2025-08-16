import 'package:sharpvendor/core/utils/exports.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      DashboardController(),
    );
  }
}
