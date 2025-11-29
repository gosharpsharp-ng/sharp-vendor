import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/signup/views/widgets/bank_selection_bottom_sheet.dart';
import '../controllers/restaurant_details_controller.dart';

class BankAccountEditScreen extends GetView<RestaurantDetailsController> {
  const BankAccountEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailsController>(
      initState: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final controller = Get.find<RestaurantDetailsController>();
          controller.initializeBankAccountForm();
          if (controller.banks.isEmpty) {
            controller.getBankList();
          }
        });
      },
      builder: (restaurantController) {
        return Form(
          key: restaurantController.bankAccountFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Bank Account",
              onPop: () => Get.back(),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              child: CustomButton(
                onPressed: () {
                  restaurantController.updateBankAccount();
                },
                isBusy: restaurantController.isUpdating,
                title: "Update Bank Account",
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // customText(
                    //   "Bank Account Details",
                    //   color: AppColors.blackColor,
                    //   fontSize: 18.sp,
                    //   fontWeight: FontWeight.w600,
                    // ),
                    SizedBox(height: 5.h),
                    customText(
                      "Please fill in your bank details for receiving payouts",
                      color: AppColors.blackColor,
                      fontSize: 14.sp,
                      overflow: TextOverflow.visible,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(height: 10.h),

                    // Bank Selection
                    ClickableCustomRoundedInputField(
                      title: "Select bank",
                      label: "Select",
                      readOnly: true,
                      showLabel: true,
                      hasTitle: true,
                      isRequired: true,
                      controller: restaurantController.bankNameController,
                      onPressed: () {
                        if (restaurantController.banks.isEmpty) {
                          restaurantController.getBankList();
                        }
                        showAnyBottomSheet(
                          child: BankSelectionBottomSheet(
                            onBankSelected: (BankModel selectedBank) {
                              restaurantController.setSelectedBank(
                                selectedBank,
                              );
                            },
                          ),
                        );
                      },
                      suffixWidget: IconButton(
                        onPressed: () {
                          if (restaurantController.banks.isEmpty) {
                            restaurantController.getBankList();
                          }
                          showAnyBottomSheet(
                            child: BankSelectionBottomSheet(
                              onBankSelected: (BankModel selectedBank) {
                                restaurantController.setSelectedBank(
                                  selectedBank,
                                );
                              },
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          SvgAssets.downChevronIcon,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.sp),

                    // Account Number
                    CustomRoundedInputField(
                      title: "Account number",
                      label: "0123456789",
                      showLabel: true,
                      hasTitle: true,
                      isRequired: true,
                      useCustomValidator: true,
                      keyboardType: TextInputType.number,
                      controller: restaurantController.accountNumberController,
                      onChanged: (value) {
                        // Automatically verify when 10 digits are entered
                        if (RegExp(r'^\d{10}$').hasMatch(value)) {
                          restaurantController.verifyBankAccount();
                        } else {
                          // Clear account name if number is modified
                          if (restaurantController
                              .accountNameController
                              .text
                              .isNotEmpty) {
                            restaurantController.accountNameController.clear();
                            restaurantController.update();
                          }
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Account number is required';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Account number must be exactly 10 digits';
                        }
                        return null;
                      },
                      suffixWidget: restaurantController.isVerifyingAccount
                          ? Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            )
                          : restaurantController
                                .accountNameController
                                .text
                                .isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check_circle,
                                color: AppColors.greenColor,
                                size: 20.sp,
                              ),
                            )
                          : null,
                    ),

                    // Verification Status Banner
                    if (restaurantController.isVerifyingAccount)
                      Container(
                        margin: EdgeInsets.only(top: 12.h),
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16.sp,
                              height: 16.sp,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: customText(
                                "Verifying account details...",
                                color: AppColors.primaryColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 8.sp),

                    // Account Name (Auto-filled after verification)
                    CustomRoundedInputField(
                      title: "Account name",
                      label: "Account holder name",
                      showLabel: true,
                      readOnly: true,
                      hasTitle: true,
                      isRequired: true,
                      controller: restaurantController.accountNameController,
                      suffixWidget:
                          restaurantController
                              .accountNameController
                              .text
                              .isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check_circle,
                                color: AppColors.greenColor,
                                size: 20.sp,
                              ),
                            )
                          : null,
                    ),

                    SizedBox(height: 20.h),

                    // Info Card
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: customText(
                              "We'll automatically verify your account details when you enter a 10-digit account number. Make sure the account belongs to your business.",
                              color: AppColors.primaryColor,
                              fontSize: 11.sp,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.h),
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
