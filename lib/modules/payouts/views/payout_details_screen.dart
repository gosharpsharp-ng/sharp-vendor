import 'package:sharpvendor/core/utils/exports.dart';
import 'widgets/payout_detail_summary_item.dart';

class PayoutDetailsScreen extends StatelessWidget {
  const PayoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayoutController>(builder: (payoutController) {
      final payout = payoutController.selectedPayoutRequest;

      if (payout == null) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Payout Details",
            implyLeading: true,
          ),
          body: Center(
            child: customText(
              "No payout selected",
              fontSize: 16.sp,
              color: AppColors.greyColor,
            ),
          ),
        );
      }

      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Payout Details",
          implyLeading: true,
          centerTitle: false,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
          height: 1.sh,
          width: 1.sw,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Main Details Section
                SectionBox(
                  children: [
                    PayoutDetailSummaryItem(
                      title: "Amount",
                      value: formatToCurrency(payout.amountDouble),
                    ),
                    PayoutDetailSummaryItem(
                      title: "Reference",
                      value: payout.ref,
                    ),
                    PayoutDetailSummaryStatusItem(
                      title: "Status",
                      value: payout.statusDisplayText,
                      status: payout.status,
                    ),
                    PayoutDetailSummaryItem(
                      title: "Payment Method",
                      value: payout.paymentMethodDisplayText,
                    ),
                    PayoutDetailSummaryItem(
                      title: "Requested Date",
                      value: "${formatDate(payout.requestedAt)} ${formatTime(payout.requestedAt)}",
                    ),
                    if (payout.processedAt != null)
                      PayoutDetailSummaryItem(
                        title: "Processed Date",
                        value: "${formatDate(payout.processedAt!)} ${formatTime(payout.processedAt!)}",
                      ),
                    if (payout.note != null && payout.note!.isNotEmpty)
                      PayoutDetailSummaryItem(
                        title: "Note",
                        value: payout.note!,
                        isVertical: true,
                      ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Wallet Information
                if (payout.wallet != null)
                  SectionBox(
                    children: [
                      // Section Header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                        child: customText(
                          "Wallet Information",
                          fontSize: 16.sp,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      PayoutDetailSummaryItem(
                        title: "Wallet ID",
                        value: payout.walletId.toString(),
                      ),
                      PayoutDetailSummaryItem(
                        title: "Current Balance",
                        value: payout.wallet!.formattedBalance,
                      ),
                    ],
                  ),

                SizedBox(height: 20.h),

                // Action Buttons
                if (payout.isPending) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: CustomButton(
                      onPressed: () {
                        _showCancelConfirmationDialog(context, payoutController, payout.id);
                      },
                      isBusy: payoutController.isLoading,
                      title: "Cancel Request",
                      width: 1.sw,
                      backgroundColor: AppColors.redColor,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],

                // Refresh Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: InkWell(
                      onTap: () {
                        payoutController.getPayoutRequestDetails(payout.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (payoutController.isLoading) ...[
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ] else
                            Icon(
                              Icons.refresh,
                              color: AppColors.primaryColor,
                              size: 18.sp,
                            ),
                          SizedBox(width: 8.w),
                          customText(
                            "Refresh Status",
                            color: AppColors.primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showCancelConfirmationDialog(BuildContext context, PayoutController controller, int payoutId) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: customText(
          "Cancel Payout Request",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        content: customText(
          "Are you sure you want to cancel this payout request? This action cannot be undone.",
          fontSize: 14.sp,
          color: AppColors.greyColor,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: customText(
              "No, Keep Request",
              fontSize: 14.sp,
              color: AppColors.greyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelPayoutRequest(payoutId);
            },
            child: customText(
              "Yes, Cancel",
              fontSize: 14.sp,
              color: AppColors.redColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}