import '../../../core/utils/exports.dart';
import '../controllers/food_menu_controller.dart';

// Category Form Modal Widget
class CategoryForm extends GetView<FoodMenuController> {
  const CategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (menuController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          ),
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
                      menuController.isEditMode
                          ? "Edit Category"
                          : "Enter New Category",
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
                    // Check if category already exists (for add mode)
                    if (!menuController.isEditMode) {
                      bool categoryExists = menuController.categoryModels.any(
                        (cat) => cat.name.toLowerCase() == value.toLowerCase(),
                      );
                      if (categoryExists) {
                        return 'Category already exists';
                      }
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
                          backgroundColor: AppColors.greyColor.withValues(
                            alpha: 0.2,
                          ),
                          fontColor: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {
                            Get.back(); // Close current modal first
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                menuController.showDeleteConfirmationDialog(
                                  context,
                                  menuController.selectedCategoryModel!,
                                );
                              },
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

                // Add some space for keyboard
                SizedBox(height: 20.h),
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
          backgroundColor: AppColors.whiteColor,
          contentPadding: EdgeInsets.all(24.sp),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog title
              customText(
                "Delete this category?",
                color: AppColors.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // Warning message
              customText(
                "You are about to delete this category from the list of your menu categories. This action cannot be reversed.",
                color: AppColors.greyColor,
                fontSize: 14.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
              ),

              SizedBox(height: 12.h),

              customText(
                "Pressing DELETE removes it permanently. Do you still want to delete this category?",
                color: AppColors.greyColor,
                fontSize: 14.sp,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
              ),

              SizedBox(height: 24.h),

              // Delete button
              CustomButton(
                onPressed: () {
                  menuController.deleteCategory();
                },
                isBusy: menuController.isLoading,
                title: "Delete",
                width: double.infinity,
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

// Alternative Edit Category Modal (if you prefer the mockup design with Back/Delete buttons)
class EditCategoryModal extends GetView<FoodMenuController> {
  const EditCategoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (menuController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          ),
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
                      "Enter New Category",
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

                // Back and Delete buttons (as shown in mockup)
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () => Get.back(),
                        title: "Back",
                        backgroundColor: AppColors.greyColor.withValues(
                          alpha: 0.1,
                        ),
                        fontColor: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          Get.back(); // Close modal first
                          Future.delayed(const Duration(milliseconds: 300), () {
                            menuController.showDeleteConfirmationDialog(
                              context,
                              menuController.selectedCategoryModel!,
                            );
                          });
                        },
                        title: "Delete",
                        backgroundColor: Colors.red,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
