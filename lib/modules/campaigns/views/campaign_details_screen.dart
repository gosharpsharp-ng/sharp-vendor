import 'package:sharpvendor/core/utils/exports.dart';

class CampaignDetailsScreen extends StatelessWidget {
  const CampaignDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignsController>(
      builder: (campaignsController) {
        final campaign = campaignsController.selectedCampaign;

        if (campaign == null) {
          return Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Campaign Details",
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: customText(
                "No campaign selected",
                fontSize: 16.sp,
                color: AppColors.obscureTextColor,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Campaign Details",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Campaign Header
                SectionBox(
                  backgroundColor: AppColors.whiteColor,
                  children: [
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: customText(
                            campaign.name ?? "Unnamed Campaign",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ),
                        _buildStatusBadge(campaign.status ?? "draft"),
                      ],
                    ),
                    SizedBox(height: 15.h),
                  ],
                ),

                SizedBox(height: 12.h),

                // Campaign Information
                SectionBox(
                  backgroundColor: AppColors.whiteColor,
                  children: [
                    SizedBox(height: 15.h),
                    customText(
                      "Campaign Information",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 15.h),

                    _buildDetailRow("Start Date", _formatDateTime(campaign.startDate)),
                    SizedBox(height: 12.h),
                    _buildDetailRow("End Date", _formatDateTime(campaign.endDate)),
                    SizedBox(height: 12.h),
                    _buildDetailRow("Priority", "Level ${campaign.priority ?? 1}"),
                    SizedBox(height: 12.h),
                    _buildDetailRow("Payment Method",
                      campaign.paymentMethodCode?.toUpperCase() ?? "N/A"),
                    SizedBox(height: 12.h),
                    _buildDetailRow("Payment Status",
                      campaign.paymentStatus?.toUpperCase() ?? "PENDING"),
                    SizedBox(height: 12.h),
                    if (campaign.totalCost != null)
                      _buildDetailRow("Total Cost", "₦${campaign.totalCost}"),

                    SizedBox(height: 15.h),
                  ],
                ),

                SizedBox(height: 12.h),

                // Cost Breakdown (if available)
                if (campaignsController.costBreakdown != null) ...[
                  SectionBox(
                    backgroundColor: AppColors.whiteColor,
                    children: [
                      SizedBox(height: 15.h),
                      customText(
                        "Cost Breakdown",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 15.h),

                      _buildDetailRow("Base Cost",
                        "₦${campaignsController.costBreakdown?.baseCost ?? 'N/A'}"),
                      SizedBox(height: 12.h),
                      _buildDetailRow("Duration",
                        "${campaignsController.costBreakdown?.durationDays ?? 0} days"),
                      SizedBox(height: 12.h),
                      _buildDetailRow("Priority Multiplier",
                        "x${campaignsController.costBreakdown?.priorityMultiplier ?? '1'}"),
                      SizedBox(height: 12.h),
                      _buildDetailRow("Total Cost",
                        "₦${campaignsController.costBreakdown?.totalCost ?? 'N/A'}",
                        isBold: true),

                      SizedBox(height: 15.h),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],

                // Actions
                if (campaign.status != null &&
                    !['cancelled', 'canceled', 'completed'].contains(campaign.status!.toLowerCase()))
                  SectionBox(
                    backgroundColor: AppColors.whiteColor,
                    children: [
                      SizedBox(height: 15.h),

                      // Pause/Resume Button
                      if (campaign.status?.toLowerCase() == 'active')
                        CustomButton(
                          onPressed: () async {
                            _showConfirmationDialog(
                              context,
                              title: "Pause Campaign",
                              message: "Are you sure you want to pause this campaign?",
                              onConfirm: () async {
                                await campaignsController.updateCampaignStatus(
                                  campaign.id!,
                                  'paused',
                                );
                              },
                            );
                          },
                          isBusy: campaignsController.isUpdatingCampaign,
                          title: "Pause Campaign",
                          width: 1.sw,
                          backgroundColor: Colors.orange,
                          fontColor: AppColors.whiteColor,
                        ),

                      if (campaign.status?.toLowerCase() == 'paused')
                        CustomButton(
                          onPressed: () async {
                            _showConfirmationDialog(
                              context,
                              title: "Resume Campaign",
                              message: "Are you sure you want to resume this campaign?",
                              onConfirm: () async {
                                await campaignsController.updateCampaignStatus(
                                  campaign.id!,
                                  'active',
                                );
                              },
                            );
                          },
                          isBusy: campaignsController.isUpdatingCampaign,
                          title: "Resume Campaign",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),

                      SizedBox(height: 12.h),

                      // Cancel Button
                      CustomButton(
                        onPressed: () async {
                          _showConfirmationDialog(
                            context,
                            title: "Cancel Campaign",
                            message: "Are you sure you want to cancel this campaign? This action cannot be undone.",
                            onConfirm: () async {
                              await campaignsController.updateCampaignStatus(
                                campaign.id!,
                                'cancelled',
                              );
                            },
                            isDestructive: true,
                          );
                        },
                        isBusy: campaignsController.isUpdatingCampaign,
                        title: "Cancel Campaign",
                        width: 1.sw,
                        backgroundColor: AppColors.whiteColor,
                        fontColor: AppColors.redColor,
                        borderColor: AppColors.redColor,
                      ),

                      SizedBox(height: 15.h),
                    ],
                  ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          fontSize: 14.sp,
          color: AppColors.obscureTextColor,
        ),
        customText(
          value,
          fontSize: 14.sp,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          color: AppColors.blackColor,
        ),
      ],
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

  String _formatDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: customText(
            title,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          content: customText(
            message,
            fontSize: 14.sp,
            color: AppColors.obscureTextColor,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: customText(
                "Cancel",
                fontSize: 14.sp,
                color: AppColors.obscureTextColor,
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await onConfirm();
              },
              child: customText(
                "Confirm",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDestructive ? AppColors.redColor : AppColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
