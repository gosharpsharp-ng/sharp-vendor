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
          appBar: AppBar(
            backgroundColor: _getStatusColor(order.status),
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
            ),
            title: customText(
              "Order #${order.ref}",
              color: AppColors.whiteColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 100.h), // Bottom padding for action buttons
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Status Card
                    _buildStatusCard(order, ordersController),

                    SizedBox(height: 20.h),

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
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              "Customer Information",
                              color: AppColors.blackColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            // Call customer button moved near customer info
                            InkWell(
                              onTap: () {
                                _callCustomer(_getCustomerPhone(order));
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: AppColors.primaryColor,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    customText(
                                      "Call",
                                      color: AppColors.primaryColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        Row(
                          children: [
                            // Enhanced customer avatar with placeholder image support
                            _buildCustomerAvatar(order),
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

                  // Enhanced Order Actions Section - Integrated
                  if (!['completed', 'cancelled'].contains(order.status.toLowerCase())) ...[
                    Container(
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.whiteColor,
                            AppColors.backgroundColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: _getStatusColor(order.status).withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(order.status).withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status header with current status
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  _getStatusIcon(order.status),
                                  color: _getStatusColor(order.status),
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      "Order Actions",
                                      color: AppColors.blackColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(height: 2.h),
                                    customText(
                                      "Current: ${_getStatusDisplayText(order.status)}",
                                      color: _getStatusColor(order.status),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20.h),

                          // Primary Action Button
                          _buildPrimaryActionButton(ordersController, order),

                          SizedBox(height: 16.h),

                          // Secondary Actions
                          _buildSecondaryActions(ordersController, order),

                          // Additional Status Options
                          if (_hasMultipleStatusOptions(order)) ...[
                            SizedBox(height: 16.h),
                            Divider(color: AppColors.greyColor.withOpacity(0.3)),
                            SizedBox(height: 12.h),
                            customText(
                              "Quick Status Updates",
                              color: AppColors.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 12.h),
                            _buildStatusUpdateButtons(ordersController, order),
                          ],
                        ],
                      ),
                    ),
                  ],

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

                      SizedBox(height: 40.h), // Standard bottom spacing
                    ],
                  ),
                ),

              // Fixed Action Buttons at Bottom
              if (!['completed', 'cancelled'].contains(order.status.toLowerCase()))
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Primary Action Button
                            Container(
                              width: double.infinity,
                              height: 56.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getStatusColor(order.status),
                                    _getStatusColor(order.status).withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(order.status).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: ordersController.isLoading ? null : () {
                                    _handlePrimaryAction(ordersController, order);
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              _getNextActionIcon(order.status),
                                              color: AppColors.whiteColor,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 12.w),
                                            customText(
                                              ordersController.getNextAction(order.status),
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

                            // Secondary Action for Pending Orders
                            if (order.status.toLowerCase() == 'pending') ...[
                              SizedBox(height: 12.h),
                              Container(
                                width: double.infinity,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12.r),
                                    onTap: () {
                                      _showRejectOrderDialog(ordersController, order);
                                    },
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
                                          "Reject Order",
                                          color: Colors.red,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // Build status card widget
  Widget _buildStatusCard(OrderModel order, OrdersController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor(order.status),
            _getStatusColor(order.status).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(order.status).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(order.status),
                  color: AppColors.whiteColor,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      _getStatusDisplayText(order.status),
                      color: AppColors.whiteColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 4.h),
                    customText(
                      "Placed ${controller.formatOrderTime(order.createdAt)}",
                      color: AppColors.whiteColor.withOpacity(0.9),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.whiteColor.withOpacity(0.3), thickness: 1),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    "Total Amount",
                    color: AppColors.whiteColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 4.h),
                  customText(
                    controller.formatCurrency(order.total),
                    color: AppColors.whiteColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customText(
                    "Items",
                    color: AppColors.whiteColor.withOpacity(0.8),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 4.h),
                  customText(
                    "${order.items.length} item${order.items.length > 1 ? 's' : ''}",
                    color: AppColors.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundColor.withOpacity(0.0),
            AppColors.backgroundColor.withOpacity(0.8),
            AppColors.backgroundColor,
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
        padding: EdgeInsets.all(20.sp),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order status indicator
              _buildOrderStatusIndicator(order),

              SizedBox(height: 20.h),

              // Primary action button with enhanced design
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: controller.isLoading ? null : () {
                      _handlePrimaryAction(controller, order);
                    },
                    child: Container(
                      width: 1.sw,
                      height: 56.h,
                      child: Stack(
                        children: [
                          Center(
                            child: controller.isLoading
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _getNextActionIcon(order.status),
                                      color: AppColors.whiteColor,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    customText(
                                      controller.getNextAction(order.status),
                                      color: AppColors.whiteColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Secondary action for pending orders (reject only)
              if (order.status.toLowerCase() == 'pending') ...[
                SizedBox(height: 12.h),
                InkWell(
                  onTap: () {
                    _showRejectOrderDialog(controller, order);
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 1.sw,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
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
                          "Reject Order",
                          color: Colors.red,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Build order status indicator for bottom sheet
  Widget _buildOrderStatusIndicator(OrderModel order) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _getStatusColor(order.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _getStatusColor(order.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: _getStatusColor(order.status),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          customText(
            "Current: ${_getStatusDisplayText(order.status)}",
            color: _getStatusColor(order.status),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  // Get icon for next action
  IconData _getNextActionIcon(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return Icons.restaurant_menu;
      case 'preparing':
        return Icons.check_circle_outline;
      case 'ready':
        return Icons.local_shipping_outlined;
      case 'in_transit':
        return Icons.done_all;
      default:
        return Icons.arrow_forward;
    }
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

  // Build customer avatar with support for actual avatars
  Widget _buildCustomerAvatar(OrderModel order) {
    // TODO: Get actual customer avatar URL from API using order.userId
    String? avatarUrl; // This should come from customer API

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      // Display actual customer avatar
      return Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(avatarUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Display placeholder avatar with initial
      return Container(
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
      );
    }
  }

  // Check if order has multiple status options
  bool _hasMultipleStatusOptions(OrderModel order) {
    List<String> availableStatuses = [];

    // Define next possible statuses based on current status
    switch (order.status.toLowerCase()) {
      case 'paid':
      case 'pending':
        availableStatuses = ['preparing', 'cancelled'];
        break;
      case 'preparing':
        availableStatuses = ['ready', 'cancelled'];
        break;
      case 'ready':
        availableStatuses = ['in_transit', 'completed'];
        break;
      case 'in_transit':
        availableStatuses = ['completed'];
        break;
    }

    return availableStatuses.length > 1;
  }

  // Build status update buttons
  Widget _buildStatusUpdateButtons(OrdersController controller, OrderModel order) {
    List<String> availableStatuses = [];

    // Define next possible statuses based on current status
    switch (order.status.toLowerCase()) {
      case 'paid':
      case 'pending':
        availableStatuses = ['preparing', 'cancelled'];
        break;
      case 'preparing':
        availableStatuses = ['ready', 'cancelled'];
        break;
      case 'ready':
        availableStatuses = ['in_transit', 'completed'];
        break;
      case 'in_transit':
        availableStatuses = ['completed'];
        break;
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: availableStatuses.map((status) {
        return _buildStatusButton(controller, order, status);
      }).toList(),
    );
  }

  // Build individual status button
  Widget _buildStatusButton(OrdersController controller, OrderModel order, String status) {
    Color buttonColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'preparing':
        buttonColor = Colors.blue.shade50;
        textColor = Colors.blue;
        icon = Icons.restaurant;
        break;
      case 'ready':
        buttonColor = AppColors.primaryColor.withOpacity(0.1);
        textColor = AppColors.primaryColor;
        icon = Icons.check_circle_outline;
        break;
      case 'in_transit':
        buttonColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        icon = Icons.local_shipping_outlined;
        break;
      case 'completed':
        buttonColor = Colors.green.shade50;
        textColor = Colors.green;
        icon = Icons.done_all;
        break;
      case 'cancelled':
        buttonColor = Colors.red.shade50;
        textColor = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      default:
        buttonColor = AppColors.greyColor.withOpacity(0.1);
        textColor = AppColors.blackColor;
        icon = Icons.update;
    }

    return InkWell(
      onTap: () {
        if (status == 'cancelled') {
          _showCancelOrderDialog(controller, order);
        } else {
          _showStatusUpdateDialog(controller, order, status);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.sp, color: textColor),
            SizedBox(width: 6.w),
            customText(
              _getStatusDisplayText(status),
              color: textColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  // Show status update confirmation dialog
  void _showStatusUpdateDialog(OrdersController controller, OrderModel order, String newStatus) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(24.sp),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStatusIcon(newStatus),
              color: _getStatusColor(newStatus),
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            customText(
              "Update Order Status",
              color: AppColors.blackColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            customText(
              "Change order status from ${_getStatusDisplayText(order.status)} to ${_getStatusDisplayText(newStatus)}?",
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
                      controller.updateOrderStatus(order.id, newStatus);
                    },
                    title: "Update",
                    backgroundColor: _getStatusColor(newStatus),
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

  // Show cancel order confirmation dialog
  void _showCancelOrderDialog(OrdersController controller, OrderModel order) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        contentPadding: EdgeInsets.all(24.sp),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cancel,
              color: Colors.red,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            customText(
              "Cancel Order?",
              color: AppColors.blackColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            customText(
              "Are you sure you want to cancel this order? This action cannot be undone and the customer will be notified.",
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
                    title: "Keep Order",
                    backgroundColor: AppColors.greyColor.withOpacity(0.2),
                    fontColor: AppColors.blackColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Get.back();
                      controller.updateOrderStatus(order.id, 'cancelled');
                    },
                    title: "Cancel Order",
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

  // Build primary action button for the enhanced actions section
  Widget _buildPrimaryActionButton(OrdersController controller, OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor(order.status),
            _getStatusColor(order.status).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(order.status).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: controller.isLoading ? null : () {
            _handlePrimaryAction(controller, order);
          },
          child: Container(
            width: 1.sw,
            height: 60.h,
            child: Stack(
              children: [
                Center(
                  child: controller.isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: AppColors.whiteColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getNextActionIcon(order.status),
                              color: AppColors.whiteColor,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                controller.getNextAction(order.status),
                                color: AppColors.whiteColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              customText(
                                "Tap to update order status",
                                color: AppColors.whiteColor.withOpacity(0.8),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build secondary actions for the enhanced actions section
  Widget _buildSecondaryActions(OrdersController controller, OrderModel order) {
    if (order.status.toLowerCase() == 'pending') {
      return InkWell(
        onTap: () {
          _showRejectOrderDialog(controller, order);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 1.sw,
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.red.withOpacity(0.3),
              width: 1,
            ),
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
                "Reject Order",
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      );
    }

    // For non-pending orders, show a subtle note about status progression
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.greyColor,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: customText(
              "Use the main button above or quick actions below to update order status",
              color: AppColors.greyColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
