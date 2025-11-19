import 'package:sharpvendor/core/utils/exports.dart';

class AddCampaignScreen extends StatelessWidget {
  const AddCampaignScreen({super.key});

  void _showStatusBottomSheet(BuildContext context, CampaignsController controller) {
    showAnyBottomSheet(
      child: Container(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              "Select Status",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 20.h),
            _buildStatusOption(
              title: "Draft",
              subtitle: "Save as draft for later",
              isSelected: controller.selectedStatus == 'draft',
              onTap: () {
                controller.setStatus('draft');
                Get.back();
              },
            ),
            SizedBox(height: 12.h),
            _buildStatusOption(
              title: "Active",
              subtitle: "Campaign will be live immediately",
              isSelected: controller.selectedStatus == 'active',
              onTap: () {
                controller.setStatus('active');
                Get.back();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.greyColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primaryColor : AppColors.blackColor,
                  ),
                  SizedBox(height: 4.h),
                  customText(
                    subtitle,
                    fontSize: 12.sp,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (campaignsController) {
        return Form(
          key: campaignsController.createCampaignFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Create Campaign",
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              height: 1.sh,
              width: 1.sw,
              color: AppColors.backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SectionBox(
                      backgroundColor: AppColors.whiteColor,
                      children: [
                        SizedBox(height: 15.h),

                        // Campaign Name
                        CustomRoundedInputField(
                          title: "Campaign Name",
                          label: "e.g. Summer Promotion",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller: campaignsController.campaignNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a campaign name';
                            }
                            return null;
                          },
                        ),

                        // Start Date
                        ClickableCustomRoundedInputField(
                          title: "Start Date",
                          label: "Select start date",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          readOnly: true,
                          controller: campaignsController.startDateController,
                          suffixWidget: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            child: SvgPicture.asset(
                              SvgAssets.calendarIcon,
                              height: 20.sp,
                              width: 20.sp,
                              colorFilter: ColorFilter.mode(
                                AppColors.obscureTextColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a start date';
                            }
                            return null;
                          },
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
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
                              final TimeOfDay? timePicked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
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
                              if (timePicked != null) {
                                final DateTime fullDateTime = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                  timePicked.hour,
                                  timePicked.minute,
                                );
                                campaignsController.startDateController.text =
                                    "${fullDateTime.year}-${fullDateTime.month.toString().padLeft(2, '0')}-${fullDateTime.day.toString().padLeft(2, '0')} ${fullDateTime.hour.toString().padLeft(2, '0')}:${fullDateTime.minute.toString().padLeft(2, '0')}:00";
                              }
                            }
                          },
                        ),

                        // End Date
                        ClickableCustomRoundedInputField(
                          title: "End Date",
                          label: "Select end date",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          readOnly: true,
                          controller: campaignsController.endDateController,
                          suffixWidget: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            child: SvgPicture.asset(
                              SvgAssets.calendarIcon,
                              height: 20.sp,
                              width: 20.sp,
                              colorFilter: ColorFilter.mode(
                                AppColors.obscureTextColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an end date';
                            }
                            // Validate end date is after start date
                            if (campaignsController.startDateController.text.isNotEmpty) {
                              try {
                                final startDate = DateTime.parse(
                                    campaignsController.startDateController.text);
                                final endDate = DateTime.parse(value);
                                if (endDate.isBefore(startDate)) {
                                  return 'End date must be after start date';
                                }
                              } catch (e) {
                                return 'Invalid date format';
                              }
                            }
                            return null;
                          },
                          onPressed: () async {
                            DateTime initialDate = DateTime.now().add(Duration(days: 7));
                            if (campaignsController.startDateController.text.isNotEmpty) {
                              try {
                                initialDate = DateTime.parse(
                                    campaignsController.startDateController.text)
                                    .add(Duration(days: 1));
                              } catch (e) {
                                // Use default initial date
                              }
                            }

                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
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
                              final TimeOfDay? timePicked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: 23, minute: 59),
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
                              if (timePicked != null) {
                                final DateTime fullDateTime = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                  timePicked.hour,
                                  timePicked.minute,
                                );
                                campaignsController.endDateController.text =
                                    "${fullDateTime.year}-${fullDateTime.month.toString().padLeft(2, '0')}-${fullDateTime.day.toString().padLeft(2, '0')} ${fullDateTime.hour.toString().padLeft(2, '0')}:${fullDateTime.minute.toString().padLeft(2, '0')}:00";
                              }
                            }
                          },
                        ),

                        // Status
                        ClickableCustomRoundedInputField(
                          title: "Status",
                          label: campaignsController.selectedStatus == 'draft' ? "Draft" : "Active",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          readOnly: true,
                          suffixWidget: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.obscureTextColor,
                              size: 24.sp,
                            ),
                          ),
                          onPressed: () {
                            _showStatusBottomSheet(context, campaignsController);
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Create Campaign Button
                        CustomButton(
                          onPressed: () async {
                            await campaignsController.createCampaign();
                          },
                          isBusy: campaignsController.isCreatingCampaign,
                          title: "Create Campaign",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),

                        SizedBox(height: 15.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
