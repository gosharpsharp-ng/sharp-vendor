import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/payouts/controllers/payout_controller.dart';

class PayoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PayoutController(),
    );
  }
}