import 'package:sharpvendor/modules/signup/views/widgets/bank_selection_bottom_sheet.dart' show BankSelectionBottomSheet;

import '../../../core/utils/exports.dart';

class BankInfoEntryScreen extends StatelessWidget {
  const BankInfoEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (walletController) {
        return Form(
          key: walletController.payoutAccountFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Bank Account",
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 30.sp),
              child:  CustomButton(
                onPressed: () {
                  // signUpController.signUp();
                  Get.toNamed(Routes.APP_NAVIGATION);
                },
                isBusy: walletController.isLoading,
                title: "Submit",
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
                    customText(
                        "Please fill in your bank details",
                        color: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal),
                    SizedBox(height: 15.h,),
                    ClickableCustomRoundedInputField(
                      title: "Select bank",
                      label: "Select",
                      readOnly: true,
                      showLabel: true,
                      hasTitle: true,
                      controller: walletController.bankNameController,
                      onPressed: () {
                        if (walletController.originalBanks.isEmpty) {
                          walletController.getBankList();
                        }
                        showAnyBottomSheet(
                          child: BankSelectionBottomSheet(
                            onBankSelected: (BankModel selectedBank) {
                              walletController.setSelectedBank(
                                selectedBank,
                              );
                            },
                          ),
                        );
                      },
                      suffixWidget: IconButton(
                        onPressed: () {
                          if (walletController.originalBanks.isEmpty) {
                            walletController.getBankList();
                          }
                          showAnyBottomSheet(
                            child: BankSelectionBottomSheet(
                              onBankSelected: (BankModel selectedBank) {
                                walletController.setSelectedBank(
                                  selectedBank,
                                );
                              },
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          SvgAssets.downChevronIcon,
                          // h: 20.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      // controller: signInProvider.emailController,
                    ),
                    SizedBox(height: 10.sp),
                    CustomRoundedInputField(
                      title: "Account number",
                      label: "77335521",
                      showLabel: true,
                      hasTitle: true,
                      useCustomValidator: true,
                      keyboardType: TextInputType.number,
                      controller:
                          walletController.accountNumberController,
                      onChanged: (value) {
                        if (RegExp(r'^\d{10}$').hasMatch(value)) {
                          walletController.verifyPayoutBank();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Value is required';
                        }

                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'The value must be exactly 10 digits';
                        }
                        return null; // Return null if validation passes
                      },
                    ),
                    SizedBox(height: 10.sp),
                    CustomRoundedInputField(
                      title: "Account name",
                      label: "Dennis Mathew",
                      showLabel: true,
                      readOnly: true,
                      hasTitle: true,
                      isRequired: true,
                      controller:
                          walletController.resolvedBankAccountName,
                      // controller: signInProvider.passwordController,
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
