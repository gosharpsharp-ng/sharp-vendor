import 'package:sharpvendor/modules/menu/controllers/discount_controller.dart';
import '../../../../core/utils/exports.dart';

class AddDiscountScreen extends StatelessWidget {
  const AddDiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int menuId = Get.arguments as int;

    return GetBuilder<DiscountController>(
      init: DiscountController(),
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.find<DiscountController>().initializeCreateForm(menuId);
        });
      },
      builder: (controller) {
        return Form(
          key: controller.formKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Create Discount",
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

                        // Discount Name
                        CustomRoundedInputField(
                          title: "Discount Name",
                          label: "e.g. Summer Special",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller: controller.nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a discount name';
                            }
                            return null;
                          },
                        ),

                        // Discount Type
                        ClickableCustomRoundedInputField(
                          title: "Discount Type",
                          label: "Select discount type",
                          readOnly: true,
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller: TextEditingController(
                            text: controller.selectedType == 'percentage'
                                ? 'Percentage (%)'
                                : 'Fixed Amount (\$)',
                          ),
                          onPressed: () {
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
                                    customText(
                                      "Select Discount Type",
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 20.h),
                                    ListTile(
                                      title: customText(
                                        "Percentage (%)",
                                        fontSize: 16.sp,
                                        color: AppColors.blackColor,
                                      ),
                                      leading: Radio<String>(
                                        value: 'percentage',
                                        groupValue: controller.selectedType,
                                        onChanged: (value) {
                                          if (value != null) {
                                            controller.setDiscountType(value);
                                            Get.back();
                                          }
                                        },
                                        activeColor: AppColors.primaryColor,
                                      ),
                                      onTap: () {
                                        controller.setDiscountType(
                                          'percentage',
                                        );
                                        Get.back();
                                      },
                                    ),
                                    ListTile(
                                      title: customText(
                                        "Fixed Amount (\$)",
                                        fontSize: 16.sp,
                                        color: AppColors.blackColor,
                                      ),
                                      leading: Radio<String>(
                                        value: 'fixed',
                                        groupValue: controller.selectedType,
                                        onChanged: (value) {
                                          if (value != null) {
                                            controller.setDiscountType(value);
                                            Get.back();
                                          }
                                        },
                                        activeColor: AppColors.primaryColor,
                                      ),
                                      onTap: () {
                                        controller.setDiscountType('fixed');
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          suffixWidget: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                        ),

                        // Discount Value
                        CustomRoundedInputField(
                          title: controller.selectedType == 'percentage'
                              ? "Discount Percentage"
                              : "Discount Amount",
                          label: controller.selectedType == 'percentage'
                              ? "e.g. 25"
                              : "e.g. 5.00",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          keyboardType: TextInputType.number,
                          controller: controller.valueController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a discount value';
                            }
                            final numValue = double.tryParse(value);
                            if (numValue == null || numValue <= 0) {
                              return 'Please enter a valid number greater than 0';
                            }
                            if (controller.selectedType == 'percentage' &&
                                numValue > 100) {
                              return 'Percentage cannot exceed 100';
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
                          controller: controller.startDateController,
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
                              initialDate:
                                  controller.selectedStartDate ??
                                  DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
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
                              controller.setStartDate(picked);
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
                          controller: controller.endDateController,
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
                            return null;
                          },
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  controller.selectedEndDate ??
                                  (controller.selectedStartDate ??
                                          DateTime.now())
                                      .add(const Duration(days: 7)),
                              firstDate:
                                  controller.selectedStartDate ??
                                  DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
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
                              controller.setEndDate(picked);
                            }
                          },
                        ),

                        // Active Checkbox
                        SizedBox(height: 15.h),
                        InkWell(
                          onTap: () {
                            controller.toggleActive(!controller.isActive);
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: controller.isActive,
                                onChanged: (value) {
                                  controller.toggleActive(value ?? false);
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      "Active",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 4.h),
                                    customText(
                                      "Discount is available for customers",
                                      fontSize: 12.sp,
                                      color: AppColors.greyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),

                        // Show on Listing Checkbox
                        InkWell(
                          onTap: () {
                            controller.toggleShowOnListing(!controller.showOnListing);
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: controller.showOnListing,
                                onChanged: (value) {
                                  controller.toggleShowOnListing(value ?? false);
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      "Show on Listing",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 4.h),
                                    customText(
                                      "Display badge on menu listings",
                                      fontSize: 12.sp,
                                      color: AppColors.greyColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: CustomButton(
                onPressed: () async {
                  await controller.createDiscount();
                },
                isBusy: controller.isLoading,
                title: "Create Discount",
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
