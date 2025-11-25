import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/settings/controllers/analytics_controller.dart' show AnalyticsController, DateFilterOption;

class DateFilterDropdown extends StatelessWidget {
  const DateFilterDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnalyticsController>(
      builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.greyColor.withOpacity(0.3),
            ),
          ),
          child: DropdownButton<DateFilterOption>(
            value: controller.selectedFilter,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.blackColor,
              size: 20.sp,
            ),
            items: [
              DropdownMenuItem(
                value: DateFilterOption.today,
                child: _buildFilterItem('Today'),
              ),
              DropdownMenuItem(
                value: DateFilterOption.yesterday,
                child: _buildFilterItem('Yesterday'),
              ),
              DropdownMenuItem(
                value: DateFilterOption.last7Days,
                child: _buildFilterItem('Last 7 Days'),
              ),
              DropdownMenuItem(
                value: DateFilterOption.last30Days,
                child: _buildFilterItem('Last 30 Days'),
              ),
              DropdownMenuItem(
                value: DateFilterOption.thisMonth,
                child: _buildFilterItem('This Month'),
              ),
              DropdownMenuItem(
                value: DateFilterOption.lastMonth,
                child: _buildFilterItem('Last Month'),
              ),
              DropdownMenuItem(
                value: DateFilterOption.custom,
                child: _buildFilterItem('Custom Range'),
              ),
            ],
            onChanged: (DateFilterOption? value) async {
              if (value != null) {
                if (value == DateFilterOption.custom) {
                  await _showCustomDatePicker(context, controller);
                } else {
                  await controller.changeFilter(value);
                }
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterItem(String text) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16.sp,
          color: AppColors.primaryColor,
        ),
        SizedBox(width: 8.w),
        customText(
          text,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
      ],
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
