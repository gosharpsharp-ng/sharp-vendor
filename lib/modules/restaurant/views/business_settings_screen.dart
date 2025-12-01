import 'package:sharpvendor/core/utils/exports.dart';
import '../controllers/restaurant_details_controller.dart';

class BusinessSettingsScreen extends GetView<RestaurantDetailsController> {
  const BusinessSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailsController>(
      builder: (restaurantController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () => Get.back(),
            title: "Business Settings",
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            child: CustomButton(
              onPressed: () => restaurantController.updateBusinessSettings(),
              isBusy: restaurantController.isUpdating,
              title: "Update Settings",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          body: Form(
            key: restaurantController.businessSettingsFormKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 25.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    "Business Configuration",
                    color: AppColors.blackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 8.h),
                  customText(
                    "Manage your restaurant's business settings and compliance information",
                    color: AppColors.greyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 30.h),

                  // Business Registration Section
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.greyColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.business_center,
                              color: AppColors.primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            customText(
                              "Business Registration",
                              color: AppColors.blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        CustomRoundedInputField(
                          title: "Business Registration Number",
                          hasTitle: true,
                          controller:
                              restaurantController.businessRegNumberController,
                          label: "Enter business registration number",
                          validator: (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.trim().length < 5) {
                              return "Registration number must be at least 5 characters";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        CustomRoundedInputField(
                          title: "Tax Identification Number",
                          hasTitle: true,
                          controller: restaurantController.taxIdController,
                          label: "Enter tax identification number",
                          validator: (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                value.trim().length < 5) {
                              return "Tax ID must be at least 5 characters";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.05,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.security,
                                color: AppColors.primaryColor,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: customText(
                                  "These details are required for tax compliance and legal verification.",
                                  color: AppColors.primaryColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Current Status Display
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.greyColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified,
                              color: AppColors.greenColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            customText(
                              "Current Status",
                              color: AppColors.blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              "Restaurant Status",
                              color: AppColors.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: restaurantController
                                    .getStatusColor()
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: restaurantController
                                      .getStatusColor()
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: customText(
                                restaurantController.restaurant?.status
                                        .toUpperCase() ??
                                    "UNKNOWN",
                                color: restaurantController.getStatusColor(),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              "Account Status",
                              color: AppColors.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    restaurantController.restaurant?.isActive ??
                                        false
                                    ? AppColors.greenColor.withValues(
                                        alpha: 0.1,
                                      )
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color:
                                      restaurantController
                                              .restaurant
                                              ?.isActive ??
                                          false
                                      ? AppColors.greenColor.withValues(
                                          alpha: 0.3,
                                        )
                                      : Colors.red.withValues(alpha: 0.3),
                                ),
                              ),
                              child: customText(
                                restaurantController.restaurant?.isActive ??
                                        false
                                    ? "ACTIVE"
                                    : "INACTIVE",
                                color:
                                    restaurantController.restaurant?.isActive ??
                                        false
                                    ? AppColors.greenColor
                                    : Colors.red,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),

                  // Additional Information
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "Important Notice",
                                color: Colors.orange,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                "Changes to business settings may require verification and approval. Some changes might affect your payout schedule.",
                                color: Colors.orange,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
