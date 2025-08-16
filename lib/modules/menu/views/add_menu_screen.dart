import 'package:dotted_border/dotted_border.dart';
import 'package:sharpvendor/modules/menu/controllers/food_menu_controller.dart';
import '../../../core/utils/exports.dart';
import '../../../core/utils/widgets/base64_image.dart';

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
              title: "Menu Setup",
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

                    // Menu Name
                    CustomRoundedInputField(
                      title: "Menu name",
                      label: "e.g Ofada Rice",
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
                      label: "Comment",
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
                      label: "N0,000.00",
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

                    // Category Dropdown
                    customText(
                      "Category",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.whiteColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: customText(
                            "Select",
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                          ),
                          value: menuController.selectedCategory,
                          icon: SvgPicture.asset(
                            SvgAssets.downChevronIcon,
                            color: AppColors.primaryColor,
                          ),
                          items: menuController.categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: customText(
                                category,
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              menuController.setSelectedCategory(newValue);
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Availability Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          "Availability",
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        Switch(
                          value: menuController.isAvailable,
                          onChanged: (value) {
                            menuController.toggleAvailability(value);
                          },
                          activeColor: AppColors.primaryColor,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Food Duration Dropdown
                    customText(
                      "Food duration",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.whiteColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: customText(
                            "Select",
                            color: AppColors.greyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                          ),
                          value: menuController.selectedFoodDuration,
                          icon: SvgPicture.asset(
                            SvgAssets.downChevronIcon,
                            color: AppColors.primaryColor,
                          ),
                          items: menuController.foodDurations.map((String duration) {
                            return DropdownMenuItem<String>(
                              value: duration,
                              child: customText(
                                duration,
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              menuController.setSelectedFoodDuration(newValue);
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Available Quantity
                    customText(
                      "Available quantity",
                      color: AppColors.blackColor,
                      fontSize: 13.sp,
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