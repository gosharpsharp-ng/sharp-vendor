import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';

class OrdersBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(
      () => OrdersController(),
      fenix: true,
    );
  }
}
