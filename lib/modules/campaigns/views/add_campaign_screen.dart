import 'package:sharpvendor/core/utils/exports.dart';

class AddCampaignScreen extends StatelessWidget {
  const AddCampaignScreen({super.key});

  void _showPriorityBottomSheet(
    BuildContext context,
    CampaignsController controller,
  ) {
    showAnyBottomSheet(
      child: Container(
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              "Select Priority",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            customText(
              "Higher priority means better visibility but higher cost",
              fontSize: 12.sp,
              color: AppColors.obscureTextColor,
            ),
            SizedBox(height: 20.h),
            ...List.generate(5, (index) {
              final priority = index + 1;
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildPriorityOption(
                  priority: priority,
                  isSelected: controller.selectedPriority == priority,
                  onTap: () {
                    controller.setPriority(priority);
                    Get.back();
                  },
                ),
              );
            }),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(label, fontSize: 14.sp, color: AppColors.obscureTextColor),
        customText(
          value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
      ],
    );
  }

  Widget _buildPriorityOption({
    required int priority,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    String getMultiplierText(int priority) {
      switch (priority) {
        case 1:
          return "x1.0";
        case 2:
          return "x1.1";
        case 3:
          return "x1.2";
        case 4:
          return "x1.3";
        case 5:
          return "x1.5";
        default:
          return "x1.0";
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: customText(
                  "$priority",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    "Priority $priority",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.blackColor,
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    "Cost multiplier: ${getMultiplierText(priority)}",
                    fontSize: 12.sp,
                    color: AppColors.obscureTextColor,
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

  void _showStatusBottomSheet(
    BuildContext context,
    CampaignsController controller,
  ) {
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
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyColor.withOpacity(0.3),
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
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.blackColor,
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
                          controller:
                              campaignsController.campaignNameController,
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
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
                              final TimeOfDay? timePicked =
                                  await showTimePicker(
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
                                campaignsController.onStartDateChanged();
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
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
                            if (campaignsController
                                .startDateController
                                .text
                                .isNotEmpty) {
                              try {
                                final startDate = DateTime.parse(
                                  campaignsController.startDateController.text,
                                );
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
                            DateTime initialDate = DateTime.now().add(
                              Duration(days: 7),
                            );
                            if (campaignsController
                                .startDateController
                                .text
                                .isNotEmpty) {
                              try {
                                initialDate = DateTime.parse(
                                  campaignsController.startDateController.text,
                                ).add(Duration(days: 1));
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
                              final TimeOfDay? timePicked =
                                  await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                      hour: 23,
                                      minute: 59,
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
                                campaignsController.onEndDateChanged();
                              }
                            }
                          },
                        ),

                        // Priority
                        ClickableCustomRoundedInputField(
                          title: "Priority",
                          label: "Select priority level",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          readOnly: true,
                          controller: TextEditingController(
                            text:
                                "Priority ${campaignsController.selectedPriority}",
                          ),
                          suffixWidget: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.obscureTextColor,
                              size: 24.sp,
                            ),
                          ),
                          onPressed: () {
                            _showPriorityBottomSheet(
                              context,
                              campaignsController,
                            );
                          },
                        ),

                        // Status
                        ClickableCustomRoundedInputField(
                          title: "Status",
                          label: "Select status",
                          controller: campaignsController.statusController,
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          readOnly: true,
                          suffixWidget: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.obscureTextColor,
                              size: 24.sp,
                            ),
                          ),
                          onPressed: () {
                            _showStatusBottomSheet(
                              context,
                              campaignsController,
                            );
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Cost Estimate Section
                        if (campaignsController.costEstimate != null ||
                            campaignsController.isEstimatingCost)
                          Container(
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              color: AppColors.greenColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.greenColor.withOpacity(0.3),
                              ),
                            ),
                            child: campaignsController.isEstimatingCost
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20.sp,
                                        height: 20.sp,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.greenColor,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      customText(
                                        "Calculating cost...",
                                        fontSize: 14.sp,
                                        color: AppColors.greenColor,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calculate_outlined,
                                            color: AppColors.greenColor,
                                            size: 24.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          customText(
                                            "Estimated Campaign Cost",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.h),
                                      // Cost breakdown details
                                      _buildCostRow(
                                        "Duration",
                                        "${campaignsController.costEstimate?.durationDays ?? 0} days",
                                      ),
                                      SizedBox(height: 8.h),
                                      _buildCostRow(
                                        "Base Price",
                                        "${formatToCurrency(campaignsController.costEstimate?.basePricePerDay?.toDouble() ?? 0)}/day",
                                      ),
                                      SizedBox(height: 8.h),
                                      _buildCostRow(
                                        "Base Cost",
                                        formatToCurrency(
                                          campaignsController
                                                  .costEstimate
                                                  ?.baseCost
                                                  ?.toDouble() ??
                                              0,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      _buildCostRow(
                                        "Priority Multiplier",
                                        "x${campaignsController.costEstimate?.priorityMultiplier ?? 1.0}",
                                      ),
                                      Divider(
                                        height: 24.h,
                                        color: AppColors.greenColor.withOpacity(
                                          0.3,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customText(
                                            "Total Cost",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.blackColor,
                                          ),
                                          customText(
                                            formatToCurrency(
                                              campaignsController
                                                      .costEstimate
                                                      ?.finalCost
                                                      ?.toDouble() ??
                                                  0,
                                            ),
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.greenColor,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),

                        if (campaignsController.costEstimate != null ||
                            campaignsController.isEstimatingCost)
                          SizedBox(height: 20.h),

                        // Wallet Charge Notice
                        GetBuilder<SettingsController>(
                          builder: (settingsController) {
                            final walletBalance = settingsController
                                    .userProfile
                                    ?.restaurant
                                    ?.wallet
                                    ?.formattedBalance ??
                                '₦0.00';
                            return Container(
                              padding: EdgeInsets.all(16.sp),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.sp),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet,
                                      color: AppColors.primaryColor,
                                      size: 24.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                          "Payment from Wallet",
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor,
                                        ),
                                        SizedBox(height: 4.h),
                                        customText(
                                          "Campaign cost will be charged from your wallet balance",
                                          fontSize: 12.sp,
                                          color: AppColors.obscureTextColor,
                                        ),
                                        SizedBox(height: 8.h),
                                        Row(
                                          children: [
                                            customText(
                                              "Available Balance: ",
                                              fontSize: 12.sp,
                                              color: AppColors.obscureTextColor,
                                            ),
                                            customText(
                                              walletBalance,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
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
