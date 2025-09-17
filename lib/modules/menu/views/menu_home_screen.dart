import 'package:sharpvendor/core/models/menu_item_model.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';

import '../../../core/utils/exports.dart';
import '../../../core/utils/widgets/base64_image.dart';

class MenuHomeScreen extends GetView<FoodMenuController> {
  const MenuHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (menuController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            implyLeading: false,
            centerTitle: true,
            title: "Menu",
          ),
          backgroundColor: AppColors.backgroundColor,
          floatingActionButton: FloatingActionButton(onPressed: (){
            menuController.clearForm();
            Get.toNamed(Routes.ADD_MENU_SCREEN);
          },backgroundColor: AppColors.primaryColor,child: Icon(Icons.add,color: AppColors.whiteColor,),),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            height: 1.sh,
            width: 1.sw,
            child: RefreshIndicator(
              onRefresh: () async {
                await menuController.getMenuItems();
              },
              child: menuController.isLoadingMenuItems
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : menuController.menuItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            SvgAssets.ordersIcon, // Add your empty state icon
                            height: 100.sp,
                            width: 100.sp,
                          ),
                          SizedBox(height: 20.h),
                          customText(
                            "No menu items yet",
                            color: AppColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 8.h),
                          customText(
                            "Add your first menu item to get started",
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.h),
                          CustomButton(
                            onPressed: () {
                              menuController.clearForm();
                              Get.toNamed(Routes.ADD_MENU_SCREEN);
                            },
                            title: "Add Menu Item",
                            width: 200.w,
                            backgroundColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: menuController.menuItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final menuItem = menuController.menuItems[index];
                        return MenuItemCard(
                          menuItem: menuItem,
                          onTap: () {
                            Get.toNamed(
                              Routes.MENU_DETAILS_SCREEN,
                              arguments: menuItem,
                            );
                          },
                          onEdit: () {
                            menuController.editMenuItem(menuItem);
                          },
                          onDelete: () {
                            _showDeleteDialog(context, menuItem);
                          },
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, MenuItemModel menuItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: customText(
            "Delete Menu Item",
            color: AppColors.blackColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          content: customText(
            "Are you sure you want to delete '${menuItem.name}'? This action cannot be undone.",
            color: AppColors.greyColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: customText(
                "Cancel",
                color: AppColors.greyColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                controller.deleteMenuItem(menuItem.id);
              },
              child: customText(
                "Delete",
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItemModel menuItem;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MenuItemCard({
    Key? key,
    required this.menuItem,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
                color: AppColors.greyColor.withOpacity(0.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
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
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customText(
                          menuItem.name,
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: customText(
                          menuItem.category.name,
                          color: AppColors.primaryColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Price and Duration Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(
                        "₦${menuItem.price.toStringAsFixed(2)}/plate",
                        color: AppColors.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      customText(
                        menuItem.duration,
                        color: AppColors.greyColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Availability and Actions Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: menuItem.isAvailable==1
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          customText(
                            menuItem.isAvailable==1 ? "Available" : "Unavailable",
                            color: menuItem.isAvailable==1
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(width: 10.w),
                          customText(
                            "Qty: ${menuItem.availableQuantity}",
                            color: AppColors.greyColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: onEdit,
                            child: Container(
                              padding: EdgeInsets.all(6.sp),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 16.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          InkWell(
                            onTap: onDelete,
                            child: Container(
                              padding: EdgeInsets.all(6.sp),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                size: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.greyColor.withOpacity(0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 40.sp, color: AppColors.greyColor),
            SizedBox(height: 8.h),
            customText(
              "No Image",
              color: AppColors.greyColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}
