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
              child:  CustomButton(
                onPressed: () {
                  // signUpController.signUp();
                  Get.toNamed(Routes.BUSINESS_OPERATIONS_ENTRY_SCREEN);
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
                    customText(
                      "Restaurant Banner",
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
                                title: "Banner Image",
                                takePhotoFunction: () {
                                  signUpController.selectParcelImage(
                                    pickFromCamera: true,
                                  );
                                },
                                selectFromGalleryFunction: () {
                                  signUpController.selectParcelImage(
                                    pickFromCamera: false,
                                  );
                                },
                                deleteFunction: () {},
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 1.sw,
                          height: 150.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: signUpController.parcelImage != null
                                ? DecorationImage(
                                    image: base64ToMemoryImage(
                                      signUpController.parcelImage!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 15.h,
                          ),
                          child: signUpController.parcelImage != null
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
                    SizedBox(height: 14.h),
                    CustomRoundedInputField(
                      title: "Restaurant Name",
                      label: "Chachalina",
                      showLabel: true,
                      isRequired: true,
                      hasTitle: true,
                      controller: signUpController.firstNameController,
                    ),
                    ClickableCustomRoundedInputField(
                      onPressed: () async {
                        // final ItemLocation result =
                        // await Get.toNamed(Routes.SELECT_LOCATION_SCREEN);
                        // ordersController.setDeliverySenderLocation(result);
                        // if (ordersController.deliveryReceiverLocation !=
                        //     null) {
                        //   await ordersController.getRideEstimatedDistance();
                        // }
                      },
                      suffixWidget: IconButton(
                        onPressed: () async {
                          // final ItemLocation result = await Get.toNamed(
                          //     Routes.SELECT_LOCATION_SCREEN);
                          // ordersController.setDeliverySenderLocation(result);
                          // if (ordersController.deliveryReceiverLocation !=
                          //     null) {
                          //   await ordersController.getRideEstimatedDistance();
                          // }
                        },
                        icon: SvgPicture.asset(
                          SvgAssets.locationIcon,
                          // h: 20.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      title: "Business Address",
                      readOnly: true,
                      label: "No. 8 Police Round-about, Jimeta",
                      showLabel: true,
                      hasTitle: true,
                      isRequired: true,
                      // controller: ordersController.senderAddressController,
                    ),

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
                          signUpController.phoneNumberController.value =
                              TextEditingValue(
                                text: updatedNumber,
                                selection: TextSelection.collapsed(
                                  offset: updatedNumber.length,
                                ),
                              );
                          signUpController.setPhoneNumber(updatedNumber);
                          signUpController.setFilledPhoneNumber(
                            PhoneNumber(
                              countryISOCode: phone.countryISOCode,
                              countryCode: phone.countryCode,
                              number: updatedNumber,
                            ),
                          );
                        } else {
                          signUpController.setFilledPhoneNumber(phone);
                        }
                      },
                      keyboardType: TextInputType.phone,
                      validator: (phone) {
                        if (phone == null || phone.completeNumber.isEmpty) {
                          return "Phone number is required";
                        }
                        // Regex: `+` followed by 1 to 3 digits (country code), then 10 digits (phone number)
                        final regex = RegExp(r'^\+234[1-9]\d{9}$');
                        if (!regex.hasMatch(phone.completeNumber)) {
                          return "Phone number must start with +234 and be 10 digits long";
                        }
                        if (signUpController
                                .phoneNumberController
                                .text
                                .isEmpty ||
                            signUpController.phoneNumberController.text ==
                                null) {
                          return "Phone number is required";
                        }
                        return null;
                      },
                      isPhone: true,
                      hasTitle: true,
                      controller: signUpController.phoneNumberController,
                    ),
                    CustomRoundedInputField(
                      title: "Email",
                      label: "meter.me@gmail.com",
                      showLabel: true,
                      isRequired: true,
                      useCustomValidator: true,
                      keyboardType: TextInputType.emailAddress,
                      hasTitle: true,
                      controller: signUpController.emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        } else if (!validateEmail(value)) {
                          return 'Please enter a valid email';
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
