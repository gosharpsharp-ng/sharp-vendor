import 'package:sharpvendor/core/utils/exports.dart';

class OrderAcceptanceResultScreen extends StatelessWidget {
  const OrderAcceptanceResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final bool isSuccess = args?['isSuccess'] ?? false;
    final String orderNumber = args?['orderNumber'] ?? '';
    final String amount = args?['amount'] ?? '';
    final String message = args?['message'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Status icon
              Container(
                width: 120.sp,
                height: 120.sp,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? const Color(0xFF2E7D32).withValues(alpha:0.1)
                      : const Color(0xFFD32F2F).withValues(alpha:0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    size: 80.sp,
                    color: isSuccess
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD32F2F),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Title
              customText(
                isSuccess ? 'Order Accepted!' : 'Acceptance Failed',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isSuccess
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFD32F2F),
              ),
              SizedBox(height: 12.h),

              // Subtitle message
              customText(
                isSuccess
                    ? 'You have successfully accepted this order. Start preparing it now.'
                    : message,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.obscureTextColor,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 28.h),

              // Order details card
              if (isSuccess && orderNumber.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            'Order Number',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.obscureTextColor,
                          ),
                          customText(
                            orderNumber,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                      if (amount.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        Divider(color: AppColors.greyColor.withValues(alpha:0.2)),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              'Amount',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.obscureTextColor,
                            ),
                            customText(
                              amount,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

              const Spacer(),

              // Primary action
              CustomButton(
                onPressed: () {
                  if (isSuccess) {
                    Get.offAllNamed(
                      Routes.APP_NAVIGATION,
                      arguments: {'initialIndex': 2},
                    );
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Get.toNamed(Routes.ORDER_DETAILS_SCREEN);
                    });
                  } else {
                    Get.back();
                  }
                },
                title: isSuccess ? 'View Order' : 'Go Back',
                width: double.infinity,
                backgroundColor: isSuccess
                    ? const Color(0xFF2E7D32)
                    : AppColors.greyColor,
              ),
              SizedBox(height: 16.h),

              // Secondary action for success
              if (isSuccess)
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(
                      Routes.APP_NAVIGATION,
                      arguments: {'initialIndex': 2},
                    );
                  },
                  child: customText(
                    'Back to Orders',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
