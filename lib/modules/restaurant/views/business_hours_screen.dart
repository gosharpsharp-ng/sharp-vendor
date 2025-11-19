import 'package:sharpvendor/core/utils/exports.dart';
import '../controllers/restaurant_details_controller.dart';

class BusinessHoursScreen extends GetView<RestaurantDetailsController> {
  const BusinessHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailsController>(
      initState: (_) {
        // Initialize business hours when screen loads
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.find<RestaurantDetailsController>().initializeBusinessHours();
        });
      },
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
              onPressed: () async {
                await restaurantController.updateBusinessHours();
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
                if (restaurantController.restaurant?.schedules.isNotEmpty ??
                    false) ...[
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
                        ...restaurantController.restaurant!.schedules.map((
                          schedule,
                        ) {
                          String day =
                              schedule.dayOfWeek.substring(0, 1).toUpperCase() +
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
                ...[
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday',
                ].map((day) {
                  String dayLower = day.toLowerCase();
                  bool isSelected =
                      restaurantController.selectedDays[dayLower] ?? false;
                  String openTime =
                      restaurantController
                          .dayOperatingHours[dayLower]?['openTime'] ??
                      '';
                  String closeTime =
                      restaurantController
                          .dayOperatingHours[dayLower]?['closeTime'] ??
                      '';

                  return Column(
                    children: [
                      // Day Selection
                      GestureDetector(
                        onTap: () {
                          restaurantController.toggleDaySelection(dayLower);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.greyColor,
                              width: isSelected ? 1.5 : 0.5,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            color: isSelected
                                ? AppColors.primaryColor.withOpacity(0.05)
                                : AppColors.whiteColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                day,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.blackColor,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : AppColors.transparent,
                                  border: Border.all(
                                    width: 1,
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.greyColor,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                height: 20.sp,
                                width: 20.sp,
                                child: Center(
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: 14.sp,
                                          color: AppColors.whiteColor,
                                        )
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
                          margin: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            bottom: 15.h,
                          ),
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
                              Expanded(
                                child: ClickableCustomRoundedInputField(
                                  onPressed: () async {
                                    await restaurantController.selectTimeForDay(
                                      context: context,
                                      day: dayLower,
                                      isOpeningTime: true,
                                    );
                                  },
                                  title: "Opening Time",
                                  label: openTime.isNotEmpty
                                      ? openTime
                                      : "Select Time",
                                  showLabel: true,
                                  readOnly: true,
                                  isRequired: true,
                                  hasTitle: true,
                                  controller: TextEditingController(
                                    text: openTime,
                                  ),
                                  suffixWidget: IconButton(
                                    onPressed: () async {
                                      await restaurantController
                                          .selectTimeForDay(
                                            context: context,
                                            day: dayLower,
                                            isOpeningTime: true,
                                          );
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
                                    await restaurantController.selectTimeForDay(
                                      context: context,
                                      day: dayLower,
                                      isOpeningTime: false,
                                    );
                                  },
                                  title: "Closing Time",
                                  label: closeTime.isNotEmpty
                                      ? closeTime
                                      : "Select Time",
                                  showLabel: true,
                                  isRequired: true,
                                  fontSize: 12.sp,
                                  hasTitle: true,
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: closeTime,
                                  ),
                                  suffixWidget: IconButton(
                                    onPressed: () async {
                                      await restaurantController
                                          .selectTimeForDay(
                                            context: context,
                                            day: dayLower,
                                            isOpeningTime: false,
                                          );
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
                          overflow: TextOverflow.visible
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
}
