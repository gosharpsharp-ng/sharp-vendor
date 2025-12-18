import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';
import 'package:sharpvendor/core/models/categories_model.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';
import 'package:sharpvendor/modules/menu/widgets/addon_selection_bottom_sheet.dart';
import '../../../core/utils/exports.dart';

class AddMenuScreen extends GetView<FoodMenuController> {
  const AddMenuScreen({super.key});

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
              title: "${vendorConfig.productLabel} Setup",
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              child: CustomButton(
                onPressed: () {
                  menuController.saveMenuItem();
                },
                isBusy: menuController.isLoading,
                title: "Save",
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
                    // Product Image Section
                    customText(
                      vendorConfig.productImageLabel,
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
                                title: vendorConfig.productImageLabel,
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
                                    image: base64ToMemoryImage(
                                      menuController.foodImage!,
                                    ),
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

                    // Product Name
                    CustomRoundedInputField(
                      title: "${vendorConfig.productLabel} name",
                      label: "e.g Caesar Salad",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      controller: menuController.menuNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ${vendorConfig.productLabel.toLowerCase()} name';
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
                      keyboardType: TextInputType.multiline,
                      controller: menuController.descriptionController,
                    ),

                    SizedBox(height: 15.h),

                    // Price
                    CustomRoundedInputField(
                      title: "Price",
                      label: "₦1,000.00",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      keyboardType: TextInputType.number,
                      controller: menuController.priceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        String cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');
                        if (cleanedValue.isEmpty || double.tryParse(cleanedValue) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (value.isEmpty || newValue == '00') {
                          menuController.priceController.clear();
                          return;
                        }
                        double value1 = int.parse(newValue) / 100;
                        value = NumberFormat.currency(
                          locale: 'en_NG',
                          symbol: '₦',
                          decimalDigits: 2,
                        ).format(value1);
                        menuController.priceController.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.collapsed(offset: value.length),
                        );
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
                        bool isSelected =
                            menuController.selectedPlateSize == size;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                menuController.setSelectedPlateSize(size),
                            child: Container(
                              margin: EdgeInsets.only(
                                right: size != menuController.plateSizes.last
                                    ? 8.w
                                    : 0,
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
                                      : AppColors.greyColor.withValues(
                                          alpha: 0.3,
                                        ),
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

                    // Packaging Section
                    Row(
                      children: [
                        Checkbox(
                          value: menuController.hasPackaging,
                          onChanged: (value) {
                            menuController.toggleHasPackaging(value ?? false);
                          },
                          activeColor: AppColors.primaryColor,
                        ),
                        SizedBox(width: 8.w),
                        customText(
                          "Has Packaging",
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),

                    // Packaging Price (conditional)
                    if (menuController.hasPackaging) ...[
                      SizedBox(height: 8.h),
                      CustomRoundedInputField(
                        title: "Packaging Price",
                        label: "₦250.00",
                        showLabel: true,
                        isRequired: true,
                        hasTitle: true,
                        keyboardType: TextInputType.number,
                        controller: menuController.packagingPriceController,
                        validator: (value) {
                          if (menuController.hasPackaging) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter packaging price';
                            }
                            String cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');
                            if (cleanedValue.isEmpty || double.tryParse(cleanedValue) == null) {
                              return 'Please enter a valid price';
                            }
                            double numericValue = double.parse(cleanedValue) / 100;
                            if (numericValue <= 0) {
                              return 'Packaging price must be greater than 0';
                            }
                          }
                          return null;
                        },
                        onChanged: (value) {
                          String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (value.isEmpty || newValue == '00') {
                            menuController.packagingPriceController.clear();
                            return;
                          }
                          double value1 = int.parse(newValue) / 100;
                          value = NumberFormat.currency(
                            locale: 'en_NG',
                            symbol: '₦',
                            decimalDigits: 2,
                          ).format(value1);
                          menuController.packagingPriceController.value = TextEditingValue(
                            text: value,
                            selection: TextSelection.collapsed(offset: value.length),
                          );
                        },
                      ),
                    ],

                    SizedBox(height: 15.h),

                    // Availability Toggle
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: menuController.isAvailable == 1
                            ? AppColors.greenColor.withValues(alpha: 0.1)
                            : AppColors.redColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: menuController.isAvailable == 1
                              ? AppColors.greenColor.withValues(alpha: 0.3)
                              : AppColors.redColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: menuController.isAvailable == 1,
                            onChanged: (value) {
                              menuController.toggleAvailability(value == true ? 1 : 0);
                            },
                            activeColor: AppColors.greenColor,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  "Available for Order",
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(height: 2.h),
                                customText(
                                  menuController.isAvailable == 1
                                      ? "Customers can order this item"
                                      : "This item is currently unavailable",
                                  color: menuController.isAvailable == 1
                                      ? AppColors.greenColor
                                      : AppColors.redColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            menuController.isAvailable == 1
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: menuController.isAvailable == 1
                                ? AppColors.greenColor
                                : AppColors.redColor,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),

                    // Category Selection
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     customText(
                    //       "Category",
                    //       color: AppColors.blackColor,
                    //       fontSize: 13.sp,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Get.toNamed(Routes.CATEGORIES_MANAGEMENT_SCREEN);
                    //       },
                    //       child: customText(
                    //         "Add Category",
                    //         color: AppColors.greenColor,
                    //         fontSize: 13.sp,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 8.h),
                    ClickableCustomRoundedInputField(
                      title: "Category",
                      label: "Select Category",
                      readOnly: true,
                      showLabel: true,
                      hasTitle: true,
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
                          builder: (context) =>
                              const AddonSelectionBottomSheet(),
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
                            builder: (context) =>
                                const AddonSelectionBottomSheet(),
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
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
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
}

// Category Bottom Sheet Widget
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
                  final category = categories[index];
                  return ListTile(
                    leading:
                        category.iconUrl != null && category.iconUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedNetworkImage(
                              imageUrl: category.iconUrl!,
                              width: 40.sp,
                              height: 40.sp,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 40.sp,
                                height: 40.sp,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 40.sp,
                                height: 40.sp,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.restaurant,
                                  size: 20.sp,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 40.sp,
                            height: 40.sp,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.restaurant,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                    title: customText(
                      category.name,
                      color: AppColors.blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    subtitle: category.description.isNotEmpty
                        ? customText(
                            category.description,
                            color: AppColors.greyColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            maxLines: 1,
                          )
                        : null,
                    onTap: () {
                      onCategorySelected(category);
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
