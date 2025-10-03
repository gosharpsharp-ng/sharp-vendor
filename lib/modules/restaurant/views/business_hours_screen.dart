import 'package:sharpvendor/core/utils/exports.dart';
import '../controllers/restaurant_details_controller.dart';

class BusinessHoursScreen extends GetView<RestaurantDetailsController> {
  const BusinessHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailsController>(
      builder: (restaurantController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () => Get.back(),
            title: "Business Hours",
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            child: CustomButton(
              onPressed: () {
                // TODO: Implement business hours update
                showToast(message: "Business hours update coming soon", isError: false);
              },
              isBusy: restaurantController.isUpdating,
              title: "Update Business Hours",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 25.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  "Business Operating Hours",
                  color: AppColors.blackColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                customText(
                  "Set your restaurant's operating hours for each day of the week",
                  color: AppColors.greyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: 30.h),

                // Current Schedule Overview
                if (restaurantController.restaurant?.schedules.isNotEmpty ?? false) ...[
                  Container(
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
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: AppColors.primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            customText(
                              "Current Schedule",
                              color: AppColors.blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        ...restaurantController.restaurant!.schedules.map((schedule) {
                          String day = schedule.dayOfWeek.substring(0, 1).toUpperCase() +
                                      schedule.dayOfWeek.substring(1);
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customText(
                                  day,
                                  color: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                customText(
                                  schedule.timeRange,
                                  color: AppColors.greyColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],

                // Days of the Week Configuration
                ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) {
                  bool isSelected = _isDaySelected(restaurantController, day.toLowerCase());
                  String openTime = _getOpenTime(restaurantController, day.toLowerCase());
                  String closeTime = _getCloseTime(restaurantController, day.toLowerCase());

                  return Column(
                    children: [
                      // Day Selection
                      GestureDetector(
                        onTap: () {
                          // TODO: Toggle day selection
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
                              width: isSelected ? 1.5 : 0.5,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : AppColors.whiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                day,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primaryColor : AppColors.blackColor,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryColor : AppColors.transparent,
                                  border: Border.all(
                                    width: 1,
                                    color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                height: 20.sp,
                                width: 20.sp,
                                child: Center(
                                  child: isSelected
                                      ? Icon(Icons.check, size: 14.sp, color: AppColors.whiteColor)
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Time Selection (if day is selected)
                      if (isSelected) ...[
                        Container(
                          margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 15.h),
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClickableCustomRoundedInputField(
                                  onPressed: () async {
                                    // TODO: Show time picker for opening time
                                    showToast(message: "Time picker coming soon", isError: false);
                                  },
                                  title: "Opening Time",
                                  label: openTime.isNotEmpty ? openTime : "Select Time",
                                  showLabel: true,
                                  readOnly: true,
                                  isRequired: true,
                                  hasTitle: true,
                                  controller: TextEditingController(text: openTime),
                                  suffixWidget: IconButton(
                                    onPressed: () async {
                                      // TODO: Show time picker for opening time
                                    },
                                    icon: Icon(
                                      Icons.access_time,
                                      color: AppColors.primaryColor,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: ClickableCustomRoundedInputField(
                                  onPressed: () async {
                                    // TODO: Show time picker for closing time
                                    showToast(message: "Time picker coming soon", isError: false);
                                  },
                                  title: "Closing Time",
                                  label: closeTime.isNotEmpty ? closeTime : "Select Time",
                                  showLabel: true,
                                  isRequired: true,
                                  hasTitle: true,
                                  readOnly: true,
                                  controller: TextEditingController(text: closeTime),
                                  suffixWidget: IconButton(
                                    onPressed: () async {
                                      // TODO: Show time picker for closing time
                                    },
                                    icon: Icon(
                                      Icons.access_time,
                                      color: AppColors.primaryColor,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }).toList(),

                SizedBox(height: 30.h),

                // Quick Actions
                Container(
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
                        "Quick Actions",
                        color: AppColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                // TODO: Set weekday hours (Mon-Fri)
                                showToast(message: "Set weekday hours coming soon", isError: false);
                              },
                              title: "Set Weekdays",
                              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                              fontColor: AppColors.primaryColor,
                              fontSize: 12.sp,
                              height: 40.h,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                // TODO: Set weekend hours (Sat-Sun)
                                showToast(message: "Set weekend hours coming soon", isError: false);
                              },
                              title: "Set Weekends",
                              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                              fontColor: AppColors.primaryColor,
                              fontSize: 12.sp,
                              height: 40.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      CustomButton(
                        onPressed: () {
                          // TODO: Copy previous day schedule
                          showToast(message: "Copy schedule coming soon", isError: false);
                        },
                        title: "Copy Previous Day",
                        backgroundColor: AppColors.greyColor.withOpacity(0.1),
                        fontColor: AppColors.blackColor,
                        fontSize: 12.sp,
                        height: 40.h,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Information Card
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: customText(
                          "These hours will be visible to customers and affect when you can receive orders. Make sure to keep them updated for holidays and special events.",
                          color: AppColors.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isDaySelected(RestaurantDetailsController controller, String day) {
    if (controller.restaurant?.schedules.isEmpty ?? true) return false;
    return controller.restaurant!.schedules.any(
      (schedule) => schedule.dayOfWeek.toLowerCase() == day,
    );
  }

  String _getOpenTime(RestaurantDetailsController controller, String day) {
    if (controller.restaurant?.schedules.isEmpty ?? true) return "";
    final schedule = controller.restaurant!.schedules.firstWhereOrNull(
      (schedule) => schedule.dayOfWeek.toLowerCase() == day,
    );
    return schedule?.formattedOpenTime ?? "";
  }

  String _getCloseTime(RestaurantDetailsController controller, String day) {
    if (controller.restaurant?.schedules.isEmpty ?? true) return "";
    final schedule = controller.restaurant!.schedules.firstWhereOrNull(
      (schedule) => schedule.dayOfWeek.toLowerCase() == day,
    );
    return schedule?.formattedCloseTime ?? "";
  }
}