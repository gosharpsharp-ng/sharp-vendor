import 'package:sharpvendor/core/utils/exports.dart';
import '../controllers/restaurant_details_controller.dart';

class EditLocationScreen extends GetView<RestaurantDetailsController> {
  const EditLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailsController>(
      builder: (restaurantController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () => Get.back(),
            title: "Edit Location",
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            child: CustomButton(
              onPressed: () {
                restaurantController.updateLocationFromMap();
              },
              isBusy: restaurantController.isUpdating,
              title: "Update Location",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 25.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  "Restaurant Location",
                  color: AppColors.blackColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                customText(
                  "Select your location from the map, then edit the address name if needed",
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.h),

                // Restaurant Address Field with Map Selection
                CustomRoundedInputField(
                  title: "Restaurant Address",
                  hasTitle: true,
                  isRequired: true,
                  maxLines: 3,
                  suffixWidget: IconButton(
                    onPressed: () async {
                      final ItemLocation result = await Get.toNamed(
                        Routes.SELECT_LOCATION_SCREEN,
                      );
                      restaurantController.setRestaurantLocation(result);
                    },
                    icon: SvgPicture.asset(
                      SvgAssets.locationIcon,
                      colorFilter: ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                      height: 20.sp,
                    ),
                  ),
                  controller: restaurantController.restaurantAddressController,
                  onChanged: (value) {
                    // Allow user to manually edit the address name
                    restaurantController.restaurantAddressController.text =
                        value;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Restaurant address is required';
                    }
                    if (restaurantController.restaurantLocation == null) {
                      return 'Please select location from map first';
                    }
                    return null;
                  },
                  label: "Enter or select location from map",
                ),

                SizedBox(height: 20.h),

                // Show selected coordinates if available
                if (restaurantController.restaurantLocation != null) ...[
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "Selected Coordinates",
                                color: AppColors.blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                "Lat: ${restaurantController.restaurantLocation!.latitude}, Lng: ${restaurantController.restaurantLocation!.longitude}",
                                color: AppColors.primaryColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // Information Card
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: customText(
                          "Tap the location icon to select your restaurant's exact location on the map. You can then edit the address name directly in the text field above.",
                          color: AppColors.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
