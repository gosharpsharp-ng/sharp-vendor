import 'package:sharpvendor/core/utils/exports.dart';
import '../controllers/restaurant_details_controller.dart';

class EditBasicInfoScreen extends GetView<RestaurantDetailsController> {
  const EditBasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailsController>(
      builder: (restaurantController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () => Get.back(),
            title: "Edit Basic Information",
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            child: CustomButton(
              onPressed: () => restaurantController.updateBasicInfo(),
              isBusy: restaurantController.isUpdating,
              title: "Update Information",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          body: Form(
            key: restaurantController.basicInfoFormKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 25.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    vendorConfig.profileLabel,
                    color: AppColors.blackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 8.h),
                  customText(
                    "Update your ${vendorConfig.displayName.toLowerCase()}'s profile images and basic information",
                    color: AppColors.greyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 30.h),

                  // Vendor Images Section
                  Container(
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.greyColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "${vendorConfig.displayName} Images",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 20.h),

                        // Banner Image
                        customText(
                          "Banner Image",
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => restaurantController.selectBannerImage(),
                          child: Container(
                            width: double.infinity,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: restaurantController.bannerImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.file(
                                      restaurantController.bannerImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : restaurantController.restaurant?.banner !=
                                          null &&
                                      restaurantController
                                          .restaurant!
                                          .banner!
                                          .isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: CachedNetworkImage(
                                      imageUrl: restaurantController
                                          .restaurant!
                                          .banner!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: AppColors.backgroundColor,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          _buildImagePlaceholder(
                                            "Add Banner Image",
                                            Icons.image_outlined,
                                            "Tap to upload ${vendorConfig.displayName.toLowerCase()} banner",
                                          ),
                                    ),
                                  )
                                : _buildImagePlaceholder(
                                    "Add Banner Image",
                                    Icons.image_outlined,
                                    "Tap to upload ${vendorConfig.displayName.toLowerCase()} banner",
                                  ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Logo Image
                        customText(
                          vendorConfig.logoLabel,
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        Center(
                          child: GestureDetector(
                            onTap: () => restaurantController.selectLogoImage(),
                            child: Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2.w,
                                ),
                                color: AppColors.backgroundColor,
                              ),
                              child: restaurantController.logoImage != null
                                  ? ClipOval(
                                      child: Image.file(
                                        restaurantController.logoImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : restaurantController.restaurant?.logo !=
                                            null &&
                                        restaurantController
                                            .restaurant!
                                            .logo!
                                            .isNotEmpty
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: restaurantController
                                            .restaurant!
                                            .logo!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              color: AppColors.backgroundColor,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  vendorConfig.icon,
                                                  color: AppColors.primaryColor,
                                                  size: 32.sp,
                                                ),
                                                SizedBox(height: 4.h),
                                                customText(
                                                  "Add Logo",
                                                  color: AppColors.primaryColor,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          vendorConfig.icon,
                                          color: AppColors.primaryColor,
                                          size: 32.sp,
                                        ),
                                        SizedBox(height: 4.h),
                                        customText(
                                          "Add Logo",
                                          color: AppColors.primaryColor,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Image Guidelines
                        Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.05,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppColors.primaryColor,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  customText(
                                    "Image Guidelines",
                                    color: AppColors.primaryColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              customText(
                                "• Banner: Recommended size 1200x400px (landscape)\n• Logo: Recommended size 300x300px (square)\n• Use high-quality images for better presentation",
                                color: AppColors.primaryColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Vendor Name
                  CustomRoundedInputField(
                    title: vendorConfig.nameLabel,
                    hasTitle: true,
                    isRequired: true,
                    controller: restaurantController.restaurantNameController,
                    label: "Enter ${vendorConfig.displayName.toLowerCase()} name",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "${vendorConfig.nameLabel} is required";
                      }
                      if (value.trim().length < 2) {
                        return "${vendorConfig.nameLabel} must be at least 2 characters";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5.h),

                  // Description
                  CustomRoundedInputField(
                    title: "Description",
                    hasTitle: true,
                    controller: restaurantController.descriptionController,
                    label: "Enter ${vendorConfig.displayName.toLowerCase()} description (optional)",
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value != null && value.trim().length > 500) {
                        return "Description must be less than 500 characters";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5.h),

                  // Business Category (Cuisine Type for restaurants)
                  CustomRoundedInputField(
                    title: vendorConfig.categoryTypeLabel,
                    hasTitle: true,
                    isRequired: true,
                    controller: restaurantController.cuisineTypeController,
                    label: "e.g., Italian, Chinese, Nigerian",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "${vendorConfig.categoryTypeLabel} is required";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5.h),

                  // Email
                  CustomRoundedInputField(
                    title: "${vendorConfig.displayName} Email",
                    hasTitle: true,
                    isRequired: true,
                    controller: restaurantController.emailController,
                    label: "Enter ${vendorConfig.displayName.toLowerCase()} email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      if (!GetUtils.isEmail(value.trim())) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5.h),

                  // Phone
                  CustomRoundedInputField(
                    title: "${vendorConfig.displayName} Phone",
                    hasTitle: true,
                    isRequired: true,
                    controller: restaurantController.phoneController,
                    label: "Enter ${vendorConfig.displayName.toLowerCase()} phone number",
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Phone number is required";
                      }
                      if (!GetUtils.isPhoneNumber(value.trim())) {
                        return "Please enter a valid phone number";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 40.h),

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
                            "This information will be visible to customers when they view your ${vendorConfig.displayName.toLowerCase()}.",
                            color: AppColors.primaryColor,
                            fontSize: 11.sp,
                            overflow: TextOverflow.visible,
                            fontWeight: FontWeight.w400,
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

  Widget _buildImagePlaceholder(String title, IconData icon, String subtitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 32.sp),
        SizedBox(height: 8.h),
        customText(
          title,
          color: AppColors.primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 4.h),
        customText(
          subtitle,
          color: AppColors.greyColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
