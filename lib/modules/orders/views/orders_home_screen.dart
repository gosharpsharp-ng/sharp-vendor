import 'package:sharpvendor/core/models/order_model.dart';
import 'package:sharpvendor/modules/orders/controllers/orders_controller.dart';
import '../../../core/utils/exports.dart';

class OrdersHomeScreen extends GetView<OrdersController> {
  const OrdersHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (ordersController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            implyLeading: false,
            centerTitle: true,
            title: "Orders",
            actionItem: IconButton(
              onPressed: () {
                // Add menu or settings functionality
              },
              icon: SvgPicture.asset(
                SvgAssets.menuIcon,
                color: AppColors.blackColor,
                width: 24.sp,
                height: 24.sp,
              ),
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp),
            height: 1.sh,
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Status Filter Tabs
                Container(
                  height: 45.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ordersController.orderStatuses.length,
                    separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    itemBuilder: (context, index) {
                      final status = ordersController.orderStatuses[index];
                      final isSelected = ordersController.selectedOrderStatus == status;
                      final orderCount = ordersController.getOrderCountByStatus(status);

                      return InkWell(
                        onTap: () {
                          ordersController.setSelectedOrderStatus(status);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.greyColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customText(
                                status,
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              if (orderCount > 0) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.whiteColor
                                        : AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: customText(
                                    orderCount.toString(),
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.whiteColor,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 24.h),

                // Orders List
                Expanded(
                  child: ordersController.isLoadingOrders
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                      : ordersController.filteredOrders.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SvgAssets.ordersIcon,
                          height: 80.h,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 16.h),
                        customText(
                          "No ${ordersController.selectedOrderStatus.toLowerCase()} orders",
                          color: AppColors.greyColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 8.h),
                        customText(
                          "Orders will appear here when customers place them",
                          color: AppColors.greyColor,
                          fontSize: 14.sp,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    itemCount: ordersController.filteredOrders.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final order = ordersController.filteredOrders[index];
                      return OrderCard(
                        order: order,
                        onTap: () {
                          ordersController.setSelectedOrder(order);
                          Get.toNamed(Routes.ORDER_DETAILS_SCREEN);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Order Card Widget
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    customText(
                      "Customer: ",
                      color: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    customText(
                      order.customerName,
                      color: AppColors.blackColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                customText(
                  Get.find<OrdersController>().formatCurrency(order.total),
                  color: AppColors.blackColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Order ID and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  "Order #${order.id}",
                  color: AppColors.greyColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal,
                ),
                customText(
                  Get.find<OrdersController>().formatOrderTime(order.orderDate),
                  color: AppColors.greyColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Order items preview
            if (order.items.isNotEmpty) ...[
              Row(
                children: [
                  // First item image
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.greyColor.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.asset(
                        order.items.first.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.greyColor.withOpacity(0.2),
                            child: Icon(
                              Icons.fastfood,
                              color: AppColors.greyColor,
                              size: 20.sp,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Items description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          order.items.first.name,
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        customText(
                          "${order.totalItems} item${order.totalItems > 1 ? 's' : ''}",
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ),

                  // Status indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: customText(
                      order.status,
                      color: _getStatusColor(order.status),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 12.h),

            // Delivery address
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.greyColor,
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: customText(
                    order.deliveryAddress,
                    color: AppColors.greyColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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