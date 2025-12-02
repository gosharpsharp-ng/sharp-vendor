import 'dart:io';

import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/utils/widgets/stats_container.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';
import 'package:upgrader/upgrader.dart';

final List<ChartData> usageData = [
  ChartData('Mon', 120),
  ChartData('Tue', 150),
  ChartData('Wed', 100),
  ChartData('Thu', 180),
  ChartData('Fri', 200),
  ChartData('Sat', 160),
  ChartData('Sun', 140),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return UpgradeAlert(
          barrierDismissible: false,
          showIgnore: false,
          showLater: false,
          showReleaseNotes: true,
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          upgrader: Upgrader(
            messages: UpgraderMessages(code: "Kindly update your app"),
          ),
          child: Scaffold(
            appBar: flatAppBar(
              bgColor: AppColors.backgroundColor,
              navigationColor: AppColors.backgroundColor,
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(55.sp),
                child: Container(
                  width: 1.sw,
                  color: AppColors.backgroundColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 0.h,
                    horizontal: 10.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<SettingsController>(
                        init: SettingsController(),
                        builder: (settingsController) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.sp),
                            color: AppColors.transparent,
                            child: Row(
                              children: [
                                Visibility(
                                  visible:
                                      settingsController
                                          .userProfile
                                          ?.avatarUrl !=
                                      null,
                                  replacement: CircleAvatar(
                                    radius: 22.r,
                                    backgroundColor: AppColors.backgroundColor,
                                    child: customText(
                                      // "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                      "Ab",
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      settingsController
                                              .userProfile
                                              ?.avatarUrl ??
                                          '',
                                    ),
                                    radius: 22.r,
                                  ),
                                ),
                                SizedBox(width: 8.sp),
                                customText(
                                  "Hi ${settingsController.userProfile?.fname ?? ''}",
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      GetBuilder<SettingsController>(
                        builder: (settingsController) {
                          return Row(
                            children: [
                              InkWell(
                                splashColor: AppColors.transparent,
                                highlightColor: AppColors.transparent,
                                onTap: () {
                                  Get.toNamed(Routes.NOTIFICATIONS_HOME);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.sp,
                                  ),
                                  child: Badge(
                                    textColor: AppColors.whiteColor,
                                    backgroundColor: AppColors.redColor,
                                    isLabelVisible: true,
                                    label: customText(
                                      settingsController.isLoadingNotification
                                          ? ''
                                          : settingsController
                                                    .notifications
                                                    .length >
                                                10
                                          ? '10+'
                                          : settingsController
                                                .notifications
                                                .length
                                                .toString(),
                                      fontSize: 12.sp,
                                    ),
                                    child: SvgPicture.asset(
                                      SvgAssets.notificationIcon,
                                      color: AppColors.obscureTextColor,
                                      height: 20.sp,
                                      width: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              body: RefreshIndicator(
                backgroundColor: AppColors.primaryColor,
                color: AppColors.whiteColor,
                onRefresh: () async {
                  await dashboardController.refreshDashboard();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.sp,
                    horizontal: 10.sp,
                  ),
                  color: AppColors.backgroundColor,
                  child: RefreshIndicator(
                    backgroundColor: AppColors.primaryColor,
                    onRefresh: () async {
                      // ordersController.fetchDeliveries();
                      // Get.find<WalletController>().getWalletBalance();
                      // Get.find<WalletController>().getTransactions();
                      // Get.find<SettingsController>().getProfile();
                      // Get.find<NotificationsController>().getNotifications();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 12.sp,
                              horizontal: 10.sp,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        "Wallet Balance",
                                        color: AppColors.greyColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                      SizedBox(height: 8.sp),
                                      customText(
                                        dashboardController.walletBalance,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                CustomButton(
                                  width: 100.w,
                                  height: 40.h,
                                  borderRadius: 8.r,
                                  onPressed: () {
                                    Get.toNamed(Routes.PAYOUT_REQUEST_SCREEN);
                                  },
                                  title: "Withdraw",
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            width: 1.sw,
                            child: customText(
                              "Basic summary",
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                              color: AppColors.blackColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: StatsContainer(
                                  onPressed: () =>
                                      Get.toNamed(Routes.ORDERS_HOME_SCREEN),
                                  backgroundColor: AppColors.lightOrangeColor,
                                  textColor: AppColors.orangeColor,
                                  title: "New Orders",
                                  value: "${dashboardController.newOrders}",
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: StatsContainer(
                                  onPressed: () =>
                                      Get.toNamed(Routes.ORDERS_HOME_SCREEN),
                                  backgroundColor: AppColors.lightPurpleColor,
                                  textColor: AppColors.purpleColor,
                                  title: "Completed Orders",
                                  value:
                                      "${dashboardController.completedOrders}",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 35.h),

                          // AreaChartWidget(
                          //   chartData: dashboardController.dashboardChartData,
                          // ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
