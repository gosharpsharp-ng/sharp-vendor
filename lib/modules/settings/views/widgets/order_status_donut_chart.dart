import 'package:fl_chart/fl_chart.dart';
import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/models/restaurant_analytics_model.dart';

class OrderStatusDonutChart extends StatelessWidget {
  final OrderStatusBreakdown orderStatus;

  const OrderStatusDonutChart({
    super.key,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
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
        children: [
          // Donut Chart
          SizedBox(
            height: 200.h,
            child: orderStatus.total > 0
                ? PieChart(
                    PieChartData(
                      sections: _getSections(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 60.r,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                      ),
                    ),
                  )
                : Center(
                    child: customText(
                      "No orders yet",
                      fontSize: 14.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
          ),

          SizedBox(height: 20.h),

          // Legend
          Wrap(
            spacing: 16.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.center,
            children: [
              if (orderStatus.completed > 0)
                _buildLegendItem(
                  color: AppColors.greenColor,
                  label: "Completed",
                  count: orderStatus.completed,
                  percentage: orderStatus.completionPercentage,
                ),
              if (orderStatus.pending > 0)
                _buildLegendItem(
                  color: AppColors.orangeColor,
                  label: "Pending",
                  count: orderStatus.pending,
                  percentage: (orderStatus.pending / orderStatus.total) * 100,
                ),
              if (orderStatus.cancelled > 0)
                _buildLegendItem(
                  color: AppColors.redColor,
                  label: "Cancelled",
                  count: orderStatus.cancelled,
                  percentage: orderStatus.cancellationPercentage,
                ),
              if (orderStatus.preparing > 0)
                _buildLegendItem(
                  color: AppColors.purpleColor,
                  label: "Preparing",
                  count: orderStatus.preparing,
                  percentage: (orderStatus.preparing / orderStatus.total) * 100,
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final sections = <PieChartSectionData>[];

    if (orderStatus.completed > 0) {
      sections.add(
        PieChartSectionData(
          color: AppColors.greenColor,
          value: orderStatus.completed.toDouble(),
          title: '${orderStatus.completionPercentage.toStringAsFixed(0)}%',
          radius: 50.r,
          titleStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      );
    }

    if (orderStatus.pending > 0) {
      sections.add(
        PieChartSectionData(
          color: AppColors.orangeColor,
          value: orderStatus.pending.toDouble(),
          title:
              '${((orderStatus.pending / orderStatus.total) * 100).toStringAsFixed(0)}%',
          radius: 50.r,
          titleStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      );
    }

    if (orderStatus.cancelled > 0) {
      sections.add(
        PieChartSectionData(
          color: AppColors.redColor,
          value: orderStatus.cancelled.toDouble(),
          title: '${orderStatus.cancellationPercentage.toStringAsFixed(0)}%',
          radius: 50.r,
          titleStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      );
    }

    if (orderStatus.preparing > 0) {
      sections.add(
        PieChartSectionData(
          color: AppColors.purpleColor,
          value: orderStatus.preparing.toDouble(),
          title:
              '${((orderStatus.preparing / orderStatus.total) * 100).toStringAsFixed(0)}%',
          radius: 50.r,
          titleStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required int count,
    required double percentage,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        customText(
          '$label ($count)',
          fontSize: 12.sp,
          color: AppColors.blackColor,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
