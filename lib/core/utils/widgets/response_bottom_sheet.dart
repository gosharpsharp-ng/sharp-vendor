import 'package:sharpvendor/core/utils/exports.dart';

// Track if a bottom sheet is currently showing
bool _isBottomSheetShowing = false;

/// Shows a beautiful success bottom sheet
/// Ensures only one bottom sheet appears at a time
void showSuccessBottomSheet({
  required String title,
  required String message,
  String buttonText = "Continue",
  VoidCallback? onButtonPressed,
}) {
  if (_isBottomSheetShowing) {
    Get.back();
  }

  _isBottomSheetShowing = true;

  Get.bottomSheet(
    SuccessBottomSheet(
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
  ).whenComplete(() {
    _isBottomSheetShowing = false;
  });
}

/// Shows a beautiful error bottom sheet
/// Ensures only one bottom sheet appears at a time
void showErrorBottomSheet({
  required String title,
  required String message,
  String buttonText = "Try Again",
  VoidCallback? onButtonPressed,
}) {
  if (_isBottomSheetShowing) {
    Get.back();
  }

  _isBottomSheetShowing = true;

  Get.bottomSheet(
    ErrorBottomSheet(
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
  ).whenComplete(() {
    _isBottomSheetShowing = false;
  });
}

class SuccessBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const SuccessBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = "Continue",
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              children: [
                // Success icon
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 32.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Title
                customText(
                  title,
                  textAlign: TextAlign.center,
                  color: AppColors.blackColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),

                SizedBox(height: 8.h),

                // Message
                customText(
                  message,
                  overflow: TextOverflow.visible,
                  color: AppColors.greyColor,
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),

                SizedBox(height: 24.h),

                // Button
                CustomButton(
                  onPressed: () {
                    Get.back();
                    onButtonPressed?.call();
                  },
                  title: buttonText,
                  width: 1.sw,
                  backgroundColor: AppColors.greenColor,
                  fontColor: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const ErrorBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = "Try Again",
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              children: [
                // Error icon
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: AppColors.redColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: 32.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Title
                customText(
                  title,
                  textAlign: TextAlign.center,
                  color: AppColors.redColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),

                SizedBox(height: 8.h),

                // Message
                customText(
                  message,
                  overflow: TextOverflow.visible,
                  color: AppColors.greyColor,
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),

                SizedBox(height: 24.h),

                // Button
                CustomButton(
                  onPressed: () {
                    Get.back();
                    onButtonPressed?.call();
                  },
                  title: buttonText,
                  width: 1.sw,
                  backgroundColor: AppColors.redColor,
                  fontColor: AppColors.whiteColor,
                ),

                SizedBox(height: 8.h),

                // Dismiss button
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: customText(
                    "Dismiss",
                    color: AppColors.greyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
