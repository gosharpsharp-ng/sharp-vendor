import 'package:sharpvendor/core/models/menu_item_model.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';

import '../../../core/utils/exports.dart';
import '../../../core/utils/widgets/base64_image.dart';

class MenuDetailsScreen extends GetView<FoodMenuController> {
  const MenuDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the menu item from arguments
    final MenuItemModel menuItem = Get.arguments as MenuItemModel;

    return GetBuilder<FoodMenuController>(
      initState: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.setCurrentMenuItem(menuItem);
          controller.selectedPlateSize = menuItem.plateSize ?? "M";
          controller.showOnCustomerApp = menuItem.showOnCustomerApp ?? true;
        });
      },
      builder: (menuController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () {
              Get.back();
            },
            title: "",
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            child: CustomButton(
              onPressed: () {
                menuController.editMenuItem(menuItem);
              },
              isBusy: menuController.isLoading,
              title: "Edit",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section with Hero Effect
                Stack(
                  children: [
                    Container(
                      height: 300.h,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(0.2),
                      ),
                      child: menuItem.files.isEmpty
                          ? _buildPlaceholderImage()
                          : menuItem.files[0].url.startsWith('http')
                              ? Image.network(
                                  menuItem.files[0].url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholderImage();
                                  },
                                )
                              : Image.asset(menuItem.files[0].url, fit: BoxFit.cover),
                    ),
                    // Availability Badge
                    Positioned(
                      top: 16.h,
                      right: 16.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: menuItem.isAvailable == 1
                              ? AppColors.greenColor
                              : AppColors.redColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: customText(
                          menuItem.isAvailable == 1 ? "Available" : "Unavailable",
                          color: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                // Content Section
                Container(
                  padding: EdgeInsets.all(22.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: customText(
                              menuItem.name,
                              color: AppColors.blackColor,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: customText(
                              formatToCurrency(menuItem.price),
                              color: AppColors.primaryColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      // Category Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.greyColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: customText(
                          menuItem.category.name,
                          color: AppColors.blackColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Description
                      if (menuItem.description != null && menuItem.description!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              menuItem.description!,
                              color: AppColors.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              maxLines: 10,
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),

                      // Info Cards Section
                      customText(
                        "Menu Information",
                        color: AppColors.blackColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),

                      SizedBox(height: 12.h),

                      // Info Cards Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.schedule,
                              label: "Prep Time",
                              value: menuItem.duration,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.inventory_2_outlined,
                              label: "Quantity",
                              value: "${menuItem.availableQuantity}",
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Plate Size Section
                      customText(
                        "Plate Size",
                        color: AppColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: controller.plateSizes.map((size) {
                          bool isSelected = controller.selectedPlateSize == size;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.setSelectedPlateSize(size);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: size != controller.plateSizes.last ? 8.w : 0,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.whiteColor,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.greyColor.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: customText(
                                    size,
                                    color: isSelected
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 24.h),

                      // Settings Section
                      customText(
                        "Settings",
                        color: AppColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 12.h),

                      _buildSettingCard(
                        title: "Availability",
                        subtitle: "Make this menu ${menuItem.isAvailable == 1 ? 'unavailable' : 'available'}",
                        value: menuItem.isAvailable == 1,
                        onChanged: (value) {
                          controller.updateMenuItemAvailability(menuItem.id, value);
                        },
                      ),

                      SizedBox(height: 12.h),

                      _buildSettingCard(
                        title: "Show on customer app",
                        subtitle: "Display this menu in customer app",
                        value: controller.showOnCustomerApp,
                        onChanged: (value) {
                          controller.toggleShowOnCustomerApp(value);
                        },
                      ),

                      // Addons section
                      if (menuItem.addons.isNotEmpty) ...[
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              "Add-ons",
                              color: AppColors.blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: customText(
                                "${menuItem.addons.length}",
                                color: AppColors.primaryColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: menuItem.addons.length,
                          itemBuilder: (context, index) {
                            final addon = menuItem.addons[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              padding: EdgeInsets.all(12.sp),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.greyColor.withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.blackColor.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Addon image
                                  Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.greyColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: addon.files.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(addon.files[0].url),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: addon.files.isEmpty
                                        ? Icon(
                                            Icons.restaurant,
                                            color: AppColors.greyColor,
                                            size: 28.sp,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12.w),
                                  // Addon details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                          addon.name,
                                          color: AppColors.blackColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          maxLines: 1,
                                        ),
                                        SizedBox(height: 6.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.attach_money,
                                              size: 16.sp,
                                              color: AppColors.greenColor,
                                            ),
                                            customText(
                                              formatToCurrency(addon.price),
                                              color: AppColors.greenColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.greyColor,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 300.h,
      width: 1.sw,
      color: AppColors.greyColor.withOpacity(0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              size: 60.sp,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 12.h),
            customText(
              "No Image Available",
              color: AppColors.greyColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          title,
          color: AppColors.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        customText(
          value,
          color: AppColors.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildPlateSizeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          "Plate size",
          color: AppColors.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        Row(
          children: controller.plateSizes.map((size) {
            bool isSelected = controller.selectedPlateSize == size;
            return GestureDetector(
              onTap: () {
                controller.setSelectedPlateSize(size);
              },
              child: Container(
                margin: EdgeInsets.only(left: 12.w),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.whiteColor,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.greyColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: customText(
                  size,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilityRow(MenuItemModel menuItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          "Availability",
          color: AppColors.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        Switch(
          value: menuItem.isAvailable==1,
          onChanged: (value) {
            controller.updateMenuItemAvailability(menuItem.id, value);
          },
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildShowOnCustomerAppRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          "Show on customer app",
          color: AppColors.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        Switch(
          value: controller.showOnCustomerApp,
          onChanged: (value) {
            controller.toggleShowOnCustomerApp(value);
          },
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
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
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 12.h),
          customText(
            label,
            color: AppColors.greyColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.normal,
          ),
          SizedBox(height: 4.h),
          customText(
            value,
            color: AppColors.blackColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                customText(
                  subtitle,
                  color: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}