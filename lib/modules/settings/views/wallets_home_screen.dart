import 'package:sharpvendor/core/utils/exports.dart';

class WalletsHomeScreen extends StatelessWidget {
  const WalletsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        final wallet = settingsController.userProfile?.restaurant?.wallet;
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "GoWallet",
            centerTitle: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            onRefresh: () async {
              await settingsController.getProfile();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wallet Balance Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.primaryColor.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            "Available Balance",
                            color: AppColors.whiteColor.withValues(alpha: 0.9),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(height: 8.h),
                          settingsController.isLoading
                              ? SizedBox(
                                  width: 30.w,
                                  height: 30.h,
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : customText(
                                  formatToCurrency(
                                    double.parse(wallet?.balance ?? "0"),
                                  ),
                                  color: AppColors.whiteColor,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                          SizedBox(height: 16.h),
                          // Additional balance info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Bonus",
                                    color: AppColors.whiteColor.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  SizedBox(height: 4.h),
                                  customText(
                                    formatToCurrency(
                                      double.parse(wallet?.bonusBalance ?? "0"),
                                    ),
                                    color: AppColors.whiteColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Quick Actions
                    customText(
                      "Quick Actions",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 12.h),

                    // View Transactions Button
                    InkWell(
                      onTap: () {
                        settingsController.getTransactions();
                        Get.toNamed(Routes.TRANSACTIONS_SCREEN);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.greyColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.history,
                                color: AppColors.primaryColor,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Transaction History",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                  SizedBox(height: 2.h),
                                  customText(
                                    "View all your wallet transactions",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.obscureTextColor,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.obscureTextColor,
                              size: 24.sp,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Fund Wallet Button (Placeholder for future implementation)
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.greyColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                color: AppColors.greenColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.add_circle_outline,
                                color: AppColors.greenColor,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Fund Wallet",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                  SizedBox(height: 2.h),
                                  customText(
                                    "Add money to your wallet",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.obscureTextColor,
                                  ),
                                ],
                              ),
                            ),
                            customText(
                              "Coming Soon",
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.obscureTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Wallet Info
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: customText(
                              "Your GoWallet can be used to receive payments from orders. You can request payouts to your bank account from the Payouts section.",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.visible,
                              color: AppColors.blackColor.withValues(
                                alpha: 0.7,
                              ),
                              height: 1.4,
                            ),
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
      },
    );
  }
}
