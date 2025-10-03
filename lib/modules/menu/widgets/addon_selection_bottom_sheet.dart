import 'package:sharpvendor/core/models/menu_item_model.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';
import '../../../core/utils/exports.dart';

class AddonSelectionBottomSheet extends StatefulWidget {
  const AddonSelectionBottomSheet({super.key});

  @override
  State<AddonSelectionBottomSheet> createState() =>
      _AddonSelectionBottomSheetState();
}

class _AddonSelectionBottomSheetState
    extends State<AddonSelectionBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  List<MenuItemModel> filteredMenuItems = [];

  @override
  void initState() {
    super.initState();
    final controller = Get.find<FoodMenuController>();
    filteredMenuItems = controller.menuItems;

    searchController.addListener(() {
      setState(() {
        if (searchController.text.isEmpty) {
          filteredMenuItems = controller.menuItems;
        } else {
          filteredMenuItems = controller.menuItems
              .where((item) => item.name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
          height: 0.8.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    "Select Addons",
                    color: AppColors.blackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  if (controller.selectedAddons.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        controller.clearAddons();
                      },
                      child: customText(
                        "Clear All",
                        color: AppColors.redColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),

              SizedBox(height: 12.h),

              // Selected addons count
              if (controller.selectedAddons.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: customText(
                    "${controller.selectedAddons.length} addon(s) selected",
                    color: AppColors.primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              SizedBox(height: 16.h),

              // Search Field
              CustomRoundedInputField(
                title: "",
                label: "Search menu items...",
                showLabel: true,
                hasTitle: false,
                controller: searchController,
                prefixWidget: Icon(
                  Icons.search,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
              ),

              SizedBox(height: 16.h),

              // Menu Items List
              Expanded(
                child: filteredMenuItems.isEmpty
                    ? Center(
                        child: customText(
                          "No menu items available",
                          color: AppColors.greyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredMenuItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredMenuItems[index];
                          final isSelected = controller.isAddonSelected(item);
                          final isCurrentItem = controller.currentMenuItem?.id == item.id;

                          // Don't show the current menu item being edited
                          if (isCurrentItem) {
                            return const SizedBox.shrink();
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.greyColor.withOpacity(0.3),
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              leading: Container(
                                width: 50.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: item.files.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(item.files[0].url),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: item.files.isEmpty
                                    ? Icon(
                                        Icons.restaurant,
                                        color: AppColors.greyColor,
                                        size: 24.sp,
                                      )
                                    : null,
                              ),
                              title: customText(
                                item.name,
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.h),
                                  customText(
                                    formatToCurrency(item.price),
                                    color: AppColors.greenColor,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  if (item.category.name.isNotEmpty) ...[
                                    SizedBox(height: 2.h),
                                    customText(
                                      item.category.name,
                                      color: AppColors.greyColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ],
                                ],
                              ),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    controller.addAddon(item);
                                  } else {
                                    controller.removeAddon(item);
                                  }
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              onTap: () {
                                if (isSelected) {
                                  controller.removeAddon(item);
                                } else {
                                  controller.addAddon(item);
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),

              SizedBox(height: 16.h),

              // Done Button
              CustomButton(
                onPressed: () {
                  Get.back();
                },
                title: "Done",
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
            ],
          ),
        );
      },
    );
  }
}