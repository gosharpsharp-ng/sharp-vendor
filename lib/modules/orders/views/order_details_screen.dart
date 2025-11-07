import 'package:sharpvendor/core/models/order_model.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';
import 'package:sharpvendor/modules/orders/views/widgets/order_detail_summary_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/exports.dart';

class OrderDetailsScreen extends GetView<OrdersController> {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (ordersController) {
        final order = ordersController.selectedOrder;

        if (order == null) {
          return Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () => Get.back(),
              title: "Order Details",
            ),
            body: const Center(child: Text("Order not found")),
          );
        }

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Order Details",
            implyLeading: true,
            centerTitle: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Main Order Details Section
                  SectionBox(
                    children: [
                      OrderDetailSummaryItem(
                        title: "Order Number",
                        value: order.orderNumber,
                      ),
                      OrderDetailSummaryStatusItem(
                        title: "Status",
                        value: _getStatusDisplayText(order.status),
                        status: order.status,
                      ),
                      OrderDetailSummaryItem(
                        title: "Total",
                        value: formatToCurrency(order.total),
                      ),
                      OrderDetailSummaryItem(
                        title: "Order Date",
                        value:
                            "${formatDate(order.createdAt.toIso8601String())} ${formatTime(order.createdAt.toIso8601String())}",
                      ),
                      if (order.paymentMethod != null)
                        OrderDetailSummaryItem(
                          title: "Payment Method",
                          value: order.paymentMethodName,
                        ),
                      if (order.notes.isNotEmpty)
                        OrderDetailSummaryItem(
                          title: "Notes",
                          value: order.notes,
                          isVertical: true,
                        ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Order Items Section
                  if (order.packages.isNotEmpty)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Order Items (${order.packages.length} Package${order.packages.length > 1 ? 's' : ''})",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Display packages
                        ...order.packages.map((package) {
                          return Column(
                            children: [
                              // Package header
                              OrderDetailPackageItem(
                                packageName: package.name,
                                quantity: package.quantity,
                                price: formatToCurrency(package.total),
                              ),
                              SizedBox(height: 4.h),

                              // Package items
                              ...package.items.map((item) {
                                return OrderDetailMenuItem(
                                  name: item.menu.name,
                                  imageUrl: item.menu.files.isNotEmpty
                                      ? item.menu.files.first.url
                                      : null,
                                  quantity: item.quantity,
                                  price: formatToCurrency(item.total),
                                  description: item.menu.description,
                                  plateSize: item.menu.plateSize,
                                );
                              }).toList(),

                              SizedBox(height: 8.h),
                            ],
                          );
                        }).toList(),
                      ],
                    )
                  else if (order.allItems.isNotEmpty)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Order Items (${order.allItems.length})",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Display all items
                        ...order.allItems.map((item) {
                          return OrderDetailMenuItem(
                            name: item.name,
                            imageUrl: item.image,
                            quantity: item.quantity,
                            price: formatToCurrency(item.total),
                            description: item.description,
                            plateSize: item.plateSize,
                          );
                        }).toList(),
                      ],
                    ),

                  SizedBox(height: 12.h),

                  // Price Breakdown Section
                  SectionBox(
                    children: [
                      // Section Header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 12.h,
                        ),
                        child: customText(
                          "Price Breakdown",
                          fontSize: 16.sp,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      OrderDetailSummaryItem(
                        title: "Subtotal",
                        value: formatToCurrency(order.subtotal),
                      ),
                      if (order.tax > 0)
                        OrderDetailSummaryItem(
                          title: "Tax",
                          value: formatToCurrency(order.tax),
                        ),
                      if (order.deliveryFee > 0)
                        OrderDetailSummaryItem(
                          title: "Delivery Fee",
                          value: formatToCurrency(order.deliveryFee),
                        ),
                      if (order.discountAmount > 0)
                        OrderDetailSummaryItem(
                          title: "Discount",
                          value: "- ${formatToCurrency(order.discountAmount)}",
                        ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        height: 1,
                        color: AppColors.greyColor.withOpacity(0.2),
                      ),
                      OrderDetailSummaryItem(
                        title: "Total",
                        value: formatToCurrency(order.total),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Customer Information Section
                  if (order.user != null)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                "Customer Information",
                                fontSize: 16.sp,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                              // Call button
                              InkWell(
                                onTap: () => _callCustomer(order.customerPhone),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: AppColors.primaryColor,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      customText(
                                        "Call",
                                        color: AppColors.primaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        OrderDetailSummaryItem(
                          title: "Name",
                          value: order.customerName,
                        ),
                        OrderDetailSummaryItem(
                          title: "Phone",
                          value: order.customerPhone,
                        ),
                        if (order.customerEmail.isNotEmpty)
                          OrderDetailSummaryItem(
                            title: "Email",
                            value: order.customerEmail,
                          ),
                      ],
                    ),

                  SizedBox(height: 12.h),

                  // Delivery Information Section
                  if (order.deliveryLocation != null)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Delivery Information",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        OrderDetailSummaryItem(
                          title: "Delivery Type",
                          value: order.deliveryType.toUpperCase(),
                        ),
                        OrderDetailSummaryItem(
                          title: "Delivery Address",
                          value: order.deliveryLocation!.name,
                          isVertical: true,
                        ),
                        if (order.deliveryInstructions != null &&
                            order.deliveryInstructions!.isNotEmpty)
                          OrderDetailSummaryItem(
                            title: "Delivery Instructions",
                            value: order.deliveryInstructions!,
                            isVertical: true,
                          ),
                      ],
                    ),

                  SizedBox(height: 12.h),

                  // Order Status Actions - Updated to match business requirements:
                  // - paid: show Accept and Reject buttons
                  // - preparing: show Mark as Ready button
                  // - ready/in_transit: no restaurant actions (informational only)
                  // - rejected/completed/cancelled: no actions
                  if (![
                    'ready',
                    'in_transit',
                    'completed',
                    'cancelled',
                    'rejected',
                  ].contains(order.status.toLowerCase()))
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Order Actions",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // For "paid" status: show Accept and Reject buttons side by side
                        if (order.status.toLowerCase() == 'paid')
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 8.h,
                            ),
                            child: Row(
                              children: [
                                // Reject Button
                                Expanded(
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12.r),
                                        onTap: ordersController.isLoading
                                            ? null
                                            : () => _showRejectOrderDialog(
                                                ordersController,
                                                order,
                                              ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.red,
                                              size: 18.sp,
                                            ),
                                            SizedBox(width: 8.w),
                                            customText(
                                              "Reject",
                                              color: Colors.red,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                // Accept Button
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.greenColor,
                                          AppColors.greenColor.withOpacity(0.8),
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
                                            : () => ordersController.acceptOrder(order.id),
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
                                                      Icons.check_circle_outline,
                                                      color: AppColors.whiteColor,
                                                      size: 20.sp,
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    customText(
                                                      "Accept Order",
                                                      color: AppColors.whiteColor,
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // For "preparing" status: show Mark as Ready button
                        if (order.status.toLowerCase() == 'preparing')
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 8.h,
                            ),
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.blue.withOpacity(0.8),
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
                                    : () => ordersController.markOrderReady(order.id),
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
                                              Icons.restaurant_menu,
                                              color: AppColors.whiteColor,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 12.w),
                                            customText(
                                              "Mark as Ready",
                                              color: AppColors.whiteColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                  // Show info message for "ready" status (waiting for rider pickup)
                  if (order.status.toLowerCase() == 'ready')
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.sp),
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.greenColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.greenColor,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  "Order is Ready",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.greenColor,
                                ),
                                SizedBox(height: 4.h),
                                customText(
                                  "The order is ready and waiting for rider pickup. No further actions required from restaurant.",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Show info message for "in_transit" status (rider picked up)
                  if (order.status.toLowerCase() == 'in_transit')
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.sp),
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            color: AppColors.primaryColor,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  "Order In Transit",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(height: 4.h),
                                customText(
                                  "The order is on its way to the customer. Rider is currently delivering the order.",
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
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
            ),
          ),
        );
      },
    );
  }

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'in_transit':
        return 'In Transit';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  void _showRejectOrderDialog(OrdersController controller, OrderModel order) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(24.sp),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customText(
              "Reject Order?",
              color: AppColors.blackColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            customText(
              "Are you sure you want to reject this order? This action cannot be undone and the customer will be notified.",
              color: AppColors.greyColor,
              fontSize: 14.sp,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () => Get.back(),
                    title: "Cancel",
                    backgroundColor: AppColors.greyColor.withOpacity(0.2),
                    fontColor: AppColors.blackColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Get.back();
                      controller.rejectOrder(order.id);
                    },
                    title: "Reject",
                    backgroundColor: Colors.red,
                    fontColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _callCustomer(String phoneNumber) async {
    try {
      // Remove any non-numeric characters except + for international format
      String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Ensure the number starts with a + for international format
      if (!cleanedNumber.startsWith('+')) {
        // Assuming Nigerian numbers, add country code if not present
        if (cleanedNumber.startsWith('0')) {
          cleanedNumber = '+234${cleanedNumber.substring(1)}';
        } else if (cleanedNumber.length == 10) {
          cleanedNumber = '+234$cleanedNumber';
        } else {
          cleanedNumber = '+$cleanedNumber';
        }
      }

      final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        showToast(
          message:
              "Unable to make phone call. Please try again or contact manually: $cleanedNumber",
          isError: true,
        );
      }
    } catch (e) {
      showToast(
        message: "Error initiating phone call: ${e.toString()}",
        isError: true,
      );
    }
  }
}
