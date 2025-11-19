import 'package:sharpvendor/core/utils/exports.dart';

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
                  Visibility(
                    visible: campaignsController.allCampaigns.isNotEmpty,
                    replacement: Container(
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
                            campaignsController.isFetchingCampaigns
                                ? "Loading..."
                                : "No campaigns yet",
                            fontSize: 16.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          if (!campaignsController.isFetchingCampaigns)
                            SizedBox(height: 8.h),
                          if (!campaignsController.isFetchingCampaigns)
                            customText(
                              "Create your first campaign to get started",
                              fontSize: 14.sp,
                              color: AppColors.obscureTextColor,
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                    child: Expanded(
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.greyColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: customText(
                    campaign.name ?? "Unnamed Campaign",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(width: 8.w),
                _buildStatusBadge(campaign.status ?? "draft"),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: SvgPicture.asset(
                    SvgAssets.calendarIcon,
                    height: 16.sp,
                    width: 16.sp,
                    colorFilter: ColorFilter.mode(
                      AppColors.obscureTextColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                customText(
                  "${_formatDate(campaign.startDate)} - ${_formatDate(campaign.endDate)}",
                  fontSize: 13.sp,
                  color: AppColors.obscureTextColor,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.star_outline,
                  size: 16.sp,
                  color: AppColors.obscureTextColor,
                ),
                SizedBox(width: 6.w),
                customText(
                  "Priority: ${campaign.priority ?? 1}",
                  fontSize: 13.sp,
                  color: AppColors.obscureTextColor,
                ),
                SizedBox(width: 16.w),
                if (campaign.totalCost != null) ...[
                  Icon(
                    Icons.currency_exchange,
                    size: 16.sp,
                    color: AppColors.obscureTextColor,
                  ),
                  SizedBox(width: 6.w),
                  customText(
                    "₦${campaign.totalCost}",
                    fontSize: 13.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
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

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }
}
