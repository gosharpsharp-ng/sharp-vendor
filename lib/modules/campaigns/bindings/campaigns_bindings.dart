import 'package:sharpvendor/core/utils/exports.dart';

class CampaignsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampaignsController>(() => CampaignsController());
  }
}
