import 'package:sharpvendor/core/models/order_model.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';
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
            body: const Center(
              child: Text("Order not found"),
            ),
          );
        }

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            onPop: () => Get.back(),
            title: "Order Details",
          ),
          backgroundColor: AppColors.backgroundColor,
          bottomNavigationBar: _buildActionButtons(ordersController, order),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 20.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customText(
                        "Order #${order.id}",
                        color: AppColors.blackColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: customText(
                          order.status,
                          color: _getStatusColor(order.status),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Order Items Section
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Order Items",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),

                        SizedBox(height: 16.h),

                        // Items list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.items.length,
                          separatorBuilder: (context, index) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final item = order.items[index];
                            return _buildOrderItem(item);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Order Information Section
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Order Information",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),

                        SizedBox(height: 16.h),

                        // Customer info
                        _buildInfoRow("Customer", order.customerName),
                        SizedBox(height: 12.h),
                        _buildInfoRow("Phone", order.customerPhone),
                        SizedBox(height: 12.h),
                        _buildInfoRow("Order Time", ordersController.formatOrderTime(order.orderDate)),
                        SizedBox(height: 12.h),
                        _buildInfoRow("Total Items", order.totalItems.toString()),
                        SizedBox(height: 12.h),
                        _buildInfoRow("Total", ordersController.formatCurrency(order.total)),
                        SizedBox(height: 12.h),
                        _buildInfoRow("Estimated Delivery", order.estimatedDeliveryTime),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Delivery Address Section
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Delivery Address",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),

                        SizedBox(height: 12.h),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: customText(
                                order.deliveryAddress,
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100.h), // Space for bottom buttons
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(OrderItemModel item) {
    return Row(
      children: [
        // Item image
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.greyColor.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.greyColor.withOpacity(0.2),
                  child: Icon(
                    Icons.fastfood,
                    color: AppColors.greyColor,
                    size: 24.sp,
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Item details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                item.name,
                color: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              customText(
                "${item.quantity}x",
                color: AppColors.greyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.normal,
              ),
              if (item.specialInstructions.isNotEmpty) ...[
                SizedBox(height: 4.h),
                customText(
                  "Note: ${item.specialInstructions}",
                  color: AppColors.primaryColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
              ],
            ],
          ),
        ),

        // Item price
        customText(
          Get.find<OrdersController>().formatCurrency(item.price * item.quantity),
          color: AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          color: AppColors.greyColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
        customText(
          value,
          color: AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildActionButtons(OrdersController controller, OrderModel order) {
    // Don't show buttons for completed orders
    if (order.status.toLowerCase() == 'completed') {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary action button
            CustomButton(
              onPressed: () {
                _handlePrimaryAction(controller, order);
              },
              isBusy: controller.isLoading,
              title: controller.getNextAction(order.status),
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),

            // Secondary actions for pending orders
            if (order.status.toLowerCase() == 'pending') ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        _showRejectOrderDialog(controller, order);
                      },
                      title: "Reject",
                      backgroundColor: Colors.red.shade50,
                      fontColor: Colors.red,
                      borderColor: Colors.red,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        // Call customer functionality
                        _callCustomer(order.customerPhone);
                      },
                      title: "Call Customer",
                      backgroundColor: AppColors.whiteColor,
                      fontColor: AppColors.blackColor,
                      borderColor: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ],

            // Call customer button for other statuses
            if (order.status.toLowerCase() != 'pending') ...[
              SizedBox(height: 12.h),
              CustomButton(
                onPressed: () {
                  _callCustomer(order.customerPhone);
                },
                title: "Call Customer",
                width: 1.sw,
                backgroundColor: AppColors.whiteColor,
                fontColor: AppColors.blackColor,
                borderColor: AppColors.greyColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handlePrimaryAction(OrdersController controller, OrderModel order) {
    switch (order.status.toLowerCase()) {
      case 'pending':
        controller.acceptOrder(order.id);
        break;
      case 'accepted':
        controller.startProcessingOrder(order.id);
        break;
      case 'processing':
        controller.markOrderReady(order.id);
        break;
      case 'ready':
        controller.completeOrder(order.id);
        Get.back(); // Go back to orders list after completion
        break;
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

  void _callCustomer(String phoneNumber) {
    // TODO: Implement phone call functionality
    // You can use url_launcher package to make phone calls
    showToast(message: "Calling $phoneNumber", isError: false);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'processing':
        return AppColors.primaryColor;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return AppColors.greyColor;
    }
  }
}