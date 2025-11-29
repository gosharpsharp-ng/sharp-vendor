import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/utils/widgets/stats_container.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';
import 'package:sharpvendor/modules/settings/controllers/analytics_controller.dart';
import 'package:sharpvendor/modules/settings/views/widgets/date_filter_selector.dart';
import 'package:sharpvendor/modules/settings/views/widgets/revenue_orders_chart.dart';
import 'package:sharpvendor/modules/settings/views/widgets/order_status_donut_chart.dart';
import 'package:sharpvendor/modules/settings/views/widgets/top_performing_days_widget.dart';

class AnalyticsScreen extends GetView<AnalyticsController> {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnalyticsController>(
      builder: (analyticsController) {
        return Scaffold(
          appBar: defaultAppBar(
            title: "Stats",
            centerTitle: true,
            actionItem: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppColors.blackColor,
                    size: 24.sp,
                  ),
                  onPressed: () => analyticsController.refreshStats(),
                ),
              ],
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => analyticsController.refreshStats(),
                child: SizedBox(
                  width: 1.sw,
                  height: 1.sh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Filter
                        const DateFilterSelector(),

                        SizedBox(height: 20.h),

                        if (analyticsController.isLoading &&
                            !analyticsController.hasData)
                          _buildLoadingState()
                        else if (analyticsController.hasError &&
                            !analyticsController.hasData)
                          _buildErrorState(analyticsController)
                        else
                          _buildStatsContent(analyticsController),
                      ],
                    ),
                  ),
                ),
              ),
              // Loading overlay when filtering with existing data
              if (analyticsController.isLoading && analyticsController.hasData)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: 16.h),
                          customText(
                            'Updating stats...',
                            fontSize: 14.sp,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
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
        Icon(Icons.error_outline, size: 64.sp, color: AppColors.greyColor),
        SizedBox(height: 16.h),
        customText(
          controller.errorMessage,
          fontSize: 14.sp,
          color: AppColors.greyColor,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        CustomButton(
          onPressed: () => controller.refreshStats(),
          title: "Retry",
          backgroundColor: AppColors.primaryColor,
          fontColor: AppColors.whiteColor,
          width: 120.w,
          height: 40.h,
        ),
      ],
    );
  }

  Widget _buildStatsContent(AnalyticsController controller) {
    final stats = controller.stats;
    if (stats == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KPI Cards Row 1 - Revenue & Total Orders
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                title: "Total Revenue",
                value: controller.formattedTotalRevenue,
                change: stats.summary.percentageChanges.revenueChange,
                backgroundColor: AppColors.whiteColor,
                controller: controller,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildKpiCard(
                title: "Total Orders",
                value: "${stats.summary.totalOrders}",
                change: stats.summary.percentageChanges.ordersChange,
                backgroundColor: AppColors.whiteColor,
                controller: controller,
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        // KPI Cards Row 2 - AOV & Completion Rate
        Row(
          children: [
            Expanded(
              child: _buildKpiCard(
                title: "Avg Order Value",
                value: controller.formattedAverageOrderValue,
                change: stats.summary.percentageChanges.aovChange,
                backgroundColor: AppColors.whiteColor,
                controller: controller,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildKpiCard(
                title: "Completion Rate",
                value: controller.formattedCompletionRate,
                change: stats.summary.percentageChanges.completionRateChange,
                backgroundColor: AppColors.whiteColor,
                controller: controller,
              ),
            ),
          ],
        ),

        SizedBox(height: 35.h),

        // Chart Section
        SizedBox(
          width: 1.sw,
          child: customText(
            "Revenue & Orders Trend",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
            color: AppColors.blackColor,
          ),
        ),

        SizedBox(height: 10.h),

        if (controller.dateRangeText.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: customText(
              controller.dateRangeText,
              fontSize: 12.sp,
              color: AppColors.greyColor,
            ),
          ),

        if (controller.revenueChartData.isNotEmpty)
          RevenueOrdersChart(
            revenueData: controller.revenueChartData,
            ordersData: controller.ordersChartData,
          )
        else
          _buildNoDataChart(),

        SizedBox(height: 30.h),

        // Order Status Breakdown
        SizedBox(
          width: 1.sw,
          child: customText(
            "Order Status",
            fontWeight: FontWeight.w500,
            fontSize: 18.sp,
            color: AppColors.blackColor,
          ),
        ),

        SizedBox(height: 15.h),

        OrderStatusDonutChart(orderStatus: stats.orderStatusBreakdown),

        SizedBox(height: 30.h),

        // Top Performing Days
        if (stats.topPerformingDays.isNotEmpty) ...[
          SizedBox(
            width: 1.sw,
            child: customText(
              "Top Performing Days",
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(height: 15.h),
          TopPerformingDaysWidget(topDays: stats.topPerformingDays),
          SizedBox(height: 30.h),
        ],

        // Peak Performance Info
        _buildPeakPerformanceSection(controller),

        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required double change,
    required Color backgroundColor,
    required AnalyticsController controller,
  }) {
    final isPositive = controller.isPositiveChange(change);
    final isNegative = controller.isNegativeChange(change);

    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title,
            fontSize: 12.sp,
            color: AppColors.greyColor,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          customText(
            value,
            fontSize: 20.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(
                isPositive
                    ? Icons.arrow_upward
                    : isNegative
                    ? Icons.arrow_downward
                    : Icons.remove,
                size: 14.sp,
                color: isPositive
                    ? AppColors.greenColor
                    : isNegative
                    ? AppColors.redColor
                    : AppColors.greyColor,
              ),
              SizedBox(width: 4.w),
              customText(
                controller.getPercentageChangeText(change),
                fontSize: 12.sp,
                color: isPositive
                    ? AppColors.greenColor
                    : isNegative
                    ? AppColors.redColor
                    : AppColors.greyColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataChart() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart, size: 48.sp, color: AppColors.greyColor),
          SizedBox(height: 12.h),
          customText(
            "No data available for this period",
            fontSize: 14.sp,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPeakPerformanceSection(AnalyticsController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            "Peak Performance",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: customText(
                  "Best Day: ${controller.bestDayOfWeek}",
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
                Icons.access_time,
                size: 16.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: customText(
                  "Busiest Time: ${controller.bestTimeOfDay}",
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
