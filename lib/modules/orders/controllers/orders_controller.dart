import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
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
  // Ordered as: pending → paid → confirmed → preparing → ready → in_transit → completed
  String selectedOrderStatus = 'pending';
  List<String> orderStatuses = [
    'pending',
    'paid',
    'confirmed',
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
        // Handle pagination structure: API returns data.data as pagination object
        final ordersData = response.data['data'];

        if (ordersData is Map) {
          // Paginated response: data.data.data contains the actual orders array
          final List<dynamic> ordersList = ordersData['data'] ?? [];
          allOrders = ordersList
              .map((json) => OrderModel.fromJson(json))
              .toList();
        } else if (ordersData is List) {
          // Direct array response (for backward compatibility)
          allOrders = ordersData
              .map((json) => OrderModel.fromJson(json))
              .toList();
        } else {
          debugPrint(
            '❌ Unexpected orders data structure: ${ordersData.runtimeType}',
          );
          allOrders = [];
        }

        filterOrdersByStatus();
      } else {
        // Keep existing orders if any
        if (allOrders.isEmpty) {
          filterOrdersByStatus();
        }

        if (response.message.isNotEmpty) {
          showToast(message: response.message, isError: true);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Exception loading orders: $e');
      debugPrint('Stack trace: $stackTrace');

      // Keep existing orders if any
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
  // Can accept either orderId or orderNumber
  updateOrderStatus(
    dynamic orderIdentifier,
    String action, {
    String? reason,
  }) async {
    setLoadingState(true);

    try {
      String orderNumber;

      // If orderIdentifier is a String, use it directly as orderNumber
      if (orderIdentifier is String) {
        orderNumber = orderIdentifier;
      } else {
        // If it's an int, find the order in the list to get orderNumber
        int orderId = orderIdentifier as int;
        int index = allOrders.indexWhere((order) => order.id == orderId);
        if (index == -1) {
          showToast(message: "Order not found", isError: true);
          setLoadingState(false);
          return;
        }
        orderNumber = allOrders[index].orderNumber;
      }

      debugPrint('🔄 Updating order $orderNumber with action: $action');
      if (reason != null) {
        debugPrint('📝 Cancellation reason: $reason');
      }

      // Call the API with action, order number, and optional reason
      final response = await _profileService.updateOrderStatus(
        action.toLowerCase(), // 'preparing', 'ready', 'cancelled', 'accepted'
        orderNumber,
        reason: reason,
      );

      debugPrint('📦 Update response: ${response.status}');
      debugPrint('📦 Update message: ${response.message}');

      if (response.status == "success") {
        // Refresh orders to get updated data from server
        await getOrders();

        showToast(
          message: "Order status updated to ${_getStatusDisplayText(action)}",
          isError: false,
        );
      } else {
        showToast(
          message: response.message ?? "Failed to update order status",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('❌ Error updating order status: $e');
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
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
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
      case 'rejected':
        return 'Rejected';
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
  // - From "paid" → can go to "confirmed" OR "rejected"
  // - From "confirmed" → can go to "preparing"
  // - From "preparing" → can go to "ready"
  // - From "ready" → can go to "in_transit" (when rider picks up)
  // - From "in_transit" → can go to "completed"
  bool _isValidStatusTransition(String currentStatus, String newStatus) {
    // Define valid transitions based on business requirements
    Map<String, List<String>> validTransitions = {
      'paid': ['confirmed', 'rejected'],
      'confirmed': ['preparing'],
      'preparing': ['ready'],
      'ready': [
        'in_transit',
      ], // Can transition to in_transit when rider picks up
      'in_transit': ['completed'], // Can be marked completed
      'rejected': [], // No transitions from rejected
      'completed': [], // No transitions from completed
      'cancelled': [], // No transitions from cancelled
    };

    return validTransitions[currentStatus]?.contains(newStatus) ?? false;
  }

  // Specific order action methods - UPDATED TO MATCH BUSINESS REQUIREMENTS
  // From "paid" → accept to "confirmed"
  acceptOrder(int orderId) async {
    await updateOrderStatusWithValidation(orderId, "confirmed");
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
  Future<OrderModel?> getOrderById(int orderId) async {
    debugPrint('🔍 getOrderById called with orderId: $orderId');
    setLoadingState(true);

    try {
      final response = await _profileService.getOrderById({'id': orderId});
      debugPrint('📦 API Response status: ${response.status}');
      debugPrint('📦 API Response data: ${response.data}');

      if (response.status == "success" && response.data != null) {
        // The API returns data wrapped in an 'order' key
        // Extract the actual order data from the wrapper
        final orderData = response.data['order'] ?? response.data;

        // Print raw order data to see what we received
        debugPrint('📋 Raw Order Data: $orderData');

        final order = OrderModel.fromJson(orderData);

        debugPrint('✅ Order parsed successfully');
        debugPrint('   📦 Order Number: ${order.orderNumber}');
        debugPrint('   🆔 Order ID: ${order.id}');
        debugPrint('   📊 Status: ${order.status}');
        debugPrint('   👤 User ID: ${order.userId}');
        // debugPrint('   💰 Total Amount: ${order.to}');
        debugPrint('   📍 Delivery Address: ${order.deliveryAddress}');
        debugPrint('   📦 Packages Count: ${order.packages.length}');
        debugPrint('   📝 Ref: ${order.ref}');

        // Update the order in local list if it exists
        int index = allOrders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          allOrders[index] = order;
          debugPrint('✅ Updated order in allOrders at index $index');
        } else {
          // Add to allOrders if not found
          allOrders.add(order);
          debugPrint('✅ Added new order to allOrders');
        }

        // Set as selected order and trigger update
        selectedOrder = order;
        debugPrint('✅ Set selectedOrder');
        debugPrint(
          '   📦 Selected Order Number: ${selectedOrder?.orderNumber}',
        );
        debugPrint('   🆔 Selected Order ID: ${selectedOrder?.id}');

        // Trigger UI update
        update();
        debugPrint('✅ Called update() to refresh UI');

        return order;
      } else {
        debugPrint('❌ API Response failed: ${response.message}');
        showToast(
          message: response.message ?? "Failed to load order details",
          isError: true,
        );
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Exception in getOrderById: $e');
      debugPrint('Stack trace: $stackTrace');
      showToast(
        message: "Error loading order details: ${e.toString()}",
        isError: true,
      );
      return null;
    } finally {
      setLoadingState(false);
      debugPrint('🏁 getOrderById completed, isLoading: $isLoading');
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
  // - pending → "Accept Order" (goes to confirmed)
  // - confirmed → "Move to Preparing" (goes to preparing)
  // - preparing → "Mark as Ready" (goes to ready)
  // - ready → no action allowed
  String getNextAction(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return 'Accept Order';
      case 'confirmed':
        return 'Move to Preparing';
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
      case 'pending':
        return 'confirmed';
      case 'confirmed':
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
          handleNewOrderNotification(orderData);
        });
      }
    } catch (e) {
      debugPrint('Error initializing order notifications: $e');
    }
  }

  // Handle new order notification (public method for external calls)
  void handleNewOrderNotification(Map<String, dynamic> orderData) {
    try {
      debugPrint('📱 New order notification received!');
      debugPrint('🔔 Playing ringtone and vibrating...');

      // Vibrate the device with a pattern (vibrate, pause, vibrate)
      Vibration.vibrate(
        pattern: [0, 1000, 500, 1000, 500, 1000],
        repeat: 0, // Repeat from index 0 (continuous vibration pattern)
      );

      // Play ringtone (continuous ringing like a phone call)
      FlutterRingtonePlayer().play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.electronic,
        looping: true, // Keep ringing until stopped
        volume: 1.0,
        asAlarm: false,
      );

      debugPrint('✅ Ringtone and vibration started');

      // Show new order dialog
      _showNewOrderDialog(orderData);

      // Refresh orders list to include the new order
      getOrders();
    } catch (e, stackTrace) {
      debugPrint('❌ Error handling new order notification: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  // Show new order notification dialog
  void _showNewOrderDialog(Map<String, dynamic> orderData) {
    // Try multiple possible field names for order ID (camelCase, snake_case, or just 'id')
    final orderId =
        orderData['orderId'] ?? orderData['order_id'] ?? orderData['id'] ?? 0;
    final orderNumber =
        orderData['orderNumber'] ??
        orderData['order_number'] ??
        orderData['ref'] ??
        'N/A';
    final total = orderData['total'] ?? '0.00';
    final currency = orderData['currency'] ?? 'NGN';

    // Debug: Log the order data to see what fields are available
    debugPrint('📦 New Order WebSocket Data: $orderData');
    debugPrint('📦 Extracted Order ID: $orderId');

    // Validate order ID
    if (orderId == 0) {
      debugPrint('❌ Invalid order ID received from WebSocket');
      showToast(message: "Invalid order data received", isError: true);
      return;
    }

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
        child: StatefulBuilder(
          builder: (context, setState) {
            bool isLoadingViewDetails = false;
            bool isLoadingAccept = false;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Container(
                padding: EdgeInsets.all(24.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon at the top
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

                    // View Details button - Simple and clear
                    InkWell(
                      onTap: (isLoadingViewDetails || isLoadingAccept)
                          ? null
                          : () async {
                              setState(() {
                                isLoadingViewDetails = true;
                              });

                              // Stop ringtone and vibration
                              FlutterRingtonePlayer().stop();
                              Vibration.cancel();

                              // Fetch the full order details
                              debugPrint(
                                '🔍 Fetching order details for ID: $orderId',
                              );
                              final order = await getOrderById(orderId);

                              setState(() {
                                isLoadingViewDetails = false;
                              });

                              if (order != null) {
                                debugPrint(
                                  '✅ Order fetched successfully: ${order.orderNumber}',
                                );
                                debugPrint(
                                  '✅ Selected order is set: ${selectedOrder?.orderNumber}',
                                );
                                debugPrint(
                                  '✅ Navigating to order details screen...',
                                );

                                // Close dialog and navigate
                                Get.back();
                                Get.toNamed(Routes.ORDER_DETAILS_SCREEN);
                              } else {
                                debugPrint('❌ Failed to fetch order details');
                                showToast(
                                  message:
                                      "Unable to load order details. Please try again.",
                                  isError: true,
                                );
                              }
                            },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: isLoadingViewDetails
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
                                  'View Details',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Action buttons
                    Row(
                      children: [
                        // Decline button
                        Expanded(
                          child: InkWell(
                            onTap: (isLoadingViewDetails || isLoadingAccept)
                                ? null
                                : () {
                                    // Stop ringtone and vibration
                                    FlutterRingtonePlayer().stop();
                                    Vibration.cancel();
                                    Get.back();

                                    // Show reason dialog
                                    _showCancellationReasonDialog(orderNumber);
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
                            onTap: (isLoadingViewDetails || isLoadingAccept)
                                ? null
                                : () async {
                                    setState(() {
                                      isLoadingAccept = true;
                                    });

                                    // Stop ringtone and vibration
                                    FlutterRingtonePlayer().stop();
                                    Vibration.cancel();

                                    // Update order status to confirmed
                                    await updateOrderStatus(
                                      orderNumber,
                                      'confirmed',
                                    );

                                    // Fetch the order details and navigate to details screen
                                    final order = await getOrderById(orderId);

                                    setState(() {
                                      isLoadingAccept = false;
                                    });

                                    // Close dialog
                                    Get.back();

                                    if (order != null) {
                                      // Navigate to main app with Orders tab selected
                                      Get.offAllNamed(
                                        Routes.APP_NAVIGATION,
                                        arguments: {'initialIndex': 2},
                                      );
                                      // Small delay to ensure navigation is loaded
                                      await Future.delayed(
                                        const Duration(milliseconds: 300),
                                      );
                                      // Then navigate to order details
                                      Get.toNamed(Routes.ORDER_DETAILS_SCREEN);
                                    } else {
                                      Get.offAllNamed(
                                        Routes.APP_NAVIGATION,
                                        arguments: {'initialIndex': 2},
                                      );
                                    }
                                  },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32), // Dark green
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Center(
                                child: isLoadingAccept
                                    ? SizedBox(
                                        width: 20.sp,
                                        height: 20.sp,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Show cancellation reason dialog
  void _showCancellationReasonDialog(String orderNumber) {
    final TextEditingController reasonController = TextEditingController();
    final List<String> commonReasons = [
      "Out of ingredients",
      "Kitchen is too busy",
      "Item not available",
      "Restaurant closing soon",
      "Unable to prepare",
    ];

    String? selectedReason;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              customText(
                'Reason for Cancellation',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
              SizedBox(height: 16.h),

              // Common reasons
              customText(
                'Select a reason:',
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
              SizedBox(height: 8.h),

              // Reason chips
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: commonReasons.map((reason) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      final isSelected = selectedReason == reason;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedReason = reason;
                            reasonController.text = reason;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor.withValues(alpha: 0.1)
                                : AppColors.greyColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: customText(
                            reason,
                            fontSize: 13.sp,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.blackColor,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 16.h),

              // Or custom reason
              customText(
                'Or enter custom reason:',
                fontSize: 14.sp,
                color: AppColors.greyColor,
              ),
              SizedBox(height: 8.h),

              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter cancellation reason...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                ),
                onChanged: (value) {
                  selectedReason = value;
                },
              ),

              SizedBox(height: 20.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: customText(
                            'Cancel',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final reason = reasonController.text.trim();
                        if (reason.isEmpty) {
                          showToast(
                            message: 'Please provide a cancellation reason',
                            isError: true,
                          );
                          return;
                        }

                        Get.back();

                        // Update order status with reason
                        await updateOrderStatus(
                          orderNumber,
                          'cancelled',
                          reason: reason,
                        );

                        // Navigate to main app with Orders tab selected
                        Get.offAllNamed(
                          Routes.APP_NAVIGATION,
                          arguments: {'initialIndex': 2},
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD32F2F),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: customText(
                            'Confirm',
                            fontSize: 15.sp,
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
      barrierDismissible: false,
    );
  }

  // Helper method to build order info rows
  Widget _buildOrderInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          label,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.obscureTextColor,
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: customText(
            value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
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
