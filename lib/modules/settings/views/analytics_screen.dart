
import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/utils/widgets/stats_container.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnalyticsController>(
      builder: (analyticsController) {
        return Scaffold(
          appBar: defaultAppBar(
            title: "Analytics",
            centerTitle: true,
            actionItem: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppColors.blackColor,
                    size: 24.sp,
                  ),
                  onPressed: () => analyticsController.refreshAnalytics(),
                ),
              ],
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: RefreshIndicator(
            onRefresh: () => analyticsController.refreshAnalytics(),
            child: SizedBox(
              width: 1.sw,
              height: 1.sh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    if (analyticsController.isLoading && !analyticsController.hasData)
                      _buildLoadingState()
                    else if (analyticsController.hasError && !analyticsController.hasData)
                      _buildErrorState(analyticsController)
                    else
                      _buildAnalyticsContent(analyticsController),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return SkeletonLoaders.analyticsPage();
  }

  Widget _buildErrorState(AnalyticsController controller) {
    return Column(
      children: [
        SizedBox(height: 100.h),
        Icon(
          Icons.error_outline,
          size: 64.sp,
          color: AppColors.greyColor,
        ),
        SizedBox(height: 16.h),
        customText(
          controller.errorMessage,
          fontSize: 14.sp,
          color: AppColors.greyColor,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        CustomButton(
          onPressed: () => controller.refreshAnalytics(),
          title: "Retry",
          backgroundColor: AppColors.primaryColor,
          fontColor: AppColors.whiteColor,
          width: 120.w,
          height: 40.h,
        ),
      ],
    );
  }

  Widget _buildAnalyticsContent(AnalyticsController controller) {
    final analytics = controller.analytics;

    return Column(
      children: [
        // Orders Statistics Row 1
        Row(
          children: [
            Expanded(
              child: StatsContainer(
                onPressed: () {},
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                title: "Total Orders",
                value: "${analytics?.totalOrders ?? 0}",
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: StatsContainer(
                onPressed: () {},
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                title: "Weekly Orders",
                value: "${analytics?.weeklyOrders ?? 0}",
              ),
            ),
          ],
        ),

        // Orders Statistics Row 2
        Row(
          children: [
            Expanded(
              child: StatsContainer(
                onPressed: () {},
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                title: "Pending Orders",
                value: "${analytics?.pendingOrders ?? 0}",
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: StatsContainer(
                onPressed: () {},
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                title: "New Orders",
                value: "${analytics?.newOrders ?? 0}",
              ),
            ),
          ],
        ),

        // Orders Statistics Row 3
        Row(
          children: [
            Expanded(
              child: StatsContainer(
                onPressed: () {},
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                title: "Completed Orders",
                value: "${analytics?.completedOrders ?? 0}",
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: StatsContainer(
                onPressed: () {},
                backgroundColor: AppColors.whiteColor,
                textColor: AppColors.blackColor,
                title: "Completion Rate",
                value: controller.formattedCompletionRate,
              ),
            ),
          ],
        ),

        SizedBox(height: 35.h),

        // Weekly Overview Section
        SizedBox(
          width: 1.sw,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                "Weekly Overview",
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                color: AppColors.blackColor,
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Show date picker for custom range
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 1.sp,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      customText(
                        controller.weekRangeText,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.blackColor,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        // Chart Section
        if (controller.chartData.isNotEmpty)
          AreaChartWidget(chartData: controller.chartData)
        else
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.greyColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 48.sp,
                  color: AppColors.greyColor,
                ),
                SizedBox(height: 12.h),
                customText(
                  "No data available for this period",
                  fontSize: 14.sp,
                  color: AppColors.greyColor,
                ),
              ],
            ),
          ),

        SizedBox(height: 20.h),

        // Additional insights
        if (analytics != null) _buildInsightsSection(controller),

        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildInsightsSection(AnalyticsController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            "Weekly Insights",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.trending_up,
                size: 16.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: customText(
                  "Peak Day: ${controller.peakDayInfo}",
                  fontSize: 14.sp,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.calculate,
                size: 16.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: customText(
                  "Average daily orders: ${controller.averageDailyOrdersText}",
                  fontSize: 14.sp,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
