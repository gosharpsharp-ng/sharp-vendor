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
          id: "12345",
          customerId: "customer_1",
          customerName: "Alex",
          customerPhone: "+234 801 234 5678",
          deliveryAddress: "123 Main St, Anytown",
          total: 25.00,
          status: "Pending",
          totalItems: 3,
          orderDate: DateTime.now().subtract(const Duration(minutes: 15)),
          estimatedDeliveryTime: "25-30 mins",
          items: [
            OrderItemModel(
              id: "item_1",
              name: "Spicy Chicken Sandwich",
              quantity: 1,
              price: 15.00,
              image: "assets/imgs/chicken_sandwich.png",
              specialInstructions: "",
            ),
            OrderItemModel(
              id: "item_2",
              name: "Fries",
              quantity: 2,
              price: 5.00,
              image: "assets/imgs/fries.png",
              specialInstructions: "Extra crispy",
            ),
          ],
        ),
        OrderModel(
          id: "78901",
          customerId: "customer_2",
          customerName: "Jordan",
          customerPhone: "+234 802 345 6789",
          deliveryAddress: "456 Oak Ave, Downtown",
          total: 30.00,
          status: "Accepted",
          totalItems: 2,
          orderDate: DateTime.now().subtract(const Duration(minutes: 30)),
          estimatedDeliveryTime: "20-25 mins",
          items: [
            OrderItemModel(
              id: "item_3",
              name: "Efo riro",
              quantity: 1,
              price: 20.00,
              image: "assets/imgs/efo_riro.png",
              specialInstructions: "Medium spice level",
            ),
            OrderItemModel(
              id: "item_4",
              name: "Rice",
              quantity: 1,
              price: 10.00,
              image: "assets/imgs/rice.png",
              specialInstructions: "",
            ),
          ],
        ),
        OrderModel(
          id: "34567",
          customerId: "customer_3",
          customerName: "Taylor",
          customerPhone: "+234 803 456 7890",
          deliveryAddress: "789 Pine Rd, Uptown",
          total: 15.00,
          status: "Processing",
          totalItems: 1,
          orderDate: DateTime.now().subtract(const Duration(hours: 1)),
          estimatedDeliveryTime: "15-20 mins",
          items: [
            OrderItemModel(
              id: "item_5",
              name: "Bitter leaf soup",
              quantity: 1,
              price: 15.00,
              image: "assets/imgs/bitter_leaf.png",
              specialInstructions: "Less salt please",
            ),
          ],
        ),
        OrderModel(
          id: "45678",
          customerId: "customer_4",
          customerName: "Morgan",
          customerPhone: "+234 804 567 8901",
          deliveryAddress: "321 Maple Dr, Westside",
          total: 40.00,
          status: "Ready",
          totalItems: 4,
          orderDate: DateTime.now().subtract(const Duration(hours: 2)),
          estimatedDeliveryTime: "Ready for pickup",
          items: [
            OrderItemModel(
              id: "item_6",
              name: "Assorted vegetable soup",
              quantity: 2,
              price: 15.00,
              image: "assets/imgs/vegetable_soup.png",
              specialInstructions: "",
            ),
            OrderItemModel(
              id: "item_7",
              name: "Spaghetti",
              quantity: 2,
              price: 12.50,
              image: "assets/imgs/spaghetti.png",
              specialInstructions: "Extra sauce",
            ),
          ],
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
  updateOrderStatus(String orderId, String newStatus) async {
    setLoadingState(true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Update in local list
      int index = allOrders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        allOrders[index] = OrderModel(
          id: allOrders[index].id,
          customerId: allOrders[index].customerId,
          customerName: allOrders[index].customerName,
          customerPhone: allOrders[index].customerPhone,
          deliveryAddress: allOrders[index].deliveryAddress,
          total: allOrders[index].total,
          status: newStatus,
          totalItems: allOrders[index].totalItems,
          orderDate: allOrders[index].orderDate,
          estimatedDeliveryTime: allOrders[index].estimatedDeliveryTime,
          items: allOrders[index].items,
        );

        // Update selected order if it's the same
        if (selectedOrder?.id == orderId) {
          selectedOrder = allOrders[index];
        }
      }

      filterOrdersByStatus();
      showToast(message: "Order status updated to $newStatus", isError: false);
    } catch (e) {
      showToast(message: "Error updating order status", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Accept order
  acceptOrder(String orderId) async {
    await updateOrderStatus(orderId, "Accepted");
  }

  // Start processing order
  startProcessingOrder(String orderId) async {
    await updateOrderStatus(orderId, "Processing");
  }

  // Mark order as ready
  markOrderReady(String orderId) async {
    await updateOrderStatus(orderId, "Ready");
  }

  // Complete order
  completeOrder(String orderId) async {
    await updateOrderStatus(orderId, "Completed");
  }

  // Reject order
  rejectOrder(String orderId) async {
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