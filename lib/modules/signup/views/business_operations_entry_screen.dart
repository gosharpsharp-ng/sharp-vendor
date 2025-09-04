import 'package:sharpvendor/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class BusinessOperationsEntryScreen extends GetView<SignUpController> {
  const BusinessOperationsEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (signUpController) {
        return Form(
          key: signUpController.businessOpsFormKey,
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
                  signUpController.submitBusinessOperations();
                },
                isBusy: signUpController.isLoading,
                title: "Continue",
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
                      isSelected: signUpController.selectedDays['monday']!,
                      onTap: () => signUpController.toggleDaySelection('monday'),
                    ),
                    if (signUpController.selectedDays['monday']!)
                      _buildTimeSelectionRow(signUpController, 'monday'),

                    // Tuesday
                    OpeningDayWidget(
                      day: "Tuesday",
                      isSelected: signUpController.selectedDays['tuesday']!,
                      onTap: () => signUpController.toggleDaySelection('tuesday'),
                    ),
                    if (signUpController.selectedDays['tuesday']!)
                      _buildTimeSelectionRow(signUpController, 'tuesday'),

                    // Wednesday
                    OpeningDayWidget(
                      day: "Wednesday",
                      isSelected: signUpController.selectedDays['wednesday']!,
                      onTap: () => signUpController.toggleDaySelection('wednesday'),
                    ),
                    if (signUpController.selectedDays['wednesday']!)
                      _buildTimeSelectionRow(signUpController, 'wednesday'),

                    // Thursday
                    OpeningDayWidget(
                      day: "Thursday",
                      isSelected: signUpController.selectedDays['thursday']!,
                      onTap: () => signUpController.toggleDaySelection('thursday'),
                    ),
                    if (signUpController.selectedDays['thursday']!)
                      _buildTimeSelectionRow(signUpController, 'thursday'),

                    // Friday
                    OpeningDayWidget(
                      day: "Friday",
                      isSelected: signUpController.selectedDays['friday']!,
                      onTap: () => signUpController.toggleDaySelection('friday'),
                    ),
                    if (signUpController.selectedDays['friday']!)
                      _buildTimeSelectionRow(signUpController, 'friday'),

                    // Saturday
                    OpeningDayWidget(
                      day: "Saturday",
                      isSelected: signUpController.selectedDays['saturday']!,
                      onTap: () => signUpController.toggleDaySelection('saturday'),
                    ),
                    if (signUpController.selectedDays['saturday']!)
                      _buildTimeSelectionRow(signUpController, 'saturday'),

                    // Sunday
                    OpeningDayWidget(
                      day: "Sunday",
                      isSelected: signUpController.selectedDays['sunday']!,
                      onTap: () => signUpController.toggleDaySelection('sunday'),
                    ),
                    if (signUpController.selectedDays['sunday']!)
                      _buildTimeSelectionRow(signUpController, 'sunday'),

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

  Widget _buildTimeSelectionRow(SignUpController controller, String day) {
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