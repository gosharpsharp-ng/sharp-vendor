import 'package:sharpvendor/core/models/order_model.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';
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
          backgroundColor: AppColors.backgroundColor,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildActionButtons(ordersController, order),
          body: CustomScrollView(
            slivers: [
              // Beautiful App Bar with Status
              SliverAppBar(
                expandedHeight: 140.h,
                floating: false,
                pinned: true,
                backgroundColor: _getStatusColor(order.status),
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getStatusColor(order.status),
                          _getStatusColor(order.status).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(22.w, 60.h, 22.w, 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getStatusIcon(order.status),
                                  color: AppColors.whiteColor,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: customText(
                                    "Order #${order.ref}",
                                    color: AppColors.whiteColor,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            customText(
                              "Placed ${ordersController.formatOrderTime(order.createdAt)} • ${_getStatusDisplayText(order.status)}",
                              color: AppColors.whiteColor.withOpacity(0.9),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 22.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),

                  // Order Items Section
                  Container(
                    padding: EdgeInsets.symmetric(vertical:16.sp,horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              "Order Items",
                              color: AppColors.blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            customText(
                              "${order.items.length} item${order.items.length > 1 ? 's' : ''}",
                              color: AppColors.greyColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Items list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.items.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 24.h,color: AppColors.greyColor,thickness: 0.2,),
                          itemBuilder: (context, index) {
                            final item = order.items[index];
                            return _buildOrderItem(item);
                          },
                        ),

                        if (order.notes.isNotEmpty) ...[
                          Divider(height: 24.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.note_outlined,
                                color: AppColors.greyColor,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      "Special Instructions",
                                      color: AppColors.blackColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    SizedBox(height: 4.h),
                                    customText(
                                      order.notes,
                                      color: AppColors.greyColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],

                        Divider(height: 24.h,color: AppColors.greyColor,thickness: 0.2,),

                        // Order total breakdown
                        Column(
                          children: [
                            _buildPriceRow("Subtotal", order.subtotal),
                            if (order.tax > 0) _buildPriceRow("Tax", order.tax),
                            if (order.deliveryFee > 0)
                              _buildPriceRow("Delivery Fee", order.deliveryFee),
                            if (order.discountAmount > 0)
                              _buildPriceRow(
                                "Discount",
                                -order.discountAmount,
                                isDiscount: true,
                              ),
                            Divider(height: 16.h,color: AppColors.greyColor,thickness: 0.2,),
                            _buildPriceRow("Total", order.total, isTotal: true),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Customer Information Section
                  Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.05),
                      //     blurRadius: 10,
                      //     offset: const Offset(0, 2),
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Customer Information",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),

                        SizedBox(height: 16.h),

                        Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: customText(
                                  _getCustomerInitial(order),
                                  color: AppColors.primaryColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    _getCustomerName(order),
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 2.h),
                                  customText(
                                    _getCustomerPhone(order),
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  if (_getCustomerEmail(order).isNotEmpty) ...[
                                    SizedBox(height: 2.h),
                                    customText(
                                      _getCustomerEmail(order),
                                      color: AppColors.greyColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ],
                                ],
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Delivery Address Section
                  if (order.deliveryLocation != null) ...[
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.05),
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 2),
                        //   ),
                        // ],
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
                                  order.deliveryLocation!.name,
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
                    SizedBox(height: 20.h),
                  ],

                  // Payment Information Section
                  if (order.paymentReference.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.05),
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 2),
                        //   ),
                        // ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            "Payment Information",
                            color: AppColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),

                          SizedBox(height: 12.h),

                          _buildInfoRow(
                            "Payment Reference",
                            order.paymentReference,
                          ),
                          SizedBox(height: 8.h),
                          _buildInfoRow(
                            "Payment Status",
                            "Paid",
                          ), // Assuming paid if reference exists
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],

                      SizedBox(height: 100.h), // Space for bottom buttons
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(OrderItemModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item image placeholder
       item.orderable.files.isNotEmpty?Container(
         width: 50.w,
         height: 50.h,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(8.r),
           image: DecorationImage(image:NetworkImage(item.orderable.files[0].url))
         ),
         child: Icon(Icons.fastfood, color: AppColors.greyColor, size: 24.sp),
       ): Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.greyColor.withOpacity(0.1),
          ),
          child: Icon(Icons.fastfood, color: AppColors.greyColor, size: 24.sp),
        ),

        SizedBox(width: 12.w),

        // Item details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                item.orderable.name,
                color: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.h),
              if (item.orderable.description.isNotEmpty)
                customText(
                  item.orderable.description,
                  color: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  customText(
                    "Qty: ${item.quantity}",
                    color: AppColors.greyColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  if (item.orderable.plateSize.isNotEmpty) ...[
                    customText(
                      " • ",
                      color: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    customText(
                      "Size: ${item.orderable.plateSize}",
                      color: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ],
              ),
              if (item.options != null && item.options!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                ...item.options!.entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: customText(
                          "${entry.key}: ${entry.value}",
                          color: AppColors.primaryColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                    .toList(),
              ],
            ],
          ),
        ),

        SizedBox(width: 8.w),

        // Item price
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            customText(
              Get.find<OrdersController>().formatCurrency(item.total),
              color: AppColors.blackColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            if (item.quantity > 1)
              customText(
                "${Get.find<OrdersController>().formatCurrency(item.price)} each",
                color: AppColors.greyColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.normal,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            label,
            color: isTotal ? AppColors.blackColor : AppColors.greyColor,
            fontSize: isTotal ? 14.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
          customText(
            "${isDiscount ? '-' : ''}${Get.find<OrdersController>().formatCurrency(amount.abs())}",
            color: isDiscount
                ? Colors.green
                : (isTotal ? AppColors.blackColor : AppColors.greyColor),
            fontSize: isTotal ? 14.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          color: AppColors.greyColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
        ),
        Expanded(
          child: customText(
            value,
            color: AppColors.blackColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(OrdersController controller, OrderModel order) {
    // Don't show buttons for completed/cancelled orders
    if (['completed', 'cancelled'].contains(order.status.toLowerCase())) {
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
                        _callCustomer(_getCustomerPhone(order));
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
                  _callCustomer(_getCustomerPhone(order));
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
      case 'preparing':
        controller.markOrderReady(order.id);
        break;
      case 'ready':
        controller.markOrderInTransit(order.id);
        break;
      case 'in_transit':
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
          message: "Unable to make phone call. Please try again or contact manually: $cleanedNumber",
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

  // Helper methods for customer information
  // TODO: Implement proper customer information retrieval
  // Option 1: Add customer info to order API response
  // Option 2: Create API endpoint to fetch customer by user ID
  // For now using placeholder information based on order.userId

  String _getCustomerName(OrderModel order) {
    // TODO: Fetch actual customer name from API using order.userId
    // Currently showing placeholder customer name
    return "Customer #${order.userId}";
  }

  String _getCustomerPhone(OrderModel order) {
    // TODO: Fetch actual customer phone from API using order.userId
    // For testing purposes, using a placeholder phone number
    // This should be replaced with real customer data from the backend
    return "+234800000000${order.userId.toString().padLeft(4, '0').substring(0, 4)}";
  }

  String _getCustomerEmail(OrderModel order) {
    // TODO: Fetch actual customer email from API using order.userId
    // Currently showing placeholder email
    return "customer${order.userId}@example.com";
  }

  String _getCustomerInitial(OrderModel order) {
    // TODO: Use actual customer name initial when available
    return "C";
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppColors.greenColor;
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return AppColors.greenColor;
      case 'in_transit':
        return AppColors.primaryColor;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.payment;
      case 'pending':
        return Icons.schedule;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.check_circle;
      case 'in_transit':
        return Icons.local_shipping;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }
}
