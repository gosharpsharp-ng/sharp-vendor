import 'package:sharpvendor/core/utils/exports.dart';

enum NotificationType { success, error, info, warning }

class CustomNotification {
  static void show({
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
  }) {
    Get.snackbar(
      "",
      "",
      titleText: const SizedBox.shrink(),
      messageText: _buildNotificationCard(message, type, title),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      borderRadius: 0,
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.up,
      snackStyle: SnackStyle.FLOATING,
      maxWidth: 1.sw,
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  static Widget _buildNotificationCard(
    String message,
    NotificationType type,
    String? title,
  ) {
    final config = _getNotificationConfig(type);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: config.shadowColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.closeCurrentSnackbar(),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon container with animated background
                Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: config.iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    config.iconPath,
                    height: 24.sp,
                    width: 24.sp,
                    colorFilter: ColorFilter.mode(
                      config.iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customText(
                        title ?? config.defaultTitle,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: config.titleColor,
                      ),
                      SizedBox(height: 4.h),
                      customText(
                        message,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: config.messageColor,
                        overflow: TextOverflow.visible,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Close button
                InkWell(
                  onTap: () => Get.closeCurrentSnackbar(),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(4.sp),
                    child: Icon(
                      Icons.close,
                      size: 20.sp,
                      color: config.closeIconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static _NotificationConfig _getNotificationConfig(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return _NotificationConfig(
          gradientColors: [
            AppColors.lightGreenColor,
            AppColors.lightGreenColor.withValues(alpha: 0.95),
          ],
          iconPath: SvgAssets.successIcon,
          iconColor: AppColors.greenColor,
          iconBackgroundColor: AppColors.greenColor.withValues(alpha: 0.2),
          titleColor: AppColors.greenColor,
          messageColor: AppColors.greenColor.withValues(alpha: 0.9),
          closeIconColor: AppColors.greenColor.withValues(alpha: 0.7),
          shadowColor: AppColors.greenColor,
          defaultTitle: "Success!",
        );

      case NotificationType.error:
        return _NotificationConfig(
          gradientColors: [
            AppColors.lightRedColor,
            AppColors.lightRedColor.withValues(alpha: 0.95),
          ],
          iconPath: SvgAssets.errorIcon,
          iconColor: AppColors.redColor,
          iconBackgroundColor: AppColors.redColor.withValues(alpha: 0.2),
          titleColor: AppColors.redColor,
          messageColor: AppColors.redColor.withValues(alpha: 0.9),
          closeIconColor: AppColors.redColor.withValues(alpha: 0.7),
          shadowColor: AppColors.redColor,
          defaultTitle: "Error!",
        );

      case NotificationType.warning:
        return _NotificationConfig(
          gradientColors: [
            AppColors.lightAmberColor,
            AppColors.lightAmberColor.withValues(alpha: 0.95),
          ],
          iconPath: SvgAssets.errorIcon, // Using error icon for warning
          iconColor: AppColors.amberColor,
          iconBackgroundColor: AppColors.amberColor.withValues(alpha: 0.2),
          titleColor: AppColors.amberColor,
          messageColor: AppColors.amberColor.withValues(alpha: 0.9),
          closeIconColor: AppColors.amberColor.withValues(alpha: 0.7),
          shadowColor: AppColors.amberColor,
          defaultTitle: "Warning!",
        );

      case NotificationType.info:
        return _NotificationConfig(
          gradientColors: [
            AppColors.lightBlueColor,
            AppColors.lightBlueColor.withValues(alpha: 0.95),
          ],
          iconPath: SvgAssets.successIcon, // Using success icon for info
          iconColor: AppColors.blueColor,
          iconBackgroundColor: AppColors.blueColor.withValues(alpha: 0.2),
          titleColor: AppColors.blueColor,
          messageColor: AppColors.blueColor.withValues(alpha: 0.9),
          closeIconColor: AppColors.blueColor.withValues(alpha: 0.7),
          shadowColor: AppColors.blueColor,
          defaultTitle: "Info",
        );
    }
  }
}

class _NotificationConfig {
  final List<Color> gradientColors;
  final String iconPath;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color titleColor;
  final Color messageColor;
  final Color closeIconColor;
  final Color shadowColor;
  final String defaultTitle;

  _NotificationConfig({
    required this.gradientColors,
    required this.iconPath,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.titleColor,
    required this.messageColor,
    required this.closeIconColor,
    required this.shadowColor,
    required this.defaultTitle,
  });
}
