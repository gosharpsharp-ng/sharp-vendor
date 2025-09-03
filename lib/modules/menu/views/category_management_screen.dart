import '../../../core/utils/exports.dart';
import '../controllers/food_menu_controller.dart';

class CategoryManagementScreen extends GetView<FoodMenuController> {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (menuController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () => Get.back(),
            title: "Category management",
            actionItem: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Toggle search visibility or implement search functionality
                  },
                  icon: SvgPicture.asset(
                    SvgAssets.searchIcon,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            height: 1.sh,
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add new category button
                InkWell(
                  onTap: () {
                    menuController.showAddCategoryModal(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.greyColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.sp),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.whiteColor,
                            size: 16.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        customText(
                          "Add new category",
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // All categories header
                customText(
                  "All categories",
                  color: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),

                SizedBox(height: 16.h),

                // Categories list
                Expanded(
                  child: menuController.isLoadingCategories
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                      : menuController.filteredCategories.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SvgAssets.menuIcon,
                          height: 80.h,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 16.h),
                        customText(
                          "No categories found",
                          color: AppColors.greyColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        customText(
                          "Add your first category to get started",
                          color: AppColors.greyColor,
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    itemCount: menuController.filteredCategories.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final category = menuController.filteredCategories[index];
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.greyColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: customText(
                                category.name,
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    menuController.showEditCategoryModal(
                                      context,
                                      category,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.sp),
                                    child: SvgPicture.asset(
                                      SvgAssets.editIcon,
                                      color: AppColors.primaryColor,
                                      height: 18.sp,
                                      width: 18.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                InkWell(
                                  onTap: () {
                                    menuController.showDeleteConfirmationDialog(
                                      context,
                                      category,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.sp),
                                    child: SvgPicture.asset(
                                      SvgAssets.deleteIcon,
                                      color: Colors.red,
                                      height: 18.sp,
                                      width: 18.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Category Form Modal Widget
class CategoryFormModal extends GetView<FoodMenuController> {
  const CategoryFormModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (menuController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Form(
            key: menuController.categoryFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modal header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      menuController.isEditMode ? "Edit Category" : "Enter New Category",
                      color: AppColors.blackColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: AppColors.greyColor,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Category input field
                CustomRoundedInputField(
                  title: "",
                  label: "Category",
                  showLabel: true,
                  hasTitle: false,
                  controller: menuController.categoryNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    if (value.length < 2) {
                      return 'Category name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 24.h),

                // Action buttons
                if (menuController.isEditMode)
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () => Get.back(),
                          title: "Back",
                          backgroundColor: AppColors.greyColor.withOpacity(0.2),
                          fontColor: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            menuController.showDeleteConfirmationDialog(
                              context,
                              menuController.selectedCategoryModel!,
                            );
                          },
                          title: "Delete",
                          backgroundColor: Colors.red,
                          fontColor: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  )
                else
                  CustomButton(
                    onPressed: () {
                      menuController.saveCategory();
                    },
                    isBusy: menuController.isLoading,
                    title: "Save category",
                    width: 1.sw,
                    backgroundColor: AppColors.primaryColor,
                    fontColor: AppColors.whiteColor,
                  ),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Category Delete Confirmation Dialog
class CategoryDeleteDialog extends GetView<FoodMenuController> {
  const CategoryDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (menuController) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          contentPadding: EdgeInsets.all(24.sp),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customText(
                "Delete this category?",
                color: AppColors.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              customText(
                "You are about to delete this category from the list of your menu categories. This action cannot be reversed.\n\nPressing DELETE removes it permanently. Do you still want to delete this category?",
                color: AppColors.greyColor,
                fontSize: 14.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPressed: () {
                  menuController.deleteCategory();
                },
                isBusy: menuController.isLoading,
                title: "Delete",
                width: 1.sw,
                backgroundColor: Colors.red,
                fontColor: AppColors.whiteColor,
              ),
            ],
          ),
        );
      },
    );
  }
}