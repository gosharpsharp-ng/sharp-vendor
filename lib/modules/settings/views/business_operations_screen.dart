import 'package:sharpvendor/core/utils/exports.dart';

class BusinessOperationsScreen extends StatelessWidget {
  const BusinessOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        return Form(
          key: settingsController.businessOperationsFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () {
                Get.back();
              },
              title: "Business Operations",
            ),
            backgroundColor: AppColors.backgroundColor,
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              child: CustomButton(
                onPressed: () {
                  settingsController.updateBusinessOperations();
                },
                isBusy: settingsController.isLoading,
                title: "Update Operations",
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 25.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Operating Days & Hours",
                      color: AppColors.blackColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 8.h),
                    customText(
                      "Select your operating days and set individual hours for each day",
                      color: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 20.h),

                    // Monday
                    OpeningDayWidget(
                      day: "Monday",
                      isSelected: settingsController.selectedDays['monday']!,
                      onTap: () => settingsController.toggleDaySelection('monday'),
                    ),
                    if (settingsController.selectedDays['monday']!)
                      _buildTimeSelectionRow(settingsController, 'monday'),

                    // Tuesday
                    OpeningDayWidget(
                      day: "Tuesday",
                      isSelected: settingsController.selectedDays['tuesday']!,
                      onTap: () => settingsController.toggleDaySelection('tuesday'),
                    ),
                    if (settingsController.selectedDays['tuesday']!)
                      _buildTimeSelectionRow(settingsController, 'tuesday'),

                    // Wednesday
                    OpeningDayWidget(
                      day: "Wednesday",
                      isSelected: settingsController.selectedDays['wednesday']!,
                      onTap: () => settingsController.toggleDaySelection('wednesday'),
                    ),
                    if (settingsController.selectedDays['wednesday']!)
                      _buildTimeSelectionRow(settingsController, 'wednesday'),

                    // Thursday
                    OpeningDayWidget(
                      day: "Thursday",
                      isSelected: settingsController.selectedDays['thursday']!,
                      onTap: () => settingsController.toggleDaySelection('thursday'),
                    ),
                    if (settingsController.selectedDays['thursday']!)
                      _buildTimeSelectionRow(settingsController, 'thursday'),

                    // Friday
                    OpeningDayWidget(
                      day: "Friday",
                      isSelected: settingsController.selectedDays['friday']!,
                      onTap: () => settingsController.toggleDaySelection('friday'),
                    ),
                    if (settingsController.selectedDays['friday']!)
                      _buildTimeSelectionRow(settingsController, 'friday'),

                    // Saturday
                    OpeningDayWidget(
                      day: "Saturday",
                      isSelected: settingsController.selectedDays['saturday']!,
                      onTap: () => settingsController.toggleDaySelection('saturday'),
                    ),
                    if (settingsController.selectedDays['saturday']!)
                      _buildTimeSelectionRow(settingsController, 'saturday'),

                    // Sunday
                    OpeningDayWidget(
                      day: "Sunday",
                      isSelected: settingsController.selectedDays['sunday']!,
                      onTap: () => settingsController.toggleDaySelection('sunday'),
                    ),
                    if (settingsController.selectedDays['sunday']!)
                      _buildTimeSelectionRow(settingsController, 'sunday'),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeSelectionRow(SettingsController controller, String day) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 15.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ClickableCustomRoundedInputField(
              onPressed: () async {
                await controller.selectTimeForDay(day: day, isOpeningTime: true);
              },
              title: "Opening Time",
              label: controller.dayOperatingHours[day]?['openTime'] ?? "Select Time",
              showLabel: true,
              readOnly: true,
              isRequired: true,
              hasTitle: true,
              controller: TextEditingController(
                text: controller.dayOperatingHours[day]?['openTime'] ?? "",
              ),
              suffixWidget: IconButton(
                onPressed: () async {
                  await controller.selectTimeForDay(day: day, isOpeningTime: true);
                },
                icon: SvgPicture.asset(
                  SvgAssets.timeIcon,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: ClickableCustomRoundedInputField(
              onPressed: () async {
                await controller.selectTimeForDay(day: day, isOpeningTime: false);
              },
              title: "Closing Time",
              label: controller.dayOperatingHours[day]?['closeTime'] ?? "Select Time",
              showLabel: true,
              isRequired: true,
              hasTitle: true,
              readOnly: true,
              controller: TextEditingController(
                text: controller.dayOperatingHours[day]?['closeTime'] ?? "",
              ),
              suffixWidget: IconButton(
                onPressed: () async {
                  await controller.selectTimeForDay(day: day, isOpeningTime: false);
                },
                icon: SvgPicture.asset(
                  SvgAssets.timeIcon,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OpeningDayWidget extends StatelessWidget {
  final bool isSelected;
  final String day;
  final VoidCallback? onTap;

  const OpeningDayWidget({
    super.key,
    this.isSelected = false,
    required this.day,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
            width: isSelected ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(8.r),
          color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : AppColors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              day,
              fontSize: 15.sp,
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
                    : SizedBox.shrink(),
              ),
            )
          ],
        ),
      ),
    );
  }
}