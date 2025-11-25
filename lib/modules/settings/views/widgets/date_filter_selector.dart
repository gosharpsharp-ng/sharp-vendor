import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/settings/controllers/analytics_controller.dart';

class DateFilterSelector extends StatelessWidget {
  const DateFilterSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnalyticsController>(
      builder: (controller) {
        return InkWell(
          onTap: () => _showFilterBottomSheet(context, controller),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.greyColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18.sp,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 12.w),
                    customText(
                      controller.filterLabel,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    AnalyticsController controller,
  ) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  "Select Date Range",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.greyColor,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            _buildFilterOption(
              context,
              controller,
              DateFilterOption.today,
              'Today',
              Icons.today,
            ),
            _buildFilterOption(
              context,
              controller,
              DateFilterOption.yesterday,
              'Yesterday',
              Icons.history,
            ),
            _buildFilterOption(
              context,
              controller,
              DateFilterOption.last7Days,
              'Last 7 Days',
              Icons.date_range,
            ),
            _buildFilterOption(
              context,
              controller,
              DateFilterOption.last30Days,
              'Last 30 Days',
              Icons.calendar_month,
            ),
            _buildFilterOption(
              context,
              controller,
              DateFilterOption.thisMonth,
              'This Month',
              Icons.calendar_today_outlined,
            ),
            _buildFilterOption(
              context,
              controller,
              DateFilterOption.lastMonth,
              'Last Month',
              Icons.event_note,
            ),
            Divider(height: 1.h),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
              leading: Icon(
                Icons.edit_calendar,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
              title: customText(
                'Custom Range',
                fontSize: 15.sp,
                color: AppColors.blackColor,
              ),
              trailing: controller.selectedFilter == DateFilterOption.custom
                  ? Icon(
                      Icons.check_circle,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    )
                  : null,
              onTap: () {
                Get.back();
                _showCustomDatePicker(context, controller);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    AnalyticsController controller,
    DateFilterOption option,
    String label,
    IconData icon,
  ) {
    final isSelected = controller.selectedFilter == option;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
        size: 24.sp,
      ),
      title: customText(
        label,
        fontSize: 15.sp,
        color: isSelected ? AppColors.primaryColor : AppColors.blackColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: AppColors.primaryColor,
              size: 24.sp,
            )
          : null,
      onTap: () async {
        Get.back();
        await controller.changeFilter(option);
      },
    );
  }

  Future<void> _showCustomDatePicker(
    BuildContext context,
    AnalyticsController controller,
  ) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: controller.customStartDate != null &&
              controller.customEndDate != null
          ? DateTimeRange(
              start: controller.customStartDate!,
              end: controller.customEndDate!,
            )
          : DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 6)),
              end: DateTime.now(),
            ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await controller.setCustomDateRange(picked.start, picked.end);
    }
  }
}
