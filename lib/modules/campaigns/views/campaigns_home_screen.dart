import 'package:intl/intl.dart';
import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/core/utils/widgets/skeleton_loaders.dart';

class CampaignsHomeScreen extends StatelessWidget {
  const CampaignsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (campaignsController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Campaigns",
          ),
          backgroundColor: AppColors.backgroundColor,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Get.toNamed(Routes.ADD_CAMPAIGN_SCREEN);
            },
            backgroundColor: AppColors.primaryColor,
            icon: Icon(Icons.add, color: AppColors.whiteColor),
            label: customText(
              "New Campaign",
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          body: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            onRefresh: () async {
              await campaignsController.getCampaigns();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              height: 1.sh,
              width: 1.sw,
              color: AppColors.backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  const SectionHeader(
                    title: "All Campaigns",
                  ),
                  SizedBox(height: 10.h),
                  // Show skeleton loader when fetching
                  if (campaignsController.isFetchingCampaigns)
                    Expanded(
                      child: SkeletonLoaders.campaignCard(count: 4),
                    )
                  else if (campaignsController.allCampaigns.isEmpty)
                    Container(
                      width: 1.sw,
                      height: 1.sh * 0.674,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            size: 64.sp,
                            color: AppColors.obscureTextColor.withOpacity(0.5),
                          ),
                          SizedBox(height: 16.h),
                          customText(
                            "No campaigns yet",
                            fontSize: 16.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(height: 8.h),
                          customText(
                            "Create your first campaign to get started",
                            fontSize: 14.sp,
                            color: AppColors.obscureTextColor,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: campaignsController.allCampaigns.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final campaign =
                              campaignsController.allCampaigns[index];
                          return _buildCampaignCard(
                            campaign: campaign,
                            onTap: () {
                              campaignsController.setSelectedCampaign(campaign);
                              Get.toNamed(Routes.CAMPAIGN_DETAILS_SCREEN);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCampaignCard({
    required CampaignModel campaign,
    required VoidCallback onTap,
  }) {
    final isActive = campaign.status?.toLowerCase() == 'active';
    final statusColor = _getStatusColor(campaign.status ?? 'draft');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with name and status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campaign icon
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.campaign_outlined,
                          color: statusColor,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              campaign.name ?? "Unnamed Campaign",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(height: 4.h),
                            customText(
                              _formatDateRange(campaign.startDate, campaign.endDate),
                              fontSize: 13.sp,
                              color: AppColors.obscureTextColor,
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(campaign.status ?? "draft"),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Stats row
                  Row(
                    children: [
                      // Priority
                      _buildStatChip(
                        icon: Icons.star_rounded,
                        label: "Level ${campaign.priority ?? 1}",
                        color: Colors.amber,
                      ),
                      SizedBox(width: 12.w),
                      // Cost
                      if (campaign.totalCost != null)
                        _buildStatChip(
                          icon: Icons.payments_outlined,
                          label: "₦${campaign.totalCost}",
                          color: AppColors.primaryColor,
                        ),
                      const Spacer(),
                      // Arrow indicator
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14.sp,
                        color: AppColors.obscureTextColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Time remaining indicator for active campaigns
            if (isActive && campaign.endDate != null)
              _buildTimeRemainingBar(campaign),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          customText(
            label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRemainingBar(CampaignModel campaign) {
    try {
      final startDate = DateTime.parse(campaign.startDate!);
      final endDate = DateTime.parse(campaign.endDate!);
      final now = DateTime.now();

      final totalDuration = endDate.difference(startDate).inSeconds;
      final elapsedDuration = now.difference(startDate).inSeconds;

      double progress = 0;
      if (totalDuration > 0) {
        progress = (elapsedDuration / totalDuration).clamp(0.0, 1.0);
      }

      final remaining = endDate.difference(now);
      String remainingText;
      if (remaining.inDays > 0) {
        remainingText = "${remaining.inDays}d left";
      } else if (remaining.inHours > 0) {
        remainingText = "${remaining.inHours}h left";
      } else if (remaining.inMinutes > 0) {
        remainingText = "${remaining.inMinutes}m left";
      } else {
        remainingText = "Ending soon";
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.timer_outlined, size: 14.sp, color: AppColors.primaryColor),
            SizedBox(width: 6.w),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.greyColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  minHeight: 4.h,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            customText(
              remainingText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.greenColor;
      case 'paused':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      case 'draft':
      default:
        return AppColors.obscureTextColor;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = AppColors.primaryColor.withOpacity(0.1);
        textColor = AppColors.primaryColor;
        displayText = 'Active';
        break;
      case 'paused':
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        displayText = 'Paused';
        break;
      case 'completed':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        displayText = 'Completed';
        break;
      case 'cancelled':
      case 'canceled':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        displayText = 'Cancelled';
        break;
      case 'draft':
      default:
        bgColor = AppColors.greyColor.withOpacity(0.1);
        textColor = AppColors.obscureTextColor;
        displayText = 'Draft';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: customText(
        displayText,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  String _formatDateRange(String? startDateString, String? endDateString) {
    if (startDateString == null && endDateString == null) return "No dates set";

    try {
      String formatSingleDate(String? dateString) {
        if (dateString == null || dateString.isEmpty) return "N/A";
        final date = DateTime.parse(dateString);
        return DateFormat('MMM d').format(date);
      }

      final start = formatSingleDate(startDateString);
      final end = formatSingleDate(endDateString);
      return "$start - $end";
    } catch (e) {
      return "Invalid dates";
    }
  }
}
