import 'package:sharpvendor/core/utils/exports.dart';
import 'widgets/payout_item.dart';

class PayoutHistoryScreen extends StatelessWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayoutController>(
      builder: (payoutController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Payout History",
            implyLeading: true,
            centerTitle: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            onRefresh: () async {
              payoutController.refreshData();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: Column(
                children: [
                  // Stats Card
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(16.sp),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Available Balance",
                                    fontSize: 12.sp,
                                    color: AppColors.greyColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 4.h),
                                  customText(
                                    formatToCurrency(
                                      payoutController.availableBalance,
                                    ),
                                    fontSize: 18.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: customText(
                                "Total: ${payoutController.totalPayouts}",
                                fontSize: 12.sp,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Payout List
                  Expanded(
                    child: Visibility(
                      visible: payoutController.payoutRequests.isNotEmpty,
                      replacement: Visibility(
                        visible:
                            !payoutController.fetchingPayouts &&
                            payoutController.payoutRequests.isEmpty,
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 64.sp,
                              color: AppColors.greyColor.withOpacity(0.5),
                            ),
                            SizedBox(height: 16.h),
                            customText(
                              "No payout requests yet",
                              fontSize: 16.sp,
                              color: AppColors.greyColor,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 8.h),
                            customText(
                              "Your payout history will appear here",
                              fontSize: 14.sp,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(height: 24.h),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.PAYOUT_REQUEST_SCREEN);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: customText(
                                  "Request Payout",
                                  fontSize: 14.sp,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2.sp,
                              ),
                              SizedBox(height: 16.h),
                              customText(
                                "Loading payout history...",
                                fontSize: 14.sp,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller:
                            payoutController.payoutHistoryScrollController,
                        child: Column(
                          children: [
                            ...List.generate(
                              payoutController.payoutRequests.length,
                              (i) => PayoutItem(
                                onTap: () {
                                  payoutController.setSelectedPayoutRequest(
                                    payoutController.payoutRequests[i],
                                  );
                                  Get.toNamed(Routes.PAYOUT_DETAILS_SCREEN);
                                },
                                payoutRequest:
                                    payoutController.payoutRequests[i],
                              ),
                            ),
                            Visibility(
                              visible:
                                  payoutController.fetchingPayouts &&
                                  payoutController.payoutRequests.isNotEmpty,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16.w,
                                        height: 16.h,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                          strokeWidth: 2.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      customText(
                                        "Loading more...",
                                        color: AppColors.primaryColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  payoutController.payoutRequests.length >=
                                      payoutController.totalPayouts &&
                                  payoutController.totalPayouts > 0,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: customText(
                                    "No more payouts to load",
                                    color: AppColors.greyColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: payoutController.payoutRequests.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () {
                    Get.toNamed(Routes.PAYOUT_REQUEST_SCREEN);
                  },
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(
                    Icons.add,
                    color: AppColors.whiteColor,
                    size: 24.sp,
                  ),
                )
              : null,
        );
      },
    );
  }
}
