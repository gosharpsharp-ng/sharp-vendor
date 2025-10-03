import 'package:sharpvendor/core/utils/exports.dart';

class PayoutRequestScreen extends StatelessWidget {
  const PayoutRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayoutController>(builder: (payoutController) {
      return Form(
        key: payoutController.payoutRequestFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            implyLeading: true,
            bgColor: AppColors.backgroundColor,
            title: "Request Payout",
            centerTitle: false,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SectionBox(
                    backgroundColor: AppColors.whiteColor,
                    children: [
                      SizedBox(height: 15.h),

                      // Available Balance Section
                      Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            customText(
                              "Available Balance",
                              fontSize: 14.sp,
                              color: AppColors.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 4.h),
                            customText(
                              formatToCurrency(payoutController.availableBalance),
                              fontSize: 24.sp,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Amount Input
                      CustomRoundedInputField(
                        title: "Amount",
                        label: "Enter amount to withdraw",
                        showLabel: true,
                        hasTitle: true,
                        controller: payoutController.amountController,
                        keyboardType: TextInputType.number,
                        validator: payoutController.validateAmount,
                        suffixWidget: Icon(
                          Icons.monetization_on_outlined,
                          color: AppColors.greyColor,
                          size: 20.sp,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Payout Limits Info
                      Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: AppColors.amberColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.amberColor,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: customText(
                                "Min: ${formatToCurrency(payoutController.minimumPayoutAmount)} • Max: ${formatToCurrency(payoutController.maximumPayoutAmount)}",
                                fontSize: 12.sp,
                                color: AppColors.amberColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Payment Method Selection
                      Align(
                        alignment: Alignment.centerLeft,
                        child: customText(
                          "Payment Method",
                          fontSize: 14.sp,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      ...payoutController.paymentMethods.map(
                        (method) => GestureDetector(
                          onTap: () => payoutController.setPaymentMethod(method),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: payoutController.selectedPaymentMethod == method
                                    ? AppColors.primaryColor
                                    : AppColors.greyColor.withOpacity(0.3),
                                width: payoutController.selectedPaymentMethod == method ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              color: payoutController.selectedPaymentMethod == method
                                  ? AppColors.primaryColor.withOpacity(0.05)
                                  : AppColors.whiteColor,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  method == 'bank'
                                      ? Icons.account_balance
                                      : Icons.phone_android,
                                  color: payoutController.selectedPaymentMethod == method
                                      ? AppColors.primaryColor
                                      : AppColors.greyColor,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        method == 'bank' ? 'Bank Transfer' : 'Mobile Money',
                                        fontSize: 16.sp,
                                        color: payoutController.selectedPaymentMethod == method
                                            ? AppColors.primaryColor
                                            : AppColors.blackColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(height: 2.h),
                                      customText(
                                        method == 'bank'
                                            ? 'Transfer to your bank account'
                                            : 'Transfer to your mobile money',
                                        fontSize: 12.sp,
                                        color: AppColors.greyColor,
                                      ),
                                    ],
                                  ),
                                ),
                                Radio<String>(
                                  value: method,
                                  groupValue: payoutController.selectedPaymentMethod,
                                  onChanged: (value) {
                                    if (value != null) {
                                      payoutController.setPaymentMethod(value);
                                    }
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Submit Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: CustomButton(
                      onPressed: () {
                        payoutController.submitPayoutRequest();
                      },
                      isBusy: payoutController.isSubmittingRequest,
                      title: "Request Payout",
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),

                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}