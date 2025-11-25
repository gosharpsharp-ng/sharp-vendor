
import '../../../core/utils/exports.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartData {
  ChartData(this.day, this.value);
  final String day;
  final double value;
}

class AreaChartWidget extends StatelessWidget {
  final List<ChartData> chartData;

  const AreaChartWidget({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.sp,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          duration: Duration(milliseconds: 1500), // Entry animation duration
          curve: Curves.easeInOutCubic,
          LineChartData(
            // Grid configuration
            gridData: FlGridData(show: false),
            // Border configuration
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(color: AppColors.primaryColor, width: 0.2),
              ),
            ),

            // Touch interaction (equivalent to trackball)
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (LineBarSpot spot) => AppColors.primaryColor,
                tooltipBorderRadius: BorderRadius.circular(8),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                tooltipMargin: 16,
                maxContentWidth: 120,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                tooltipBorder: BorderSide(
                  width: 12.sp,
                  color: AppColors.primaryColor,
                ),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot touchedSpot) {
                    return LineTooltipItem(
                      '${chartData[touchedSpot.spotIndex].value.toInt()}',TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.w600
                     ),
                    );
                  }).toList();
                },
              ),
              getTouchedSpotIndicator: (
                LineChartBarData barData,
                List<int> spotIndexes,
              ) {
                return spotIndexes.map((spotIndex) {
                  return TouchedSpotIndicatorData(
                    FlLine(color: AppColors.primaryColor, strokeWidth: 1),
                    FlDotData(
                      getDotPainter:
                          (spot, percent, barData, index) => FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                  );
                }).toList();
              },
            ),

            // X-axis configuration
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ), // Hide Y axis
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 32,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < chartData.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: customText(
                           chartData[index].day,
                          color: AppColors.greyColor,
                        ),
                      );
                    }
                    return customText('');
                  },
                ),
              ),
            ),

            // Min and max values
            minY: 0,
            maxY: _getMaxValue() * 1.1, // Add some padding at top
            // Line chart data
            lineBarsData: [
              LineChartBarData(
                spots: _generateSpots(),
                isCurved: true, // Smooth curve like spline
                curveSmoothness: 0.35,
                color: AppColors.primaryColor,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter:
                      (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primaryColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withAlpha(120),
                      AppColors.primaryColor.withAlpha(10),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Convert chart data to FlSpot list
  List<FlSpot> _generateSpots() {
    return chartData
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(entry.key.toDouble(), entry.value.value.toDouble()),
        )
        .toList();
  }

  // Get maximum value for Y axis scaling
  double _getMaxValue() {
    if (chartData.isEmpty) return 100;
    final maxValue = chartData
        .map((data) => data.value)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    // Return a minimum value of 10 to ensure chart is visible even with 0 values
    return maxValue > 0 ? maxValue : 10;
  }
}
