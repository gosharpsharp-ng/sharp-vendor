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
                // Image Section
                Container(
                  height: 300.h,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withOpacity(0.2),
                  ),
                  child:menuItem.files.isEmpty
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

                // Content Section
                Container(
                  padding: EdgeInsets.all(22.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      customText(
                        menuItem.name,
                        color: AppColors.blackColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        maxLines: 2,
                      ),

                      SizedBox(height: 16.h),

                      // Description
                      if (menuItem.description != null && menuItem.description!.isNotEmpty)
                        customText(
                          menuItem.description!,
                          color: AppColors.greyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          maxLines: 10,
                        ),

                      SizedBox(height: 24.h),

                      // Details Section
                      _buildDetailRow("Price", "₦${menuItem.price.toStringAsFixed(2)}"),

                      SizedBox(height: 16.h),
                      _buildPlateSizeRow(),

                      SizedBox(height: 16.h),
                      _buildDetailRow("Category", menuItem.category.name),

                      SizedBox(height: 16.h),
                      _buildDetailRow("Duration", menuItem.duration),

                      SizedBox(height: 16.h),
                      _buildDetailRow("Quantity", "${menuItem.availableQuantity} packs"),

                      SizedBox(height: 16.h),
                      _buildAvailabilityRow(menuItem),

                      SizedBox(height: 16.h),
                      _buildShowOnCustomerAppRow(),

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
}