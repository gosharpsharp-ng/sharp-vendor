import 'package:dotted_border/dotted_border.dart';
import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:sharpvendor/core/utils/widgets/base64_image.dart';

class BusinessInformationEntryScreen extends GetView<SignUpController> {
  const BusinessInformationEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (signUpController) {
        return Form(
          key: signUpController.businessInfoFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () {
                Get.back();
              },
              title: "Business Info",
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              child: CustomButton(
                onPressed: () {
                  // Validate the business information form before proceeding
                  if (signUpController.businessInfoFormKey.currentState!.validate()) {
                    // Check for required images
                    if (signUpController.restaurantBanner == null) {
                      showToast(
                        message: "Please upload a restaurant banner",
                        isError: true,
                      );
                      return;
                    }

                    if (signUpController.restaurantLogo == null) {
                      showToast(
                        message: "Please upload a restaurant logo",
                        isError: true,
                      );
                      return;
                    }

                    // Check for restaurant location
                    if (signUpController.restaurantLocation == null ||
                        signUpController.restaurantAddressController.text.trim().isEmpty) {
                      showToast(
                        message: "Please select a business address",
                        isError: true,
                      );
                      return;
                    }

                    // Additional validation for phone number
                    if (signUpController.filledPhoneNumber == null ||
                        signUpController.phoneNumberController.text.isEmpty) {
                      showToast(
                        message: "Please enter a valid business phone number",
                        isError: true,
                      );
                      return;
                    }

                    // All validations passed, proceed to business operations screen
                    Get.toNamed(Routes.BUSINESS_OPERATIONS_ENTRY_SCREEN);
                  } else {
                    // Form validation failed, show error message
                    showToast(
                      message: "Please fill in all required fields correctly",
                      isError: true,
                    );
                  }
                },
                isBusy: signUpController.isLoading,
                title: "Continue",
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
                    // Restaurant Banner Section
                    Row(
                      children: [
                        customText(
                          "Restaurant Banner",
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        customText(
                          " *",
                          color: AppColors.redColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
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
                                title: "Banner Image",
                                takePhotoFunction: () {
                                  signUpController.selectRestaurantBanner(
                                    pickFromCamera: true,
                                  );
                                },
                                selectFromGalleryFunction: () {
                                  signUpController.selectRestaurantBanner(
                                    pickFromCamera: false,
                                  );
                                },
                                deleteFunction: () {
                                  signUpController.restaurantBanner = null;
                                  signUpController.update();
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 1.sw,
                          height: 150.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: signUpController.restaurantBanner != null
                                ? DecorationImage(
                              image: base64ToMemoryImage(
                                signUpController.restaurantBanner!,
                              ),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 15.h,
                          ),
                          child: signUpController.restaurantBanner != null
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
                                    height: 30.sp,
                                    color: Colors.blue,
                                    width: 30.sp,
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
                                ),
                              ),
                              customText(
                                "Browse image to upload",
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w500,
                              ),
                              customText(
                                "(Max. file size: 25 MB)",
                                color: AppColors.blackColor,
                                fontSize: 13.sp,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Restaurant Logo Section
                    Row(
                      children: [
                        customText(
                          "Restaurant Logo",
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        customText(
                          " *",
                          color: AppColors.redColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
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
                                    title: "Logo Image",
                                    takePhotoFunction: () {
                                      signUpController.selectRestaurantLogo(
                                        pickFromCamera: true,
                                      );
                                    },
                                    selectFromGalleryFunction: () {
                                      signUpController.selectRestaurantLogo(
                                        pickFromCamera: false,
                                      );
                                    },
                                    deleteFunction: () {
                                      signUpController.restaurantLogo = null;
                                      signUpController.update();
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 120.w,
                              height: 120.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                image: signUpController.restaurantLogo != null
                                    ? DecorationImage(
                                  image: base64ToMemoryImage(
                                    signUpController.restaurantLogo!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.sp,
                                vertical: 8.h,
                              ),
                              child: signUpController.restaurantLogo != null
                                  ? Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.backgroundColor,
                                      ),
                                      padding: EdgeInsets.all(4.sp),
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
                                    padding: EdgeInsets.all(6.sp),
                                    child: SvgPicture.asset(
                                      SvgAssets.uploadIcon,
                                      height: 20.sp,
                                      width: 20.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  customText(
                                    "Upload Logo",
                                    color: AppColors.blackColor,
                                    fontSize: 12.sp,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "Upload your restaurant logo",
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                "Recommended size: 200x200px\nMax file size: 5MB\nFormats: JPG, PNG",
                                color: AppColors.greyColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Restaurant Name Field
                    CustomRoundedInputField(
                      title: "Restaurant Name",
                      label: "Chachalina",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      controller: signUpController.restaurantNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Restaurant name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Restaurant name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),

                    // Cuisine Type Field
                    CustomRoundedInputField(
                      title: "Cuisine Type",
                      label: "e.g. Italian, Nigerian, Chinese, Fast Food",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      controller: signUpController.cuisineTypeController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Cuisine type is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Cuisine type must be at least 2 characters';
                        }
                        return null;
                      },
                    ),

                    // Business Address Field
                    ClickableCustomRoundedInputField(
                      onPressed: () async {
                        final ItemLocation result =
                        await Get.toNamed(Routes.SELECT_LOCATION_SCREEN);
                        signUpController.setRestaurantLocation(result);
                      },
                      suffixWidget: IconButton(
                        onPressed: () async {
                          final ItemLocation result =
                          await Get.toNamed(Routes.SELECT_LOCATION_SCREEN);
                          signUpController.setRestaurantLocation(result);
                        },
                        icon: SvgPicture.asset(
                          SvgAssets.locationIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      title: "Business Address",
                      readOnly: true,
                      label: "No. 8 Police Round-about, Jimeta",
                      showLabel: true,
                      hasTitle: true,
                      isRequired: true,
                      controller: signUpController.restaurantAddressController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Business address is required';
                        }
                        if (signUpController.restaurantLocation == null) {
                          return 'Please select a valid address from the map';
                        }
                        return null;
                      },
                    ),

                    // Business Phone Field
                    CustomRoundedPhoneInputField(
                      title: "Business Phone",
                      label: "7061032122",
                      onChanged: (PhoneNumber phone) {
                        if (phone.number.isNotEmpty &&
                            phone.number.startsWith('0')) {
                          final updatedNumber = phone.number.replaceFirst(
                            RegExp(r'^0'),
                            '',
                          );
                          signUpController.restaurantPhoneController.value =
                              TextEditingValue(
                                text: updatedNumber,
                                selection: TextSelection.collapsed(
                                  offset: updatedNumber.length,
                                ),
                              );
                        }
                      },
                      keyboardType: TextInputType.phone,
                      validator: (phone) {
                        if (phone == null || phone.completeNumber.isEmpty) {
                          return "Business phone number is required";
                        }
                        final regex = RegExp(r'^\+234[1-9]\d{9}$');
                        if (!regex.hasMatch(phone.completeNumber)) {
                          return "Phone number must start with +234 and be 10 digits long";
                        }
                        return null;
                      },
                      isPhone: true,
                      hasTitle: true,
                      controller: signUpController.restaurantPhoneController,
                    ),

                    // Business Email Field
                    CustomRoundedInputField(
                      title: "Business Email",
                      label: "restaurant@example.com",
                      showLabel: true,
                      isRequired: true,
                      useCustomValidator: true,
                      keyboardType: TextInputType.emailAddress,
                      hasTitle: true,
                      controller: signUpController.restaurantEmailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Business email is required';
                        } else if (!validateEmail(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.sp),
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