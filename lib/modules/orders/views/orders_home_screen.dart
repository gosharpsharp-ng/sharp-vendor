import 'package:sharpvendor/core/models/order_model.dart';
import 'package:sharpvendor/core/utils/widgets/skeleton_loaders.dart';
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
                      final isSelected =
                          ordersController.selectedOrderStatus == status;
                      final orderCount = ordersController.getOrderCountByStatus(
                        status,
                      );
                      final displayName = _getStatusDisplayName(status);

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
                                  : AppColors.greyColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customText(
                                displayName,
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await ordersController.refreshOrders();
                    },
                    color: AppColors.primaryColor,
                    backgroundColor: AppColors.whiteColor,
                    strokeWidth: 2.5,
                    displacement: 40.0,
                    child: ordersController.isLoadingOrders
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              child: SkeletonLoaders.orderItem(count: 1),
                            ),
                          )
                        : ordersController.filteredOrders.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 100.h),
                              _buildEmptyState(
                                ordersController.selectedOrderStatus,
                              ),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: ordersController.filteredOrders.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final order =
                                  ordersController.filteredOrders[index];
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(status),
              size: 40.sp,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 16.h),
          customText(
            "No ${_getStatusDisplayName(status).toLowerCase()} orders",
            color: AppColors.greyColor,
            overflow: TextOverflow.visible,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          customText(
            _getEmptyStateMessage(status),
            color: AppColors.greyColor,
            overflow: TextOverflow.visible,
            fontSize: 14.sp,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return 'All';
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'delivered':
        return 'Delivered';
      case 'in_transit':
        return 'In Transit';
      case 'completed':
        return 'Completed';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return Icons.list;
      case 'pending':
        return Icons.access_time;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.check_circle;
      case 'delivered':
        return Icons.done_all;
      case 'in_transit':
        return Icons.motorcycle_sharp;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.receipt;
    }
  }

  String _getEmptyStateMessage(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return 'All orders will appear here when customers place them';
      case 'pending':
        return 'New orders will appear here when customers place them';
      case 'confirmed':
        return 'Confirmed orders will appear here after acceptance';
      case 'preparing':
        return 'Orders being prepared will show here';
      case 'ready':
        return 'Orders ready for pickup/delivery will appear here';
      case 'delivered':
        return 'Successfully delivered orders will be listed here';
      case 'in_transit':
        return 'Orders out for delivery will be tracked here';
      case 'completed':
        return 'Successfully completed orders will be listed here';
      default:
        return 'Orders will appear here when customers place them';
    }
  }
}

// Beautiful Flat OrderCard Widget
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _getStatusColor(order.status).withValues(alpha: 0.15),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Status badge and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(order.status),
                          color: AppColors.whiteColor,
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        customText(
                          _getStatusDisplayText(order.status),
                          color: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  customText(
                    controller.formatCurrency(order.total),
                    color: AppColors.blackColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Order reference and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    "Order #${order.ref}",
                    color: AppColors.blackColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  customText(
                    controller.formatOrderTime(order.createdAt),
                    color: AppColors.greyColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Customer info section
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        order.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: customText(
                        _getCustomerInitial(),
                        color: _getStatusColor(order.status),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          _getCustomerName(),
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        if (order.allItems.isNotEmpty)
                          customText(
                            "${order.allItems.length} item${order.allItems.length > 1 ? 's' : ''} • ${order.allItems.map((e) => e.quantity).reduce((a, b) => a + b)} qty",
                            color: AppColors.greyColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // Items preview - Show packages or items
              if (order.packages.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        color: AppColors.greyColor,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: customText(
                          order.packages.first.name +
                              (order.packages.length > 1
                                  ? " + ${order.packages.length - 1} more"
                                  : ""),
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (order.items.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        color: AppColors.greyColor,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: customText(
                          order.items.first.name +
                              (order.items.length > 1
                                  ? " + ${order.items.length - 1} more"
                                  : ""),
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Delivery address or notes
              if (order.deliveryLocation != null || order.notes.isNotEmpty) ...[
                SizedBox(height: 8.h),
                if (order.deliveryLocation != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.greyColor,
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: customText(
                          order.deliveryLocation!.name,
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (order.notes.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.sticky_note_2,
                        color: AppColors.greyColor,
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: customText(
                          order.notes,
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.check_circle;
      case 'delivered':
        return Icons.done_all;
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.lightGreen;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'delivered':
        return Colors.teal;
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
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'delivered':
        return 'Delivered';
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

  // Helper methods to get customer info from order
  String _getCustomerName() {
    return order.customerName.isNotEmpty
        ? order.customerName
        : "Customer #${order.userId}";
  }

  String _getCustomerInitial() {
    return order.customerInitials.isNotEmpty ? order.customerInitials : "C";
  }
}
