import 'package:fl_chart/fl_chart.dart';
import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/dashboard/widgets/area_chart_widget.dart';

class RevenueOrdersChart extends StatelessWidget {
  final List<ChartData> revenueData;
  final List<ChartData> ordersData;

  const RevenueOrdersChart({
    super.key,
    required this.revenueData,
    required this.ordersData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250.h,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                color: AppColors.primaryColor,
                label: "Revenue",
              ),
              SizedBox(width: 20.w),
              _buildLegendItem(
                color: AppColors.orangeColor,
                label: "Orders",
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Chart
          Expanded(
            child: LineChart(
              _buildLineChartData(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
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
          label,
          fontSize: 12.sp,
          color: AppColors.greyColor,
        ),
      ],
    );
  }

  LineChartData _buildLineChartData() {
    final maxRevenue = revenueData.isNotEmpty
        ? revenueData.map((e) => e.value).reduce((a, b) => a > b ? a : b)
        : 100.0;
    final maxOrders = ordersData.isNotEmpty
        ? ordersData.map((e) => e.value).reduce((a, b) => a > b ? a : b)
        : 10.0;

    // Ensure maxRevenue and maxOrders are never zero to avoid chart errors
    final safeMaxRevenue = maxRevenue > 0 ? maxRevenue : 100.0;
    final safeMaxOrders = maxOrders > 0 ? maxOrders : 10.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: safeMaxRevenue / 4,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.greyColor.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              if (value.toInt() >= 0 && value.toInt() < revenueData.length) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: customText(
                    revenueData[value.toInt()].day,
                    fontSize: 10.sp,
                    color: AppColors.greyColor,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 45,
            interval: safeMaxRevenue / 4,
            getTitlesWidget: (double value, TitleMeta meta) {
              return customText(
                _formatCurrency(value),
                fontSize: 10.sp,
                color: AppColors.greyColor,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyColor.withOpacity(0.2),
            width: 1,
          ),
          left: BorderSide(
            color: AppColors.greyColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      minX: 0,
      maxX: (revenueData.length - 1).toDouble(),
      minY: 0,
      maxY: safeMaxRevenue * 1.2,
      lineBarsData: [
        // Revenue line
        LineChartBarData(
          spots: revenueData.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value.value);
          }).toList(),
          isCurved: true,
          color: AppColors.primaryColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.primaryColor,
                strokeWidth: 2,
                strokeColor: AppColors.whiteColor,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primaryColor.withOpacity(0.1),
          ),
        ),
        // Orders line (scaled to fit on same chart)
        LineChartBarData(
          spots: ordersData.asMap().entries.map((entry) {
            // Scale orders to revenue range for visual comparison
            final scaledValue = (entry.value.value / safeMaxOrders) * safeMaxRevenue;
            return FlSpot(entry.key.toDouble(), scaledValue);
          }).toList(),
          isCurved: true,
          color: AppColors.orangeColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.orangeColor,
                strokeWidth: 2,
                strokeColor: AppColors.whiteColor,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => AppColors.blackColor.withValues(alpha: 0.8),
          tooltipBorderRadius: BorderRadius.circular(8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final index = touchedSpot.x.toInt();
              if (index < 0 || index >= revenueData.length) {
                return null;
              }

              final isRevenueLine = touchedSpot.barIndex == 0;
              if (isRevenueLine) {
                return LineTooltipItem(
                  'Revenue\n${_formatCurrency(revenueData[index].value)}',
                  TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                );
              } else {
                return LineTooltipItem(
                  'Orders\n${ordersData[index].value.toInt()}',
                  TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                );
              }
            }).toList();
          },
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000) {
      return '₦${(value / 1000).toStringAsFixed(1)}k';
    }
    return '₦${value.toStringAsFixed(0)}';
  }
}
