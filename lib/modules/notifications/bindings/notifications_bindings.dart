import 'package:sharpvendor/core/utils/exports.dart';

class NotificationsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
