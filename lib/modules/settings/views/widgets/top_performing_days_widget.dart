import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/models/restaurant_analytics_model.dart';
import 'package:intl/intl.dart';

class TopPerformingDaysWidget extends StatelessWidget {
  final List<TopPerformingDay> topDays;

  const TopPerformingDaysWidget({
    super.key,
    required this.topDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withValues(alpha: 0.2),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: topDays.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppColors.greyColor.withValues(alpha: 0.2),
        ),
        itemBuilder: (context, index) {
          final day = topDays[index];
          return _buildDayItem(day, index + 1);
        },
      ),
    );
  }

  Widget _buildDayItem(TopPerformingDay day, int rank) {
    final dateFormat = DateFormat('EEE, MMM d');
    final formattedDate = dateFormat.format(day.dateTime);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: _getRankColor(rank).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: customText(
                '$rank',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: _getRankColor(rank),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Date and Day Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  day.dayName,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 4.h),
                customText(
                  formattedDate,
                  fontSize: 12.sp,
                  color: AppColors.greyColor,
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Orders and Revenue
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_outlined,
                    size: 14.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 4.w),
                  customText(
                    '${day.orders} orders',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              customText(
                '₦${day.revenue.toStringAsFixed(2)}',
                fontSize: 12.sp,
                color: AppColors.greenColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.primaryColor;
      case 2:
        return AppColors.orangeColor;
      case 3:
        return AppColors.purpleColor;
      default:
        return AppColors.greyColor;
    }
  }
}
