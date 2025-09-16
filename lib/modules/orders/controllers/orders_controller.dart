import 'dart:async';
import 'package:sharpvendor/core/models/order_model.dart';
import '../../../core/utils/exports.dart';

class OrdersController extends GetxController {
  // Loading states
  bool isLoading = false;
  bool isLoadingOrders = false;

  setLoadingState(bool val) {
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

  // Order status filter
  String selectedOrderStatus = 'Pending';
  List<String> orderStatuses = ['Pending', 'Accepted', 'Processing', 'Ready'];

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
        .where((order) => order.status.toLowerCase() == selectedOrderStatus.toLowerCase())
        .toList();
  }

  // Get orders from API
  getOrders() async {
    setOrdersLoadingState(true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Sample data - replace with actual API response
      allOrders = [
        OrderModel(
          id: 1,
          orderableType: "App\\Models\\Restaurant",
          orderableId: 1,
          userId: 1,
          ref: "ORD-12345ABC",
          status: "pending",
          subtotal: 23.00,
          tax: 0.00,
          deliveryFee: 2.00,
          notes: "",
          discountAmount: 0.00,
          paymentReference: "ORDER-ORD-12345ABC",
          total: 25.00,
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          items: [
            OrderItemModel(
              id: 1,
              orderId: 1,
              orderableType: "App\\Models\\RestaurantMenu",
              orderableId: 1,
              quantity: 1,
              price: 15.00,
              total: 15.00,
              createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
              updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
              orderable: OrderableItemModel(
                id: 1,
                restaurantId: 1,
                name: "Spicy Chicken Sandwich",
                description: "Delicious spicy chicken sandwich",
                plateSize: "L",
                quantity: 1,
                isAvailable: true,
                price: 15.00,
                prepTimeMinutes: 15,
                categoryId: 1,
                isPublished: true,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ),
            OrderItemModel(
              id: 2,
              orderId: 1,
              orderableType: "App\\Models\\RestaurantMenu",
              orderableId: 2,
              quantity: 2,
              price: 4.00,
              total: 8.00,
              createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
              updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
              orderable: OrderableItemModel(
                id: 2,
                restaurantId: 1,
                name: "Fries",
                description: "Crispy golden fries",
                plateSize: "M",
                quantity: 1,
                isAvailable: true,
                price: 4.00,
                prepTimeMinutes: 10,
                categoryId: 2,
                isPublished: true,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
              options: {"instructions": "Extra crispy"},
            ),
          ],
          user: OrderUserModel(
            id: 1,
            fname: "Alex",
            lname: "",
            phone: "+234 801 234 5678",
            email: "alex@example.com",
            status: "verified",
            referralCode: "ALEX123",
            failedLoginAttempts: 0,
            createdAt: DateTime.now().subtract(const Duration(days: 30)),
            updatedAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          deliveryLocation: DeliveryLocationModel(
            id: 1,
            name: "123 Main St, Anytown",
            latitude: 6.5244,
            longitude: 3.3792,
            locationableType: "App\\Models\\Order",
            locationableId: 1,
            createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
            updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          ),
        ),
        OrderModel(
          id: 2,
          orderableType: "App\\Models\\Restaurant",
          orderableId: 1,
          userId: 2,
          ref: "ORD-78901DEF",
          status: "accepted",
          subtotal: 30.00,
          tax: 0.00,
          deliveryFee: 0.00,
          notes: "",
          discountAmount: 0.00,
          paymentReference: "ORDER-ORD-78901DEF",
          total: 30.00,
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 25)),
          items: [
            OrderItemModel(
              id: 3,
              orderId: 2,
              orderableType: "App\\Models\\RestaurantMenu",
              orderableId: 3,
              quantity: 1,
              price: 20.00,
              total: 20.00,
              createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
              updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
              orderable: OrderableItemModel(
                id: 3,
                restaurantId: 1,
                name: "Efo riro",
                description: "Traditional Nigerian vegetable soup",
                plateSize: "L",
                quantity: 1,
                isAvailable: true,
                price: 20.00,
                prepTimeMinutes: 25,
                categoryId: 3,
                isPublished: true,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
              options: {"spice_level": "Medium"},
            ),
            OrderItemModel(
              id: 4,
              orderId: 2,
              orderableType: "App\\Models\\RestaurantMenu",
              orderableId: 4,
              quantity: 1,
              price: 10.00,
              total: 10.00,
              createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
              updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
              orderable: OrderableItemModel(
                id: 4,
                restaurantId: 1,
                name: "Rice",
                description: "Steamed white rice",
                plateSize: "M",
                quantity: 1,
                isAvailable: true,
                price: 10.00,
                prepTimeMinutes: 15,
                categoryId: 4,
                isPublished: true,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ),
          ],
          user: OrderUserModel(
            id: 2,
            fname: "Jordan",
            lname: "",
            phone: "+234 802 345 6789",
            email: "jordan@example.com",
            status: "verified",
            referralCode: "JORDAN456",
            failedLoginAttempts: 0,
            createdAt: DateTime.now().subtract(const Duration(days: 60)),
            updatedAt: DateTime.now().subtract(const Duration(days: 60)),
          ),
          deliveryLocation: DeliveryLocationModel(
            id: 2,
            name: "456 Oak Ave, Downtown",
            latitude: 6.4584,
            longitude: 3.3890,
            locationableType: "App\\Models\\Order",
            locationableId: 2,
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
            updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ),
        OrderModel(
          id: 3,
          orderableType: "App\\Models\\Restaurant",
          orderableId: 1,
          userId: 3,
          ref: "ORD-34567GHI",
          status: "processing",
          subtotal: 15.00,
          tax: 0.00,
          deliveryFee: 0.00,
          notes: "Less salt please",
          discountAmount: 0.00,
          paymentReference: "ORDER-ORD-34567GHI",
          total: 15.00,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 45)),
          items: [
            OrderItemModel(
              id: 5,
              orderId: 3,
              orderableType: "App\\Models\\RestaurantMenu",
              orderableId: 5,
              quantity: 1,
              price: 15.00,
              total: 15.00,
              createdAt: DateTime.now().subtract(const Duration(hours: 1)),
              updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
              orderable: OrderableItemModel(
                id: 5,
                restaurantId: 1,
                name: "Bitter leaf soup",
                description: "Traditional bitter leaf soup",
                plateSize: "M",
                quantity: 1,
                isAvailable: true,
                price: 15.00,
                prepTimeMinutes: 30,
                categoryId: 3,
                isPublished: true,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
              options: {"salt_level": "Less salt"},
            ),
          ],
          user: OrderUserModel(
            id: 3,
            fname: "Taylor",
            lname: "",
            phone: "+234 803 456 7890",
            email: "taylor@example.com",
            status: "verified",
            referralCode: "TAYLOR789",
            failedLoginAttempts: 0,
            createdAt: DateTime.now().subtract(const Duration(days: 45)),
            updatedAt: DateTime.now().subtract(const Duration(days: 45)),
          ),
          deliveryLocation: DeliveryLocationModel(
            id: 3,
            name: "789 Pine Rd, Uptown",
            latitude: 6.5025,
            longitude: 3.3675,
            locationableType: "App\\Models\\Order",
            locationableId: 3,
            createdAt: DateTime.now().subtract(const Duration(hours: 1)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          ),
        ),
        OrderModel(
          id: 4,
          orderableType: "App\\Models\\Restaurant",
          orderableId: 1,
          userId: 4,
          ref: "ORD-45678JKL",
          status: "ready",
          subtotal: 40.00,
          tax: 0.00,
          deliveryFee: 0.00,
          notes: "",
          discountAmount: 0.00,
          paymentReference: "ORDER-ORD-45678JKL",
          total: 40.00,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
          items: [
            OrderItemModel(
              id: 6,
              orderId: 4,
              orderableType: "App\\Models\\RestaurantMenu",
              orderableId: 6,
              quantity: 2,
              price: 15.00,
              total: 30.00,
              createdAt: DateTime.now().subtract(const Duration(hours: 2)),
              updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
              orderable: OrderableItemModel(
                id: 6,
                restaurantId: 1,
                name: "Assorted vegetable soup",
                description: "Mixed vegetable soup with meat",
                plateSize: "L",
                quantity: 1,
                isAvailable: true,
                price: 15.00,
                prepTimeMinutes: 35,
                categoryId: 3,
                isPublished: true,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
            ),
            OrderItemModel(
              id: 7,
              orderId: 4,
              orderableType: "App\\Models\\RestaurantMenu",
              orderableId: 7,
              quantity: 2,
              price: 5.00,
              total: 10.00,
              createdAt: DateTime.now().subtract(const Duration(hours: 2)),
              updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
              orderable: OrderableItemModel(
                id: 7,
                restaurantId: 1,
                name: "Spaghetti",
                description: "Classic spaghetti with tomato sauce",
                plateSize: "M",
                quantity: 1,
                isAvailable: true,
                price: 5.00,
                prepTimeMinutes: 20,
                categoryId: 4,
                isPublished: true,
                createdAt: DateTime.now().subtract(const Duration(days: 1)),
                updatedAt: DateTime.now().subtract(const Duration(days: 1)),
              ),
              options: {"sauce": "Extra sauce"},
            ),
          ],
          user: OrderUserModel(
            id: 4,
            fname: "Morgan",
            lname: "",
            phone: "+234 804 567 8901",
            email: "morgan@example.com",
            status: "verified",
            referralCode: "MORGAN012",
            failedLoginAttempts: 0,
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
            updatedAt: DateTime.now().subtract(const Duration(days: 90)),
          ),
          deliveryLocation: DeliveryLocationModel(
            id: 4,
            name: "321 Maple Dr, Westside",
            latitude: 6.4895,
            longitude: 3.3445,
            locationableType: "App\\Models\\Order",
            locationableId: 4,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ),
      ];

      filterOrdersByStatus();
    } catch (e) {
      showToast(message: "Error loading orders", isError: true);
    } finally {
      setOrdersLoadingState(false);
    }
  }

  // Update order status
  updateOrderStatus(int orderId, String newStatus) async {
    setLoadingState(true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Update in local list
      int index = allOrders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        // Get current timestamp for updatedAt
        DateTime now = DateTime.now();

        // Use copyWith method for cleaner code
        allOrders[index] = allOrders[index].copyWith(
          status: newStatus,
          updatedAt: now,
          // Set status-specific timestamps based on the new status
          confirmedAt: newStatus == 'accepted' && allOrders[index].confirmedAt == null
              ? now
              : allOrders[index].confirmedAt,
          completedAt: newStatus == 'completed' && allOrders[index].completedAt == null
              ? now
              : allOrders[index].completedAt,
          cancelledAt: newStatus == 'cancelled' && allOrders[index].cancelledAt == null
              ? now
              : allOrders[index].cancelledAt,
        );

        // Update selected order if it's the same
        if (selectedOrder?.id == orderId) {
          selectedOrder = allOrders[index];
        }
      }

      filterOrdersByStatus();
      showToast(message: "Order status updated to ${_getStatusDisplayText(newStatus)}", isError: false);
    } catch (e) {
      showToast(message: "Error updating order status", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

// Alternative method if you prefer to update by order reference
  updateOrderStatusByRef(String orderRef, String newStatus) async {
    setLoadingState(true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Update in local list by reference
      int index = allOrders.indexWhere((order) => order.ref == orderRef);
      if (index != -1) {
        DateTime now = DateTime.now();

        allOrders[index] = allOrders[index].copyWith(
          status: newStatus,
          updatedAt: now,
          confirmedAt: newStatus == 'accepted' && allOrders[index].confirmedAt == null
              ? now
              : allOrders[index].confirmedAt,
          completedAt: newStatus == 'completed' && allOrders[index].completedAt == null
              ? now
              : allOrders[index].completedAt,
          cancelledAt: newStatus == 'cancelled' && allOrders[index].cancelledAt == null
              ? now
              : allOrders[index].cancelledAt,
        );

        // Update selected order if it's the same
        if (selectedOrder?.ref == orderRef) {
          selectedOrder = allOrders[index];
        }
      }

      filterOrdersByStatus();
      showToast(message: "Order status updated to ${_getStatusDisplayText(newStatus)}", isError: false);
    } catch (e) {
      showToast(message: "Error updating order status", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

// Helper method for status display text (add this to your controller)
  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'processing':
        return 'Processing';
      case 'ready':
        return 'Ready';
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
        showToast(message: "Invalid status transition from $currentStatus to $targetStatus", isError: true);
        return;
      }

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      DateTime now = DateTime.now();

      allOrders[index] = allOrders[index].copyWith(
        status: newStatus,
        updatedAt: now,
        confirmedAt: targetStatus == 'accepted' && allOrders[index].confirmedAt == null
            ? now
            : allOrders[index].confirmedAt,
        completedAt: targetStatus == 'completed' && allOrders[index].completedAt == null
            ? now
            : allOrders[index].completedAt,
        cancelledAt: targetStatus == 'cancelled' && allOrders[index].cancelledAt == null
            ? now
            : allOrders[index].cancelledAt,
      );

      // Update selected order if it's the same
      if (selectedOrder?.id == orderId) {
        selectedOrder = allOrders[index];
      }

      filterOrdersByStatus();
      showToast(message: "Order status updated to ${_getStatusDisplayText(newStatus)}", isError: false);
    } catch (e) {
      showToast(message: "Error updating order status: ${e.toString()}", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

// Helper method to validate status transitions (customize based on your business logic)
  bool _isValidStatusTransition(String currentStatus, String newStatus) {
    // Define valid transitions based on your business logic
    Map<String, List<String>> validTransitions = {
      'pending': ['accepted', 'cancelled'],
      'accepted': ['processing', 'cancelled'],
      'processing': ['ready', 'cancelled'],
      'ready': ['completed'],
      'completed': [], // No transitions from completed
      'cancelled': [], // No transitions from cancelled
    };

    return validTransitions[currentStatus]?.contains(newStatus) ?? false;
  }

  // Accept order
  acceptOrder(int orderId) async {
    await updateOrderStatus(orderId, "Accepted");
  }

  // Start processing order
  startProcessingOrder(int orderId) async {
    await updateOrderStatus(orderId, "Processing");
  }

  // Mark order as ready
  markOrderReady(int orderId) async {
    await updateOrderStatus(orderId, "Ready");
  }

  // Complete order
  completeOrder(int orderId) async {
    await updateOrderStatus(orderId, "Completed");
  }

  // Reject order
  rejectOrder(int orderId) async {
    setLoadingState(true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      allOrders.removeWhere((order) => order.id == orderId);
      filterOrdersByStatus();

      showToast(message: "Order rejected successfully", isError: false);
      Get.back(); // Go back if on order details screen
    } catch (e) {
      showToast(message: "Error rejecting order", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Get order count by status
  int getOrderCountByStatus(String status) {
    return allOrders.where((order) => order.status.toLowerCase() == status.toLowerCase()).length;
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
    return "₦${amount.toStringAsFixed(2)}";
  }

  // Get next action for order based on current status
  String getNextAction(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return 'Accept Order';
      case 'accepted':
        return 'Start Processing';
      case 'processing':
        return 'Mark as Ready';
      case 'ready':
        return 'Complete Order';
      default:
        return 'View Order';
    }
  }

  // Get next status for order
  String getNextStatus(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return 'Accepted';
      case 'accepted':
        return 'Processing';
      case 'processing':
        return 'Ready';
      case 'ready':
        return 'Completed';
      default:
        return currentStatus;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  @override
  void onClose() {
    super.onClose();
  }
}