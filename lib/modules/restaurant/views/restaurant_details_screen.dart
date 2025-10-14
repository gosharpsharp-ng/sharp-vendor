import 'package:sharpvendor/core/models/bank_account_model.dart';
import 'package:sharpvendor/core/utils/exports.dart';

class RestaurantDetailsScreen extends GetView<RestaurantDetailsController> {
  const RestaurantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantDetailsController>(
      builder: (restaurantController) {
        final restaurant = restaurantController.restaurant;

        if (restaurant == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () => Get.back(),
              title: "Restaurant Details",
            ),
            body: Center(
              child: customText(
                "No restaurant data available",
                color: AppColors.blackColor,
                fontSize: 16.sp,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () => Get.back(),
            title: "Restaurant Details",
          ),
          backgroundColor: const Color(0xFFF5F7FA),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
              
                  // Profile Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24.r,
                          offset: Offset(0, 8.h),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Cover Photo Section with Overlapping Logo
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Cover Photo
                            Container(
                              height: 120.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.r),
                                  topRight: Radius.circular(24.r),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.primaryColor.withAlpha(20),
                                    AppColors.primaryColor.withAlpha(150),
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Cover Image
                                  if (restaurant.banner != null && restaurant.banner!.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24.r),
                                        topRight: Radius.circular(24.r),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: restaurant.banner!,
                                        width: double.infinity,
                                        height: 120.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                  // Edit Cover Button
                                  Positioned(
                                    top: 12.h,
                                    right: 12.w,
                                    child: GestureDetector(
                                      onTap: () => Get.toNamed(Routes.RESTAURANT_EDIT_BASIC_INFO),
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: SvgPicture.asset(
                                          SvgAssets.cameraIcon,
                                          color: AppColors.whiteColor,
                                          height: 16.sp,
                                          width: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Profile Picture - Positioned at Bottom Left
                            Positioned(
                              left: 20.w,
                              bottom: -50.h,
                              child: Container(
                                width: 100.w,
                                height: 100.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.whiteColor,
                                    width: 4.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 16.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Profile Image
                                    restaurant.logo != null && restaurant.logo!.isNotEmpty
                                        ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: restaurant.logo!,
                                        fit: BoxFit.cover,
                                        width: 100.w,
                                        height: 100.w,
                                        placeholder: (context, url) => Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.backgroundColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                              strokeWidth: 2.w,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.restaurant_menu,
                                            color: AppColors.primaryColor,
                                            size: 40.sp,
                                          ),
                                        ),
                                      ),
                                    )
                                        : Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.restaurant_menu,
                                        color: AppColors.primaryColor,
                                        size: 40.sp,
                                      ),
                                    ),

                                    // Edit Profile Picture Button
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => Get.toNamed(Routes.RESTAURANT_EDIT_BASIC_INFO),
                                        child: Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.whiteColor,
                                              width: 2.w,
                                            ),
                                          ),
                                          child: SvgPicture.asset(
                                            SvgAssets.cameraIcon,
                                            color: AppColors.whiteColor,
                                            height: 12.sp,
                                            width: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Profile Content
                        Padding(
                          padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Picture and Basic Info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
              
                                  // Restaurant Name
                                  customText(
                                    restaurant.name,
                                    color: AppColors.blackColor,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
              
                                  SizedBox(height: 8.h),
              
                                  // Cuisine Type Badge
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: customText(
                                      restaurant.cuisineType,
                                      color: AppColors.primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
              
                                  SizedBox(height: 12.h),
              
                                  // Description
                                  if (restaurant.description != null && restaurant.description!.isNotEmpty)
                                    customText(
                                      restaurant.description!,
                                      color: AppColors.greyColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      textAlign: TextAlign.center,
                                      height: 1.5,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
              
                                  SizedBox(height: 16.h),
              
                                  // Status and Location Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Status Badge
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: restaurantController.getStatusColor().withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16.r),
                                          border: Border.all(
                                            color: restaurantController.getStatusColor(),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6.w,
                                              height: 6.w,
                                              decoration: BoxDecoration(
                                                color: restaurantController.getStatusColor(),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            customText(
                                              restaurantController.getStatusText(),
                                              color: restaurantController.getStatusColor(),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
              
                                      if (restaurant.location != null) ...[
                                        SizedBox(width: 12.w),
                                        // Location Badge
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.greyColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: AppColors.greyColor,
                                                size: 12.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              customText(
                                                restaurant.location!.name.length > 15
                                                    ? "${restaurant.location!.name.substring(0, 15)}..."
                                                    : restaurant.location!.name,
                                                color: AppColors.greyColor,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  SizedBox(height: 24.h),
              
                  // Information Sections
                  _buildInfoSection(
                    "Contact Information",
                    SvgAssets.callIcon,
                    [
                      _buildInfoRow("Email", restaurant.email, SvgAssets.profileIcon),
                      _buildInfoRow("Phone", restaurant.phone, SvgAssets.callIcon),
                      if (restaurant.location != null)
                        _buildInfoRow("Address", restaurant.location!.name, SvgAssets.locationIcon),
                    ],
                        () => Get.toNamed(Routes.RESTAURANT_EDIT_BASIC_INFO),
                  ),
              
                  SizedBox(height: 16.h),
              
                  _buildInfoSection(
                    "Business Details",
                    SvgAssets.operationsIcon,
                    [
                      _buildInfoRow("Commission Rate", "${restaurant.commissionRate.toStringAsFixed(1)}%", SvgAssets.analyticsIcon),
                      _buildInfoRow("Registration", restaurant.businessRegistrationNumber ?? "Not set", SvgAssets.operationsIcon),
                      _buildInfoRow("Tax ID", restaurant.taxIdentificationNumber ?? "Not set", SvgAssets.operationsIcon),
                    ],
                        () => Get.toNamed(Routes.RESTAURANT_BUSINESS_SETTINGS),
                  ),
              
                  SizedBox(height: 16.h),
              
                  _buildInfoSection(
                    "Operating Hours",
                    SvgAssets.timeIcon,
                    _buildScheduleRows(restaurant.schedules),
                        () => Get.toNamed(Routes.RESTAURANT_BUSINESS_HOURS),
                  ),
              
                  SizedBox(height: 16.h),
              
                  _buildInfoSection(
                    "Bank Account",
                    SvgAssets.walletIcon,
                    _buildBankAccountRows(restaurant.bankAccount),
                        () => _handleBankAccountEdit(restaurant.bankAccount),
                  ),
              
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  // Show more options menu
  void _showMoreOptions(BuildContext context, RestaurantDetailsController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            _buildOptionItem("Edit Profile", Icons.edit_outlined, () {
              Get.back();
              Get.toNamed(Routes.RESTAURANT_EDIT_BASIC_INFO);
            }),
            _buildOptionItem("Business Settings", Icons.business_outlined, () {
              Get.back();
              Get.toNamed(Routes.RESTAURANT_BUSINESS_SETTINGS);
            }),
            _buildOptionItem("Operating Hours", Icons.access_time_outlined, () {
              Get.back();
              Get.toNamed(Routes.RESTAURANT_BUSINESS_HOURS);
            }),
            _buildOptionItem("Toggle Status", Icons.power_settings_new_outlined, () {
              Get.back();
              controller.toggleRestaurantStatus();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 20.sp),
            SizedBox(width: 12.w),
            customText(
              title,
              color: AppColors.blackColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: AppColors.greyColor, size: 16.sp),
          ],
        ),
      ),
    );
  }

  // Build info section with modern card design
  Widget _buildInfoSection(String title, String titleIcon, List<Widget> children, VoidCallback onEdit) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(titleIcon, colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn), height: 20.sp, width: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: customText(
                    title,
                    color: AppColors.blackColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: SvgPicture.asset(
                      SvgAssets.editIcon,
                      color: AppColors.primaryColor,
                      height: 16.sp,
                      width: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, String icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              icon,
              color: AppColors.primaryColor,
              colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
              height: 16.sp,
              width: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  label,
                  color: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 2.h),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScheduleRows(List<RestaurantSchedule> schedules) {
    if (schedules.isEmpty) {
      return [
        _buildInfoRow("Status", "No schedule set", SvgAssets.timeIcon),
      ];
    }

    return schedules.map((schedule) {
      String timeRange;
      try {
        final openTime = TimeOfDay.fromDateTime(schedule.openTime);
        final closeTime = TimeOfDay.fromDateTime(schedule.closeTime);
        timeRange = "${openTime.format(Get.context!)} - ${closeTime.format(Get.context!)}";
      } catch (e) {
        timeRange = schedule.timeRange;
      }

      return _buildInfoRow(
        schedule.dayOfWeek.capitalizeFirst ?? schedule.dayOfWeek,
        timeRange,
        SvgAssets.timeIcon,
      );
    }).toList();
  }

  List<Widget> _buildBankAccountRows(BankAccount? bankAccount) {
    if (bankAccount == null) {
      return [
        _buildInfoRow("Status", "No bank account set", SvgAssets.walletIcon),
      ];
    }

    return [
      _buildInfoRow("Account Name", bankAccount.bankAccountName, SvgAssets.profileIcon),
      _buildInfoRow("Account Number", bankAccount.bankAccountNumber, SvgAssets.walletIcon),
      _buildInfoRow("Bank Name", bankAccount.bankName, SvgAssets.walletIcon),
    ];
  }


  void _handleBankAccountEdit(BankAccount? bankAccount) {
    // Navigate to bank account edit screen
    Get.toNamed(Routes.RESTAURANT_BANK_ACCOUNT);
  }
}