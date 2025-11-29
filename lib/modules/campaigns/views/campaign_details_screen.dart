import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sharpvendor/core/utils/exports.dart';

class CampaignDetailsScreen extends StatefulWidget {
  const CampaignDetailsScreen({super.key});

  @override
  State<CampaignDetailsScreen> createState() => _CampaignDetailsScreenState();
}

class _CampaignDetailsScreenState extends State<CampaignDetailsScreen> {
  Timer? _countdownTimer;
  Duration _remainingTime = Duration.zero;
  Duration _timeUntilStart = Duration.zero;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdownTimer() {
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final campaign = Get.find<CampaignsController>().selectedCampaign;
    if (campaign == null) return;

    final now = DateTime.now();

    if (campaign.startDate != null) {
      try {
        final startDate = DateTime.parse(campaign.startDate!);
        if (startDate.isAfter(now)) {
          setState(() {
            _hasStarted = false;
            _timeUntilStart = startDate.difference(now);
            _remainingTime = Duration.zero;
          });
          return;
        }
      } catch (e) {}
    }

    if (campaign.endDate != null) {
      try {
        final endDate = DateTime.parse(campaign.endDate!);
        setState(() {
          _hasStarted = true;
          _timeUntilStart = Duration.zero;
          if (endDate.isAfter(now)) {
            _remainingTime = endDate.difference(now);
          } else {
            _remainingTime = Duration.zero;
          }
        });
      } catch (e) {}
    }
  }

  String _formatCountdown(Duration duration) {
    if (duration == Duration.zero) return "00:00:00";

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return "${days}d ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  String _formatHumanReadableDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "Not set";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('EEE, MMM d, yyyy • h:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 64.sp,
                    color: AppColors.obscureTextColor.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 16.h),
                  customText(
                    "No campaign selected",
                    fontSize: 16.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ],
              ),
            ),
          );
        }

        final isActive = campaign.status?.toLowerCase() == 'active';
        final isPaused = campaign.status?.toLowerCase() == 'paused';
        final isCancelled = [
          'cancelled',
          'canceled',
        ].contains(campaign.status?.toLowerCase());
        final isCompleted = campaign.status?.toLowerCase() == 'completed';

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Campaign Details",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campaign Name and Status
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: customText(
                              campaign.name ?? "Unnamed Campaign",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                          _buildStatusBadge(campaign.status ?? "draft"),
                        ],
                      ),
                      if (campaign.createdAt != null) ...[
                        SizedBox(height: 8.h),
                        customText(
                          "Created ${_formatHumanReadableDate(campaign.createdAt)}",
                          fontSize: 13.sp,
                          color: AppColors.obscureTextColor,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Countdown Timer
                if (!isCancelled && !isCompleted)
                  _buildCountdownWidget(campaign),

                if (!isCancelled && !isCompleted) SizedBox(height: 16.h),

                // Schedule
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        "Schedule",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 16.h),
                      _buildInfoRow(
                        icon: Icons.play_circle_outline,
                        label: "Starts",
                        value: _formatHumanReadableDate(campaign.startDate),
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow(
                        icon: Icons.stop_circle_outlined,
                        label: "Ends",
                        value: _formatHumanReadableDate(campaign.endDate),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // Details
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        "Details",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 16.h),
                      _buildDetailRow(
                        "Priority",
                        "Level ${campaign.priority ?? 1}",
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailRow(
                        "Payment Method",
                        _formatPaymentMethod(campaign.paymentMethodCode),
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailRow(
                        "Payment Status",
                        campaign.paymentStatus?.toUpperCase() ?? "PENDING",
                      ),
                      if (campaign.totalCost != null) ...[
                        SizedBox(height: 12.h),
                        _buildDetailRow(
                          "Total Cost",
                          "₦${campaign.totalCost}",
                          isBold: true,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Actions
                if (!isCancelled && !isCompleted) ...[
                  if (isActive)
                    CustomButton(
                      onPressed: () {
                        _showConfirmationDialog(
                          context,
                          title: "Pause Campaign",
                          message:
                              "Are you sure you want to pause this campaign?",
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

                  if (isPaused)
                    CustomButton(
                      onPressed: () {
                        _showConfirmationDialog(
                          context,
                          title: "Resume Campaign",
                          message:
                              "Are you sure you want to resume this campaign?",
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

                  // Cancel - simple text button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _showConfirmationDialog(
                          context,
                          title: "Cancel Campaign",
                          message:
                              "Are you sure you want to cancel this campaign? This action cannot be undone.",
                          onConfirm: () async {
                            await campaignsController.updateCampaignStatus(
                              campaign.id!,
                              'cancelled',
                            );
                          },
                          isDestructive: true,
                        );
                      },
                      child: customText(
                        "Cancel Campaign",
                        fontSize: 14.sp,
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountdownWidget(CampaignModel campaign) {
    final isEnded = _hasStarted && _remainingTime == Duration.zero;
    final isWaiting = !_hasStarted && _timeUntilStart > Duration.zero;
    final isRunning = _hasStarted && _remainingTime > Duration.zero;

    String title;
    String countdownText;
    Color accentColor;

    if (isWaiting) {
      title = "Starts In";
      countdownText = _formatCountdown(_timeUntilStart);
      accentColor = Colors.blue;
    } else if (isRunning) {
      title = "Time Remaining";
      countdownText = _formatCountdown(_remainingTime);
      accentColor = AppColors.primaryColor;
    } else {
      title = "Campaign Ended";
      countdownText = "00:00:00";
      accentColor = AppColors.redColor;
    }

    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(title, fontSize: 13.sp, color: AppColors.obscureTextColor),
          SizedBox(height: 8.h),
          customText(
            countdownText,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
          if (isRunning) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: _getProgress(campaign),
                backgroundColor: AppColors.greyColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 6.h,
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _getProgress(CampaignModel campaign) {
    try {
      final startDate = DateTime.parse(campaign.startDate!);
      final endDate = DateTime.parse(campaign.endDate!);
      final now = DateTime.now();

      final totalDuration = endDate.difference(startDate).inSeconds;
      final elapsedDuration = now.difference(startDate).inSeconds;

      if (totalDuration > 0) {
        return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
      }
    } catch (e) {}
    return 0;
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.obscureTextColor),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              label,
              fontSize: 12.sp,
              color: AppColors.obscureTextColor,
            ),
            SizedBox(height: 2.h),
            customText(value, fontSize: 14.sp, color: AppColors.blackColor),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(label, fontSize: 14.sp, color: AppColors.obscureTextColor),
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
        bgColor = AppColors.greenColor.withValues(alpha: 0.1);
        textColor = AppColors.greenColor;
        displayText = 'Active';
        break;
      case 'paused':
        bgColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        displayText = 'Paused';
        break;
      case 'completed':
        bgColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        displayText = 'Completed';
        break;
      case 'cancelled':
      case 'canceled':
        bgColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        displayText = 'Cancelled';
        break;
      case 'draft':
      default:
        bgColor = AppColors.greyColor.withValues(alpha: 0.1);
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
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }

  String _formatPaymentMethod(String? code) {
    if (code == null) return "N/A";
    switch (code.toLowerCase()) {
      case 'wallet':
        return "Wallet";
      case 'card':
        return "Card";
      case 'transfer':
        return "Transfer";
      default:
        return code;
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
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
              onPressed: () => Get.back(),
              child: customText(
                "No",
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
                "Yes",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDestructive
                    ? AppColors.redColor
                    : AppColors.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
