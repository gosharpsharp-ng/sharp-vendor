import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:sharpvendor/core/models/order_model.dart';
import '../../../core/utils/exports.dart';

class OrdersController extends GetxController {
  // Profile Service Instance (now handles orders integration)
  final ProfileService _profileService = serviceLocator<ProfileService>();

  // Loading states
  bool isLoading = false;
  bool isLoadingOrders = false;

  void setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  setOrdersLoadingState(bool val) {
    isLoadingOrders = val;
    update();
  }

  // Orders list
  List<OrderModel> allOrders = [];
  List<OrderModel> filteredOrders = [];

  // Current selected order
  OrderModel? selectedOrder;

  // Order status filter - Updated to match API statuses
  // Ordered as: pending → paid → preparing → ready → in_transit → completed
  String selectedOrderStatus = 'pending';
  List<String> orderStatuses = [
    'pending',
    'paid',
    'preparing',
    'ready',
    'in_transit',
    'completed',
  ];

  setSelectedOrderStatus(String status) {
    selectedOrderStatus = status;
    filterOrdersByStatus();
    update();
  }

  // Set selected order for details screen
  setSelectedOrder(OrderModel order) {
    selectedOrder = order;
    update();
  }

  // Filter orders by status
  void filterOrdersByStatus() {
    filteredOrders = allOrders
        .where(
          (order) =>
              order.status.toLowerCase() == selectedOrderStatus.toLowerCase(),
        )
        .toList();
  }

  // Get orders from API - UPDATED WITH API INTEGRATION
  getOrders() async {
    setOrdersLoadingState(true);

    try {
      final response = await _profileService.getAllOrders();

      if (response.status == "success" && response.data != null) {
        // customDebugPrint(response.data);
        final List<dynamic> ordersData = response.data['data'] ?? [];

        allOrders = ordersData
            .map((json) => OrderModel.fromJson(json))
            .toList();
        filterOrdersByStatus();
      } else {
        // Keep existing sample data as fallback
        if (allOrders.isEmpty) {
          filterOrdersByStatus();
        }

        if (response.message.isNotEmpty && response.message.isNotEmpty) {
          showToast(message: response.message, isError: true);
        }
      }
    } catch (e) {
      // Keep existing sample data as fallback
      if (allOrders.isEmpty) {
        filterOrdersByStatus();
      }
      showToast(
        message: "Error loading orders: ${e.toString()}",
        isError: true,
      );
    } finally {
      setOrdersLoadingState(false);
    }
  }

  // Update order status - UPDATED WITH API INTEGRATION
  updateOrderStatus(int orderId, String newStatus) async {
    setLoadingState(true);

    try {
      // Prepare data in the required format
      final Map<String, dynamic> statusData = {
        "status": newStatus.toLowerCase(),
      };

      // Call the API
      final response = await _profileService.updateOrderStatus(
        statusData,
        orderId,
      );

      if (response.status == "success") {
        // Update in local list
        int index = allOrders.indexWhere((order) => order.id == orderId);
        if (index != -1) {
          DateTime now = DateTime.now();

          allOrders[index] = allOrders[index].copyWith(
            status: newStatus,
            updatedAt: now,
            // Set status-specific timestamps based on the new status
            confirmedAt:
                newStatus.toLowerCase() == 'preparing' &&
                    allOrders[index].confirmedAt == null
                ? now
                : allOrders[index].confirmedAt,
            completedAt:
                newStatus.toLowerCase() == 'completed' &&
                    allOrders[index].completedAt == null
                ? now
                : allOrders[index].completedAt,
            cancelledAt:
                newStatus.toLowerCase() == 'cancelled' &&
                    allOrders[index].cancelledAt == null
                ? now
                : allOrders[index].cancelledAt,
          );

          // Update selected order if it's the same
          if (selectedOrder?.id == orderId) {
            selectedOrder = allOrders[index];
          }
        }

        filterOrdersByStatus();
        showToast(
          message:
              "Order status updated to ${_getStatusDisplayText(newStatus)}",
          isError: false,
        );
      } else {
        showToast(
          message: response.message ?? "Failed to update order status",
          isError: true,
        );
      }
    } catch (e) {
      showToast(
        message: "Error updating order status: ${e.toString()}",
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Alternative method if you prefer to update by order reference
  updateOrderStatusByRef(String orderRef, String newStatus) async {
    // Find order by reference first
    final order = allOrders.firstWhereOrNull((order) => order.ref == orderRef);
    if (order != null) {
      await updateOrderStatus(order.id, newStatus);
    } else {
      showToast(message: "Order not found", isError: true);
    }
  }

  // Helper method for status display text
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

  // Enhanced method with status transition validation
  updateOrderStatusWithValidation(int orderId, String newStatus) async {
    setLoadingState(true);

    try {
      // Find the order
      int index = allOrders.indexWhere((order) => order.id == orderId);
      if (index == -1) {
        showToast(message: "Order not found", isError: true);
        return;
      }

      String currentStatus = allOrders[index].status.toLowerCase();
      String targetStatus = newStatus.toLowerCase();

      // Validate status transition (optional - customize based on your business logic)
      if (!_isValidStatusTransition(currentStatus, targetStatus)) {
        showToast(
          message:
              "Invalid status transition from $currentStatus to $targetStatus",
          isError: true,
        );
        return;
      }

      // Call the regular update method
      await updateOrderStatus(orderId, newStatus);
    } catch (e) {
      showToast(
        message: "Error updating order status: ${e.toString()}",
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  // Helper method to validate status transitions
  // Updated to match business requirements:
  // - From "paid" → can go to "preparing" OR "rejected"
  // - From "preparing" → can go to "ready"
  // - From "ready" → can go to "in_transit" (when rider picks up)
  // - From "in_transit" → can go to "completed"
  bool _isValidStatusTransition(String currentStatus, String newStatus) {
    // Define valid transitions based on business requirements
    Map<String, List<String>> validTransitions = {
      'paid': ['preparing', 'rejected'],
      'preparing': ['ready'],
      'ready': ['in_transit'], // Can transition to in_transit when rider picks up
      'in_transit': ['completed'], // Can be marked completed
      'rejected': [], // No transitions from rejected
      'completed': [], // No transitions from completed
      'cancelled': [], // No transitions from cancelled
    };

    return validTransitions[currentStatus]?.contains(newStatus) ?? false;
  }

  // Specific order action methods - UPDATED TO MATCH BUSINESS REQUIREMENTS
  // From "paid" → accept to "preparing"
  acceptOrder(int orderId) async {
    await updateOrderStatusWithValidation(orderId, "preparing");
  }

  // From "paid" → reject to "rejected"
  rejectOrder(int orderId) async {
    await updateOrderStatusWithValidation(orderId, "rejected");
    Get.back(); // Go back if on order details screen
  }

  // From "preparing" → mark as "ready"
  markOrderReady(int orderId) async {
    await updateOrderStatusWithValidation(orderId, "ready");
  }

  // Legacy methods kept for backward compatibility (not used in new flow)
  startPreparingOrder(int orderId) async {
    await updateOrderStatus(orderId, "preparing");
  }

  markOrderInTransit(int orderId) async {
    await updateOrderStatus(orderId, "in_transit");
  }

  completeOrder(int orderId) async {
    await updateOrderStatus(orderId, "completed");
  }

  cancelOrder(int orderId) async {
    await updateOrderStatus(orderId, "cancelled");
  }

  // Get single order by ID - NEW METHOD
  getOrderById(int orderId) async {
    setLoadingState(true);

    try {
      final response = await _profileService.getOrderById({'id': orderId});

      if (response.status == "success" && response.data != null) {
        final orderData = response.data;
        final order = OrderModel.fromJson(orderData);

        // Update the order in local list if it exists
        int index = allOrders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          allOrders[index] = order;
        }

        setSelectedOrder(order);
        return order;
      } else {
        showToast(
          message: response.message ?? "Failed to load order details",
          isError: true,
        );
        return null;
      }
    } catch (e) {
      showToast(
        message: "Error loading order details: ${e.toString()}",
        isError: true,
      );
      return null;
    } finally {
      setLoadingState(false);
    }
  }

  // Get order count by status
  int getOrderCountByStatus(String status) {
    return allOrders
        .where((order) => order.status.toLowerCase() == status.toLowerCase())
        .length;
  }

  // Format order time
  String formatOrderTime(DateTime orderDate) {
    final now = DateTime.now();
    final difference = now.difference(orderDate);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inDays}d ago";
    }
  }

  // Format currency
  String formatCurrency(double amount) {
    return formatToCurrency(amount);
  }

  // Get next action for order based on current status
  // Updated to match business requirements:
  // - paid → "Accept Order" (goes to preparing)
  // - preparing → "Mark as Ready" (goes to ready)
  // - ready → no action allowed
  String getNextAction(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'paid':
        return 'Accept Order';
      case 'preparing':
        return 'Mark as Ready';
      case 'ready':
        return 'Order Ready'; // No action allowed, just display status
      default:
        return 'View Order';
    }
  }

  // Get next status for order - UPDATED TO MATCH BUSINESS REQUIREMENTS
  String getNextStatus(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'paid':
        return 'preparing';
      case 'preparing':
        return 'ready';
      case 'ready':
        return 'ready'; // No further transitions
      default:
        return currentStatus;
    }
  }

  // Refresh orders
  refreshOrders() async {
    await getOrders();
  }

  // Initialize WebSocket listener for new orders
  void _initializeOrderNotifications() {
    try {
      if (Get.isRegistered<SocketService>()) {
        final socketService = Get.find<SocketService>();

        // Listen for new incoming orders
        socketService.listenForNewOrders((orderData) {
          _handleNewOrderNotification(orderData);
        });
      }
    } catch (e) {
      debugPrint('Error initializing order notifications: $e');
    }
  }

  // Handle new order notification
  void _handleNewOrderNotification(Map<String, dynamic> orderData) {
    try {
      // Play notification sound (similar to go-rider)
      FlutterRingtonePlayer().playNotification();

      // Show new order dialog
      _showNewOrderDialog(orderData);

      // Refresh orders list to include the new order
      getOrders();
    } catch (e) {
      debugPrint('Error handling new order notification: $e');
    }
  }

  // Show new order notification dialog
  void _showNewOrderDialog(Map<String, dynamic> orderData) {
    final orderId = orderData['orderId'] ?? 0;
    final orderNumber = orderData['orderNumber'] ?? 'N/A';
    final total = orderData['total'] ?? '0.00';
    final currency = orderData['currency'] ?? 'NGN';

    // Extract first package/item info for "From" and "To" display
    final packages = orderData['packages'] as List<dynamic>? ?? [];
    final items = orderData['items'] as List<dynamic>? ?? [];

    String itemsInfo = '';
    if (packages.isNotEmpty) {
      final firstPackage = packages[0];
      itemsInfo =
          '${firstPackage['name'] ?? 'Item'} x${firstPackage['quantity'] ?? 1}';
      if (packages.length > 1) {
        itemsInfo += ' + ${packages.length - 1} more';
      }
    } else if (items.isNotEmpty) {
      final firstItem = items[0];
      itemsInfo =
          '${firstItem['name'] ?? 'Item'} x${firstItem['quantity'] ?? 1}';
      if (items.length > 1) {
        itemsInfo += ' + ${items.length - 1} more';
      }
    }

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bike icon at the top
                Container(
                  width: 80.sp,
                  height: 80.sp,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107), // Yellow color
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 50.sp,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                customText(
                  'New Incoming Order',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 24.h),

                // Order info rows
                _buildOrderInfoRow('Order Number', orderNumber),
                SizedBox(height: 16.h),
                _buildOrderInfoRow('Amount', '$currency $total'),
                SizedBox(height: 16.h),
                _buildOrderInfoRow(
                  'Items',
                  itemsInfo.isEmpty ? 'View details' : itemsInfo,
                ),
                SizedBox(height: 16.h),
                _buildOrderInfoRow('Status', 'Pending'),
                SizedBox(height: 24.h),

                // View Order link
                InkWell(
                  onTap: () async {
                    FlutterRingtonePlayer().stop();
                    Get.back(); // Close dialog
                    await getOrderById(orderId);
                    if (selectedOrder != null) {
                      Get.toNamed(Routes.ORDER_DETAILS_SCREEN);
                    }
                  },
                  child: customText(
                    'View Order',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenColor,
                    // textDecoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 24.h),

                // Action buttons
                Row(
                  children: [
                    // Decline button
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          FlutterRingtonePlayer().stop();
                          Get.back();
                          await updateOrderStatus(orderId, 'rejected');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5E5), // Light red
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: customText(
                              'Decline',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD32F2F), // Red text
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Accept button
                    Expanded(
                      child: InkWell(
                        onTap: isLoading
                            ? null
                            : () async {
                                FlutterRingtonePlayer().stop();
                                Get.back();
                                await updateOrderStatus(orderId, 'ready');
                              },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32), // Dark green
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: isLoading
                                ? SizedBox(
                                    width: 20.sp,
                                    height: 20.sp,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.whiteColor,
                                      ),
                                    ),
                                  )
                                : customText(
                                    'Accept',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Helper method to build order info rows
  Widget _buildOrderInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.obscureTextColor,
        ),
        Flexible(
          child: customText(
            value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    getOrders();
    _initializeOrderNotifications();
  }

  @override
  void onClose() {
    // Stop listening for new orders when controller is disposed
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().stopListeningForNewOrders();
    }
    super.onClose();
  }
}
