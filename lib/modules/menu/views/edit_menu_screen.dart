import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:sharpvendor/core/models/categories_model.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';
import 'package:sharpvendor/modules/menu/widgets/addon_selection_bottom_sheet.dart';
import '../../../core/utils/exports.dart';
import '../../../core/utils/widgets/base64_image.dart';

class EditMenuScreen extends GetView<FoodMenuController> {
  const EditMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodMenuController>(
      builder: (menuController) {
        return Form(
          key: menuController.menuSetupFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () {
                Get.back();
              },
              title: "Edit Menu",
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              child: CustomButton(
                onPressed: () {
                  menuController.updateMenuItem();
                },
                isBusy: menuController.isLoading,
                title: "Update",
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Image Section
                    customText(
                      "Food image",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    DottedBorder(
                      options: RectDottedBorderOptions(
                        dashPattern: [8, 4],
                        strokeWidth: 1,
                        color: Colors.grey,
                        padding: EdgeInsets.all(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return CustomImagePickerBottomSheet(
                                title: "Food Image",
                                takePhotoFunction: () {
                                  menuController.selectFoodImage(
                                    pickFromCamera: true,
                                  );
                                },
                                selectFromGalleryFunction: () {
                                  menuController.selectFoodImage(
                                    pickFromCamera: false,
                                  );
                                },
                                deleteFunction: () {
                                  menuController.foodImage = null;
                                  menuController.update();
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 1.sw,
                          height: 120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: menuController.foodImage != null
                                ? DecorationImage(
                              image: _getImageProvider(menuController.foodImage!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 15.h,
                          ),
                          child: menuController.foodImage != null
                              ? Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                right: 2,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.backgroundColor,
                                  ),
                                  padding: EdgeInsets.all(8.sp),
                                  child: SvgPicture.asset(
                                    SvgAssets.cameraIcon,
                                    height: 20.sp,
                                    color: Colors.blue,
                                    width: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.backgroundColor,
                                ),
                                padding: EdgeInsets.all(8.sp),
                                child: SvgPicture.asset(
                                  SvgAssets.uploadIcon,
                                  height: 24.sp,
                                  width: 24.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              customText(
                                "Browse image to upload",
                                color: AppColors.blackColor,
                                fontSize: 12.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w500,
                              ),
                              customText(
                                "(Max. file size: 25 MB)",
                                color: AppColors.greyColor,
                                fontSize: 10.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Menu Name
                    CustomRoundedInputField(
                      title: "Menu name",
                      label: "e.g Caesar Salad",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      controller: menuController.menuNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter menu name';
                        }
                        return null;
                      },
                    ),

                    // Description
                    CustomRoundedInputField(
                      title: "Description",
                      label: "Fresh romaine with parmesan...",
                      showLabel: true,
                      isRequired: false,
                      hasTitle: true,
                      maxLines: 3,
                      controller: menuController.descriptionController,
                    ),

                    SizedBox(height: 15.h),

                    // Price
                    CustomRoundedInputField(
                      title: "Price",
                      label: "12.99",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      keyboardType: TextInputType.number,
                      controller: menuController.priceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 15.h),

                    // Prep Time (minutes)
                    CustomRoundedInputField(
                      title: "Prep time (minutes)",
                      label: "15",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      keyboardType: TextInputType.number,
                      controller: menuController.prepTimeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter prep time';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Prep time must be greater than 0';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 15.h),

                    // Plate Size Selection
                    customText(
                      "Plate size",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: menuController.plateSizes.map((size) {
                        bool isSelected = menuController.selectedPlateSize == size;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => menuController.setSelectedPlateSize(size),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: size != menuController.plateSizes.last ? 8.w : 0,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.greyColor.withOpacity(0.3),
                                ),
                              ),
                              child: Center(
                                child: customText(
                                  size,
                                  color: isSelected
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 15.h),

                    // Category Selection
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          "Category",
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Get.toNamed(Routes.CATEGORIES_MANAGEMENT_SCREEN);
                        //   },
                        //   child: customText(
                        //     "Add Category",
                        //     color: AppColors.greenColor,
                        //     fontSize: 13.sp,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClickableCustomRoundedInputField(
                      title: "Category",
                      label: "Select Category",
                      readOnly: true,
                      showLabel: true,
                      hasTitle: false,
                      isRequired: true,
                      controller: TextEditingController(
                        text: menuController.selectedCategory?.name ?? "",
                      ),
                      onPressed: () {
                        showAnyBottomSheet(
                          child: CategoryBottomSheet(
                            categories: menuController.categories,
                            onCategorySelected: (category) {
                              menuController.setSelectedCategory(category);
                              Get.back();
                            },
                          ),
                        );
                      },
                      suffixWidget: IconButton(
                        onPressed: () {
                          showAnyBottomSheet(
                            child: CategoryBottomSheet(
                              categories: menuController.categories,
                              onCategorySelected: (category) {
                                menuController.setSelectedCategory(category);
                                Get.back();
                              },
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          SvgAssets.downChevronIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Addons Selection
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          "Add-ons",
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClickableCustomRoundedInputField(
                      title: "Add-ons",
                      label: "Select Add-ons (optional)",
                      readOnly: true,
                      showLabel: true,
                      hasTitle: false,
                      isRequired: false,
                      controller: TextEditingController(
                        text: menuController.selectedAddons.isEmpty
                            ? ""
                            : "${menuController.selectedAddons.length} add-on(s) selected",
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (context) => const AddonSelectionBottomSheet(),
                        );
                      },
                      suffixWidget: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) => const AddonSelectionBottomSheet(),
                          );
                        },
                        icon: SvgPicture.asset(
                          SvgAssets.downChevronIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),

                    // Selected addons display
                    if (menuController.selectedAddons.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: menuController.selectedAddons.map((addon) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customText(
                                  addon.name,
                                  color: AppColors.primaryColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(width: 6.w),
                                GestureDetector(
                                  onTap: () {
                                    menuController.removeAddon(addon);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 16.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    SizedBox(height: 20.h),

                    // Show on customer app toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "Show on customer app",
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              customText(
                                "Toggle visibility for customers",
                                color: AppColors.greyColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: menuController.showOnCustomerApp,
                          onChanged: menuController.toggleShowOnCustomerApp,
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Availability Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          "Available",
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        Switch(
                          value: menuController.isAvailable==1,
                          onChanged: (bool value){
                            menuController.toggleAvailability(value ? 1 : 0);
                          },
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),

                    SizedBox(height: 15.h),

                    // Available Quantity
                    if (menuController.isAvailable==1) ...[
                      customText(
                        "Available quantity",
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              menuController.decrementQuantity();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.greyColor.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 20.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.greyColor.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: customText(
                              menuController.availableQuantity.toString(),
                              color: AppColors.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          InkWell(
                            onTap: () {
                              menuController.incrementQuantity();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.greyColor.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 20.sp,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                    ],

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to determine image provider based on image source
  ImageProvider _getImageProvider(String imagePath) {
    try {
      // Check if it's a base64 string (with or without data URI prefix)
      if (imagePath.contains('data:image') || _isBase64(imagePath)) {
        return base64ToMemoryImage(imagePath);
      }
      // Check if it's a network URL
      else if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return NetworkImage(imagePath);
      }
      // Check if it's a file path
      else if (imagePath.startsWith('/') || imagePath.contains('file://')) {
        return FileImage(File(imagePath.replaceFirst('file://', '')));
      }
      // Assume it's an asset path
      else {
        return AssetImage(imagePath);
      }
    } catch (e) {
      // Fallback - try network image first, then asset
      if (imagePath.startsWith('http')) {
        return NetworkImage(imagePath);
      }
      return AssetImage('assets/images/placeholder.png'); // Fallback image
    }
  }

  // Helper method to check if string is base64
  bool _isBase64(String str) {
    try {
      // Remove any data URI prefix first
      String cleanStr = str;
      if (str.contains(',')) {
        cleanStr = str.split(',').last;
      }

      // Basic check for base64 pattern
      return RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(cleanStr) &&
             cleanStr.length % 4 == 0 &&
             cleanStr.length > 0;
    } catch (e) {
      return false;
    }
  }
}

// Category Bottom Sheet Widget (reuse from Add Menu Screen)
class CategoryBottomSheet extends StatelessWidget {
  final List<CategoryModel> categories;
  final Function(CategoryModel) onCategorySelected;

  const CategoryBottomSheet({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            "Select Category",
            color: AppColors.blackColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 16.h),
          if (categories.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: customText(
                  "No categories available. Add a category first.",
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: customText(
                      categories[index].name,
                      color: AppColors.blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    onTap: () {
                      onCategorySelected(categories[index]);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}