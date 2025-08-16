import 'package:sharpvendor/core/utils/exports.dart';

class DeliverySuccessScreen extends StatelessWidget {
  const DeliverySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return WillPopScope(
        onWillPop: () async {
          Get.back();
          Get.back();
          return true;
        },
        child: Scaffold(
          appBar: flatAppBar(
            bgColor: AppColors.backgroundColor,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        SvgAssets.successIcon,
                        height: 60.sp,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      customText(
                        "Your delivery has been confirmed",
                        overflow: TextOverflow.visible,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.center,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      customText("We're connecting you to the nearest rider",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomButton(
                        onPressed: () async {
                          ordersController.fetchDeliveries();
                          await Get.find<SocketService>().joinTrackingRoom(
                              trackingId: ordersController
                                      .selectedDelivery?.trackingId ??
                                  "",
                              msg: "join_room");
                          Get.offNamedUntil(Routes.DELIVERY_TRACKING_SCREEN,
                              (route) {
                            final routeName = route.settings.name;
                            return routeName !=
                                    Routes.DELIVERY_SUMMARY_SCREEN &&
                                routeName !=
                                    Routes.DELIVERY_ITEM_INPUT_SCREEN &&
                                routeName != Routes.INITIATE_DELIVERY_SCREEN &&
                                routeName != Routes.DELIVERY_SUCCESS_SCREEN;
                          });
                          ordersController.drawPolyLineFromOriginToDestination(
                              context,
                              originLatitude: ordersController
                                  .selectedDelivery!.originLocation.latitude,
                              originLongitude: ordersController
                                  .selectedDelivery!.originLocation.longitude,
                              originAddress: ordersController
                                  .selectedDelivery!.originLocation.name,
                              destinationLatitude: ordersController
                                  .selectedDelivery!
                                  .destinationLocation
                                  .latitude,
                              destinationLongitude: ordersController
                                  .selectedDelivery!
                                  .destinationLocation
                                  .longitude,
                              destinationAddress: ordersController
                                  .selectedDelivery!.destinationLocation.name);
                        },
                        title: "View Progress",
                        // isBusy: ordersController.fetchingDeliveries,
                        backgroundColor: AppColors.primaryColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
