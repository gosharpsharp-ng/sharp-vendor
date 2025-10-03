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
                if (restaurantController.editingLocation != null) {
                  restaurantController.updateLocation(restaurantController.editingLocation!);
                }
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
                  "Update your restaurant's location information",
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.h),

                // Current Location Display
                if (restaurantController.editingLocation != null) ...[
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.greyColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            customText(
                              "Current Location",
                              color: AppColors.blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        customText(
                          restaurantController.editingLocation!.name,
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        customText(
                          "Coordinates: ${restaurantController.editingLocation!.latitude}, ${restaurantController.editingLocation!.longitude}",
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // Map Placeholder
                Container(
                  width: double.infinity,
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        color: AppColors.greyColor,
                        size: 48.sp,
                      ),
                      SizedBox(height: 12.h),
                      customText(
                        "Interactive Map",
                        color: AppColors.greyColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 4.h),
                      customText(
                        "Tap to select location",
                        color: AppColors.greyColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Manual Location Input
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        "Manual Location Entry",
                        color: AppColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 16.h),

                      // Address Input
                      CustomRoundedInputField(
                        title: "Address",
                        hasTitle: true,
                        isRequired: true,
                        controller: TextEditingController(
                          text: restaurantController.editingLocation?.name ?? '',
                        ),
                        label: "Enter full address",
                        maxLines: 3,
                        onChanged: (value) {
                          if (restaurantController.editingLocation != null) {
                            restaurantController.editingLocation = RestaurantLocation(
                              id: restaurantController.editingLocation!.id,
                              name: value,
                              latitude: restaurantController.editingLocation!.latitude,
                              longitude: restaurantController.editingLocation!.longitude,
                              locationableType: restaurantController.editingLocation!.locationableType,
                              locationableId: restaurantController.editingLocation!.locationableId,
                              deletedAt: restaurantController.editingLocation!.deletedAt,
                              createdAt: restaurantController.editingLocation!.createdAt,
                              updatedAt: restaurantController.editingLocation!.updatedAt,
                            );
                          }
                        },
                      ),

                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          Expanded(
                            child: CustomRoundedInputField(
                              title: "Latitude",
                              hasTitle: true,
                              isRequired: true,
                              controller: TextEditingController(
                                text: restaurantController.editingLocation?.latitude ?? '',
                              ),
                              label: "0.000000",
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                if (restaurantController.editingLocation != null) {
                                  restaurantController.editingLocation = RestaurantLocation(
                                    id: restaurantController.editingLocation!.id,
                                    name: restaurantController.editingLocation!.name,
                                    latitude: value,
                                    longitude: restaurantController.editingLocation!.longitude,
                                    locationableType: restaurantController.editingLocation!.locationableType,
                                    locationableId: restaurantController.editingLocation!.locationableId,
                                    deletedAt: restaurantController.editingLocation!.deletedAt,
                                    createdAt: restaurantController.editingLocation!.createdAt,
                                    updatedAt: restaurantController.editingLocation!.updatedAt,
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: CustomRoundedInputField(
                              title: "Longitude",
                              hasTitle: true,
                              isRequired: true,
                              controller: TextEditingController(
                                text: restaurantController.editingLocation?.longitude ?? '',
                              ),
                              label: "0.000000",
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                if (restaurantController.editingLocation != null) {
                                  restaurantController.editingLocation = RestaurantLocation(
                                    id: restaurantController.editingLocation!.id,
                                    name: restaurantController.editingLocation!.name,
                                    latitude: restaurantController.editingLocation!.latitude,
                                    longitude: value,
                                    locationableType: restaurantController.editingLocation!.locationableType,
                                    locationableId: restaurantController.editingLocation!.locationableId,
                                    deletedAt: restaurantController.editingLocation!.deletedAt,
                                    createdAt: restaurantController.editingLocation!.createdAt,
                                    updatedAt: restaurantController.editingLocation!.updatedAt,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Use Current Location Button
                CustomButton(
                  onPressed: () {
                    // TODO: Implement get current location functionality
                    showToast(message: "Get current location feature coming soon", isError: false);
                  },
                  title: "Use Current Location",
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  fontColor: AppColors.primaryColor,
                  width: double.infinity,
                  // prefixIcon: Icon(
                  //   Icons.my_location,
                  //   color: AppColors.primaryColor,
                  //   size: 20.sp,
                  // ),
                ),

                SizedBox(height: 30.h),

                // Information Card
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2),
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
                          "Accurate location information helps customers find your restaurant and enables better delivery services.",
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