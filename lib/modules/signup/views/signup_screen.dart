import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(builder: (signUpController) {
      return Form(
        key: signUpController.signUpFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: (){
                Get.back();
              },
              title: "Create an account"
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.sp,
                        ),
                        customText(
                            "Please fill in the fields below to create your account",
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal),
                        SizedBox(
                          height: 5.sp,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 20.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomRoundedInputField(
                          title: "First name",
                          label: "John",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: signUpController.firstNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'First name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'First name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedInputField(
                          title: "Last name",
                          label: "Doe",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: signUpController.lastNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Last name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Last name must be at least 2 characters';
                            }
                            return null;
                          },
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
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required';
                            } else if (!validateEmail(value.trim())) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedPhoneInputField(
                          title: "Phone number (required)",
                          label: "7061032122",
                          onChanged: (PhoneNumber phone) {
                            if (phone.number.isNotEmpty &&
                                phone.number.startsWith('0')) {
                              final updatedNumber =
                              phone.number.replaceFirst(RegExp(r'^0'), '');
                              signUpController.phoneNumberController.value =
                                  TextEditingValue(
                                    text: updatedNumber,
                                    selection: TextSelection.collapsed(
                                        offset: updatedNumber.length),
                                  );
                              signUpController.setPhoneNumber(
                                updatedNumber,
                              );
                              signUpController.setFilledPhoneNumber(PhoneNumber(
                                countryISOCode: phone.countryISOCode,
                                countryCode: phone.countryCode,
                                number: updatedNumber,
                              ));
                            }else{
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
                            if(signUpController.phoneNumberController.text.isEmpty || signUpController.phoneNumberController.text==null){
                              return "Phone number is required";
                            }
                            return null;
                          },
                          isPhone: true,
                          hasTitle: true,
                          controller: signUpController.phoneNumberController,
                        ),
                        CustomRoundedInputField(
                          title: "Password",
                          label: "Create your 8-digit password",
                          showLabel: true,
                          isRequired: true,
                          useCustomValidator: true,
                          obscureText:
                          signUpController.signUpPasswordVisibility,
                          hasTitle: true,
                          controller: signUpController.passwordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              signUpController.togglePasswordVisibility();
                            },
                            icon: Icon(
                              signUpController.signUpPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                              return 'Password must contain at least one letter and one number';
                            }
                            return null;
                          },

                        ),
                        CustomRoundedInputField(
                          title: "Confirm Password",
                          label: "Retype your 8-digit password",
                          showLabel: true,
                          isRequired: true,
                          useCustomValidator: true,
                          obscureText:
                          signUpController.signUpConfirmPasswordVisibility,
                          hasTitle: true,
                          controller: signUpController.cPasswordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              signUpController
                                  .toggleConfirmPasswordVisibility();
                            },
                            icon: Icon(
                              signUpController.signUpConfirmPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != signUpController.passwordController.text) {
                              return 'Passwords do not match';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        CustomButton(
                          onPressed: () {
                            // Validate the form before proceeding
                            if (signUpController.signUpFormKey.currentState!.validate()) {
                              // Additional validation for phone number
                              if (signUpController.filledPhoneNumber == null ||
                                  signUpController.phoneNumberController.text.isEmpty) {
                                showToast(
                                  message: "Please enter a valid phone number",
                                  isError: true,
                                );
                                return;
                              }

                              // All validations passed, proceed to business info screen
                              Get.toNamed(Routes.BUSINESS_INFO_ENTRY_SCREEN);
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
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText("You have an account?",
                                color: AppColors.obscureTextColor,
                                fontSize: 15.sp),
                            SizedBox(
                              width: 12.w,
                            ),
                            InkWell(
                              onTap: () {
                                Get.offAndToNamed(Routes.SIGN_IN);
                              },
                              child: customText("Login",
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}