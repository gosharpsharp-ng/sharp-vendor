import 'package:sharpvendor/core/utils/exports.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (notificationsController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Notification Details",
            centerTitle: false,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Title
                  customText(
                    notificationsController.selectedNotification?.title ??
                        "No Title",
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    overflow: TextOverflow.visible,
                  ),

                  SizedBox(height: 16.h),

                  // Notification Date/Time
                  if (notificationsController.selectedNotification?.createdAt !=
                      null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: customText(
                        "Received: ${_formatDate(notificationsController.selectedNotification!.createdAt)}",
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),

                  SizedBox(height: 20.h),

                  // Notification Message/Body
                  customText(
                    notificationsController.selectedNotification?.message ??
                        "No message content available",
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                    overflow: TextOverflow.visible,
                    height: 1.5,
                  ),

                  SizedBox(height: 30.h),

                  // View Order Details Button - Show only if notification is about an order
                  if (_isOrderNotification(
                    notificationsController.selectedNotification,
                  ))
                    GetBuilder<OrdersController>(
                      builder: (ordersController) {
                        return Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: ordersController.isLoading
                                  ? null
                                  : () async {
                                      final orderId = notificationsController
                                          .selectedNotification!
                                          .notifiableId;
                                      final order = await ordersController
                                          .getOrderById(orderId);
                                      if (order != null) {
                                        Get.toNamed(
                                          Routes.ORDER_DETAILS_SCREEN,
                                        );
                                      } else {
                                        showToast(
                                          message:
                                              "Unable to load order details. Please try again.",
                                          isError: true,
                                        );
                                      }
                                    },
                              child: Center(
                                child: ordersController.isLoading
                                    ? SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: CircularProgressIndicator(
                                          color: AppColors.whiteColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.receipt_long,
                                            color: AppColors.whiteColor,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 12.w),
                                          customText(
                                            "View Order Details",
                                            color: AppColors.whiteColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isOrderNotification(NotificationModel? notification) {
    if (notification == null) return false;
    // Check if the notification is related to an order
    // Typically order notifications have notifiableType like "App\\Models\\Order" or similar
    return notification.notifiableType.toLowerCase().contains('order');
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }
}
